import 'dart:convert';

import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/config.dart';
import '../i18n/strings.g.dart';

const _prefsKey = 'app_config';

SharedPreferences? _initialPrefs;
AppConfig? _initialConfig;

final configProvider = NotifierProvider<ConfigNotifier, AppConfig>(
  ConfigNotifier.new,
);

Future<AppConfig> loadInitialConfig() async {
  final prefs = await SharedPreferences.getInstance();
  final config = _readConfig(prefs);
  _initialPrefs = prefs;
  _initialConfig = config;
  await _applyLocale(config);
  return config;
}

class ConfigNotifier extends Notifier<AppConfig> {
  SharedPreferences? _prefs;

  @override
  AppConfig build() {
    final initial = _initialConfig;
    if (initial != null) {
      _prefs = _initialPrefs;
      return initial;
    }
    _load();
    return const AppConfig();
  }

  Future<void> _load() async {
    _prefs = await SharedPreferences.getInstance();
    state = _readConfig(_prefs!);
    await _applyLocale(state);
  }

  Future<void> _save() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setString(_prefsKey, jsonEncode(state.toJson()));
  }

  void setLocale(AppLocale locale) {
    LocaleSettings.setLocale(locale);
    state = state.copyWith(localeCode: locale.languageCode);
    _save();
  }

  void setThemeMode(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);
    _save();
  }

  void setThemeScheme(String id) {
    state = state.copyWith(themeSchemeId: id);
    _save();
  }

  void setEngineMode(EngineMode mode) {
    state = state.copyWith(engineMode: mode);
    _save();
  }

  void setRemote(String url, String apiKey) {
    state = state.copyWith(remoteUrl: url, remoteApiKey: apiKey);
    _save();
  }
}

AppConfig _readConfig(SharedPreferences prefs) {
  final json = prefs.getString(_prefsKey);
  if (json == null) return const AppConfig();
  return AppConfig.fromJson(
    Map<String, dynamic>.from(jsonDecode(json) as Map<String, dynamic>),
  );
}

Future<void> _applyLocale(AppConfig config) async {
  final code = config.localeCode;
  if (code != null) await LocaleSettings.setLocaleRaw(code);
}
