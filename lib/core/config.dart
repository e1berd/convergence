import 'package:flutter/material.dart' show ThemeMode;

enum EngineMode { bundled, remote }

class AppConfig {
  const AppConfig({
    this.themeMode = .system,
    this.themeSchemeId = 'azure',
    this.localeCode,
    this.engineMode = .bundled,
    this.remoteUrl = '',
    this.remoteApiKey = '',
  });

  final ThemeMode themeMode;
  final String themeSchemeId;
  final String? localeCode;
  final EngineMode engineMode;
  final String remoteUrl;
  final String remoteApiKey;

  AppConfig copyWith({
    ThemeMode? themeMode,
    String? themeSchemeId,
    String? localeCode,
    EngineMode? engineMode,
    String? remoteUrl,
    String? remoteApiKey,
  }) => AppConfig(
    themeMode: themeMode ?? this.themeMode,
    themeSchemeId: themeSchemeId ?? this.themeSchemeId,
    localeCode: localeCode ?? this.localeCode,
    engineMode: engineMode ?? this.engineMode,
    remoteUrl: remoteUrl ?? this.remoteUrl,
    remoteApiKey: remoteApiKey ?? this.remoteApiKey,
  );

  Map<String, dynamic> toJson() => {
    'themeMode': themeMode.index,
    'themeSchemeId': themeSchemeId,
    if (localeCode != null) 'localeCode': localeCode,
    'engineMode': engineMode.name,
    'remoteUrl': remoteUrl,
    'remoteApiKey': remoteApiKey,
  };

  factory AppConfig.fromJson(Map<String, dynamic> json) => AppConfig(
    themeMode: ThemeMode.values[json['themeMode'] as int? ?? 0],
    themeSchemeId: json['themeSchemeId'] as String? ?? 'azure',
    localeCode: json['localeCode'] as String?,
    engineMode: EngineMode.values.firstWhere(
      (m) => m.name == json['engineMode'],
      orElse: () => EngineMode.bundled,
    ),
    remoteUrl: json['remoteUrl'] as String? ?? '',
    remoteApiKey: json['remoteApiKey'] as String? ?? '',
  );
}
