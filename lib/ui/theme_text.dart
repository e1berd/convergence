import 'package:flutter/material.dart';

TextTheme expressiveText(TextTheme base) => base.copyWith(
  displayLarge: base.displayLarge?.copyWith(
    fontWeight: .w800,
    letterSpacing: 0,
  ),
  displayMedium: base.displayMedium?.copyWith(
    fontWeight: .w800,
    letterSpacing: 0,
  ),
  displaySmall: base.displaySmall?.copyWith(
    fontWeight: .w800,
    letterSpacing: 0,
  ),
  headlineLarge: base.headlineLarge?.copyWith(
    fontWeight: .w800,
    letterSpacing: 0,
  ),
  headlineMedium: base.headlineMedium?.copyWith(
    fontWeight: .w800,
    letterSpacing: 0,
  ),
  headlineSmall: base.headlineSmall?.copyWith(
    fontWeight: .w800,
    letterSpacing: 0,
  ),
  titleLarge: base.titleLarge?.copyWith(fontWeight: .w800, letterSpacing: 0),
  titleMedium: base.titleMedium?.copyWith(fontWeight: .w700, letterSpacing: 0),
  titleSmall: base.titleSmall?.copyWith(fontWeight: .w700, letterSpacing: 0),
  bodyLarge: base.bodyLarge?.copyWith(
    fontWeight: .w400,
    height: 1.5,
    letterSpacing: 0,
  ),
  bodyMedium: base.bodyMedium?.copyWith(
    fontWeight: .w400,
    height: 1.4,
    letterSpacing: 0,
  ),
  bodySmall: base.bodySmall?.copyWith(
    fontWeight: .w400,
    height: 1.3,
    letterSpacing: 0,
  ),
  labelLarge: base.labelLarge?.copyWith(fontWeight: .w800, letterSpacing: 0),
  labelMedium: base.labelMedium?.copyWith(fontWeight: .w700, letterSpacing: 0),
  labelSmall: base.labelSmall?.copyWith(fontWeight: .w700, letterSpacing: 0),
);
