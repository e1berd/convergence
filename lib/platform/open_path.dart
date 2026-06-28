import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';

const _channel = MethodChannel('syncthing/native');

Future<bool> openFolderInManager(String path) async {
  if (kIsWeb || path.isEmpty) return false;
  try {
    if (Platform.isLinux) {
      await Process.start('xdg-open', [path]);
      return true;
    }
    if (Platform.isMacOS) {
      await Process.start('open', [path]);
      return true;
    }
    if (Platform.isWindows) {
      await Process.start('explorer', [path]);
      return true;
    }
    if (Platform.isAndroid) {
      return await _channel.invokeMethod<bool>('openFolder', {'path': path}) ??
          false;
    }
  } on Object {
    return false;
  }
  return false;
}
