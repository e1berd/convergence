import 'dart:ui' show AppExitResponse;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'i18n/strings.g.dart';
import 'state/config_provider.dart';
import 'state/engine_providers.dart';
import 'ui/home_shell.dart';
import 'ui/theme.dart';

class SyncthingApp extends ConsumerStatefulWidget {
  const SyncthingApp({super.key});

  @override
  ConsumerState<SyncthingApp> createState() => _SyncthingAppState();
}

class _SyncthingAppState extends ConsumerState<SyncthingApp> {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onExitRequested: _onExit);
  }

  Future<AppExitResponse> _onExit() async {
    await ref.read(supervisorProvider).stop();
    return AppExitResponse.exit;
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(
      configProvider.select(
        (c) => (mode: c.themeMode, scheme: c.themeSchemeId),
      ),
    );
    return TranslationProvider(
      child: MaterialApp(
        title: 'Syncthing',
        theme: stTheme(.light, theme.scheme),
        darkTheme: stTheme(.dark, theme.scheme),
        themeMode: theme.mode,
        themeAnimationDuration: const Duration(milliseconds: 220),
        themeAnimationCurve: Easing.emphasizedDecelerate,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        supportedLocales: AppLocale.values.map((e) => e.flutterLocale),
        home: const HomeShell(),
      ),
    );
  }
}
