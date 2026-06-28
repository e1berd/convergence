import 'dart:async';

import 'package:http/http.dart' as http;

import '../api/syncthing_models.dart';
import 'syncthing_supervisor.dart';

class RemoteSupervisor implements SyncthingSupervisor {
  RemoteSupervisor({required this.url, required this.apiKey});

  final String url;
  final String apiKey;

  final _statusController = StreamController<EngineStatus>.broadcast();
  final _logController = StreamController<String>.broadcast();
  EngineStatus _current = const EngineStatus(EngineState.idle);
  Timer? _probe;

  @override
  Stream<EngineStatus> get status => _statusController.stream;

  @override
  EngineStatus get current => _current;

  @override
  Stream<String> get logs => _logController.stream;

  SyncEndpoint get _endpoint => SyncEndpoint(baseUrl: url, apiKey: apiKey);

  @override
  Future<void> start() async {
    if (url.isEmpty) {
      _emit(const EngineStatus(EngineState.error, message: 'No server URL'));
      return;
    }
    await _check();
    _probe ??= Timer.periodic(const Duration(seconds: 10), (_) => _check());
  }

  Future<void> _check() async {
    try {
      final res = await http
          .get(
            Uri.parse('$url/rest/system/ping'),
            headers: {'X-API-Key': apiKey},
          )
          .timeout(const Duration(seconds: 5));
      if (res.statusCode == 200) {
        _emit(EngineStatus(EngineState.remote, endpoint: _endpoint));
      } else {
        _emit(
          EngineStatus(EngineState.error, message: 'HTTP ${res.statusCode}'),
        );
      }
    } on Object catch (e) {
      _emit(EngineStatus(EngineState.error, message: '$e'));
    }
  }

  void _emit(EngineStatus status) {
    _current = status;
    _statusController.add(status);
  }

  @override
  Future<void> restart() => _check();

  @override
  Future<void> stop() async {
    _probe?.cancel();
    _probe = null;
    _emit(const EngineStatus(EngineState.stopped));
  }
}
