import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'i18n/strings.g.dart';
import 'state/config_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale();
  await loadInitialConfig();
  if (!kIsWeb && Platform.isAndroid) {
    unawaited(FlutterDisplayMode.setHighRefreshRate());
  }
  runApp(const ProviderScope(child: SyncthingApp()));
}
