import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../api/syncthing_models.dart';
import 'binary_locator.dart';
import 'syncthing_supervisor.dart';

class BundledSupervisor implements SyncthingSupervisor {
  BundledSupervisor({BinaryLocator? locator})
    : _locator = locator ?? BinaryLocator();

  final BinaryLocator _locator;
  final _statusController = StreamController<EngineStatus>.broadcast();
  final _logController = StreamController<String>.broadcast();
  final _logBuffer = <String>[];

  EngineStatus _current = const EngineStatus(EngineState.idle);
  Process? _process;
  String? _apiKey;
  int _port = 0;
  bool _stopping = false;

  @override
  Stream<EngineStatus> get status => _statusController.stream;

  @override
  EngineStatus get current => _current;

  @override
  Stream<String> get logs => _logController.stream;

  List<String> get bufferedLogs => List.unmodifiable(_logBuffer);

  String get _localUrl => 'http://127.0.0.1:$_port';

  @override
  Future<void> start() async {
    if (_process != null) return;
    _stopping = false;
    _emit(const EngineStatus(EngineState.starting));
    try {
      final binary = await _locator.locate();
      final home = await _homeDir();
      await _killOrphans(binary);
      _apiKey = _randomKey();
      _port = await _freePort();

      if (!await File(p.join(home, 'config.xml')).exists()) {
        await Process.run(binary, ['generate', '--home', home]);
      }

      _process = await Process.start(
        binary,
        ['serve', '--no-browser', '--no-restart', '--home', home],
        environment: {
          'STGUIADDRESS': '127.0.0.1:$_port',
          'STGUIAPIKEY': _apiKey!,
          'STNOUPGRADE': '1',
          'HOME': home,
        },
      );
      _pipe(_process!.stdout);
      _pipe(_process!.stderr);
      unawaited(_process!.exitCode.then(_onExit));

      if (await _awaitHealth()) {
        _emit(EngineStatus(EngineState.running, endpoint: _endpoint));
      } else if (_process != null) {
        _log('health probe timed out while the engine is still running');
        _emit(const EngineStatus(EngineState.error, message: 'Health timeout'));
      }
    } on Object catch (e) {
      _log('start failed: $e');
      _emit(EngineStatus(EngineState.error, message: '$e'));
    }
  }

  Future<void> _killOrphans(String binary) async {
    if (Platform.isWindows) return;
    try {
      await Process.run('pkill', ['-f', binary]);
      await Future<void>.delayed(const Duration(milliseconds: 300));
    } on Object {
      // pkill missing or nothing to kill
    }
  }

  SyncEndpoint get _endpoint =>
      SyncEndpoint(baseUrl: _localUrl, apiKey: _apiKey ?? '');

  void _log(String line) {
    _logBuffer.add(line);
    if (_logBuffer.length > 1000) _logBuffer.removeAt(0);
    _logController.add(line);
    debugPrint('[engine] $line');
  }

  void _pipe(Stream<List<int>> stream) {
    stream.transform(utf8.decoder).transform(const LineSplitter()).listen(_log);
  }

  Future<void> _onExit(int code) async {
    _process = null;
    if (_stopping) {
      _emit(const EngineStatus(EngineState.stopped));
    } else {
      _log('engine exited unexpectedly (code $code)');
      _emit(EngineStatus(EngineState.error, message: 'Engine exited ($code)'));
    }
  }

  Future<bool> _awaitHealth() async {
    final deadline = DateTime.now().add(const Duration(seconds: 40));
    while (DateTime.now().isBefore(deadline)) {
      try {
        final res = await http
            .get(Uri.parse('$_localUrl/rest/noauth/health'))
            .timeout(const Duration(seconds: 2));
        if (res.statusCode == 200) return true;
      } on Object {
        // not ready yet
      }
      await Future<void>.delayed(const Duration(milliseconds: 400));
    }
    return false;
  }

  @override
  Future<void> restart() async {
    await stop();
    _stopping = false;
    await start();
  }

  @override
  Future<void> stop() async {
    _stopping = true;
    final process = _process;
    if (process == null) return;
    try {
      if (_apiKey != null) {
        await http
            .post(
              Uri.parse('$_localUrl/rest/system/shutdown'),
              headers: {'X-API-Key': _apiKey!},
            )
            .timeout(const Duration(seconds: 3));
      }
    } on Object {
      process.kill();
    }
    await process.exitCode.timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        process.kill(ProcessSignal.sigkill);
        return -1;
      },
    );
    _process = null;
  }

  Future<String> _homeDir() async {
    final support = await getApplicationSupportDirectory();
    final dir = Directory(p.join(support.path, 'syncthing-home'));
    await dir.create(recursive: true);
    return dir.path;
  }

  Future<int> _freePort() async {
    final socket = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
    final port = socket.port;
    await socket.close();
    return port;
  }

  String _randomKey() {
    final rng = Random.secure();
    return List.generate(32, (_) => '0123456789abcdef'[rng.nextInt(16)]).join();
  }

  void _emit(EngineStatus status) {
    _current = status;
    _statusController.add(status);
  }
}
