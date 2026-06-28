import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

const _nativeChannel = MethodChannel('syncthing/native');

class BinaryLocator {
  Future<String> locate() async {
    if (Platform.isAndroid) return _android();
    return _desktop();
  }

  Future<String> _android() async {
    final dir = await _nativeChannel.invokeMethod<String>('nativeLibraryDir');
    return p.join(dir!, 'libsyncthing.so');
  }

  Future<String> _desktop() async {
    final name = _binaryName();
    final support = await getApplicationSupportDirectory();
    final outDir = Directory(p.join(support.path, 'engine'));
    await outDir.create(recursive: true);
    final outFile = File(p.join(outDir.path, name));

    final data = await rootBundle.load('assets/bin/$name');
    final bytes = data.buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    );
    final upToDate =
        await outFile.exists() && await outFile.length() == bytes.length;
    if (!upToDate) {
      await outFile.writeAsBytes(bytes, flush: true);
      if (!Platform.isWindows) {
        await Process.run('chmod', ['+x', outFile.path]);
      }
    }
    return outFile.path;
  }

  String _binaryName() => Platform.isWindows ? 'syncthing.exe' : 'syncthing';
}

bool get engineSupportsBundled =>
    !kIsWeb &&
    (Platform.isLinux ||
        Platform.isMacOS ||
        Platform.isWindows ||
        Platform.isAndroid);
