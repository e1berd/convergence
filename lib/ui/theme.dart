import 'package:flutter/material.dart';

import 'theme_builder.dart';

@immutable
class StThemeScheme {
  const StThemeScheme({
    required this.id,
    required this.name,
    required this.seed,
    required this.icon,
  });

  final String id;
  final String name;
  final Color seed;
  final IconData icon;
}

const stThemeSchemes = [
  StThemeScheme(
    id: 'azure',
    name: 'Azure',
    seed: Color(0xFF1F6FEB),
    icon: Icons.sync_rounded,
  ),
  StThemeScheme(
    id: 'violet',
    name: 'Violet',
    seed: Color(0xFF6E56CF),
    icon: Icons.auto_awesome_rounded,
  ),
  StThemeScheme(
    id: 'teal',
    name: 'Teal',
    seed: Color(0xFF007C80),
    icon: Icons.water_rounded,
  ),
  StThemeScheme(
    id: 'emerald',
    name: 'Emerald',
    seed: Color(0xFF2E7D32),
    icon: Icons.eco_rounded,
  ),
  StThemeScheme(
    id: 'amber',
    name: 'Amber',
    seed: Color(0xFFB7791F),
    icon: Icons.wb_sunny_rounded,
  ),
  StThemeScheme(
    id: 'coral',
    name: 'Coral',
    seed: Color(0xFFD45D40),
    icon: Icons.local_fire_department_rounded,
  ),
  StThemeScheme(
    id: 'rose',
    name: 'Rose',
    seed: Color(0xFFC2185B),
    icon: Icons.favorite_rounded,
  ),
  StThemeScheme(
    id: 'graphite',
    name: 'Graphite',
    seed: Color(0xFF56616B),
    icon: Icons.contrast_rounded,
  ),
];

final _colorSchemeCache = <String, ColorScheme>{};
final _themeCache = <String, ThemeData>{};

StThemeScheme stThemeSchemeById(String id) {
  for (final scheme in stThemeSchemes) {
    if (scheme.id == id) return scheme;
  }
  return stThemeSchemes.first;
}

ColorScheme stColorScheme(Brightness brightness, String schemeId) {
  final themeScheme = stThemeSchemeById(schemeId);
  final key = '${brightness.name}:${themeScheme.id}';
  return _colorSchemeCache.putIfAbsent(
    key,
    () => ColorScheme.fromSeed(
      seedColor: themeScheme.seed,
      brightness: brightness,
      dynamicSchemeVariant: DynamicSchemeVariant.tonalSpot,
    ),
  );
}

ThemeData stTheme(Brightness brightness, String schemeId) {
  final themeScheme = stThemeSchemeById(schemeId);
  final key = '${brightness.name}:${themeScheme.id}';
  return _themeCache.putIfAbsent(
    key,
    () => buildStThemeData(stColorScheme(brightness, themeScheme.id)),
  );
}
