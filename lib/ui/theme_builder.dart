import 'package:animations/animations.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/material.dart';

import 'theme_text.dart';

const _expressiveRadius = BorderRadius.all(Radius.circular(32));
const _largeRadius = BorderRadius.all(Radius.circular(24));
const _mediumRadius = BorderRadius.all(Radius.circular(18));

ThemeData buildStThemeData(ColorScheme scheme) {
  final base = ThemeData(
    colorScheme: scheme,
    brightness: scheme.brightness,
    scaffoldBackgroundColor: scheme.surfaceContainerLowest,
    fontFamily: 'Roboto',
    useMaterial3: true,
  );
  final splashFactory = switch (defaultTargetPlatform) {
    TargetPlatform.android => InkSparkle.splashFactory,
    _ => InkRipple.splashFactory,
  };

  return base.copyWith(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textTheme: expressiveText(base.textTheme),
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surfaceContainerLowest,
      foregroundColor: scheme.onSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: base.textTheme.headlineSmall?.copyWith(
        fontWeight: .w800,
        color: scheme.onSurface,
        letterSpacing: 0,
      ),
    ),
    cardTheme: CardThemeData(
      color: scheme.surfaceContainerHigh,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: const RoundedRectangleBorder(borderRadius: _expressiveRadius),
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: scheme.surfaceContainerHigh,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: const RoundedRectangleBorder(borderRadius: _expressiveRadius),
      titleTextStyle: base.textTheme.headlineSmall?.copyWith(
        fontWeight: .w800,
        color: scheme.onSurface,
        letterSpacing: 0,
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: scheme.surfaceContainerHigh,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      showDragHandle: true,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: const StadiumBorder(),
        minimumSize: const Size(64, 48),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: base.textTheme.labelLarge?.copyWith(fontWeight: .w800),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: const StadiumBorder(),
        minimumSize: const Size(64, 48),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: base.textTheme.labelLarge?.copyWith(fontWeight: .w800),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: const StadiumBorder(),
        minimumSize: const Size(48, 44),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: base.textTheme.labelLarge?.copyWith(fontWeight: .w800),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        shape: const CircleBorder(),
        minimumSize: const Size.square(44),
        padding: const EdgeInsets.all(10),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surfaceContainerHighest,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      hintStyle: base.textTheme.bodyLarge?.copyWith(
        color: scheme.onSurfaceVariant,
      ),
      border: const OutlineInputBorder(
        borderRadius: _mediumRadius,
        borderSide: BorderSide.none,
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: _mediumRadius,
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: _mediumRadius,
        borderSide: BorderSide(color: scheme.primary, width: 2),
      ),
    ),
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      minLeadingWidth: 40,
      shape: const RoundedRectangleBorder(borderRadius: _largeRadius),
      titleTextStyle: base.textTheme.bodyLarge?.copyWith(
        fontWeight: .w700,
        color: scheme.onSurface,
      ),
      subtitleTextStyle: base.textTheme.bodyMedium?.copyWith(
        color: scheme.onSurfaceVariant,
      ),
      iconColor: scheme.onSurfaceVariant,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return scheme.onPrimary;
        return scheme.outline;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return scheme.primary;
        return scheme.surfaceContainerHighest;
      }),
      trackOutlineColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return Colors.transparent;
        return scheme.outlineVariant;
      }),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: SegmentedButton.styleFrom(
        shape: const StadiumBorder(),
        selectedBackgroundColor: scheme.secondaryContainer,
        selectedForegroundColor: scheme.onSecondaryContainer,
        foregroundColor: scheme.onSurface,
        textStyle: base.textTheme.labelLarge?.copyWith(fontWeight: .w800),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: scheme.surfaceContainer,
      indicatorColor: scheme.secondaryContainer,
      indicatorShape: const StadiumBorder(),
      elevation: 0,
      height: 76,
      labelTextStyle: WidgetStatePropertyAll(
        base.textTheme.labelMedium?.copyWith(fontWeight: .w700, fontSize: 11),
      ),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: scheme.onSecondaryContainer, size: 26);
        }
        return IconThemeData(color: scheme.onSurfaceVariant, size: 24);
      }),
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: scheme.surfaceContainerLowest,
      indicatorColor: scheme.secondaryContainer,
      indicatorShape: const StadiumBorder(),
      elevation: 0,
      groupAlignment: -0.7,
      selectedLabelTextStyle: base.textTheme.labelMedium?.copyWith(
        fontWeight: .w800,
        color: scheme.onSecondaryContainer,
      ),
      unselectedLabelTextStyle: base.textTheme.labelMedium?.copyWith(
        fontWeight: .w600,
        color: scheme.onSurfaceVariant,
      ),
      selectedIconTheme: IconThemeData(
        color: scheme.onSecondaryContainer,
        size: 26,
      ),
      unselectedIconTheme: IconThemeData(
        color: scheme.onSurfaceVariant,
        size: 24,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: scheme.inverseSurface,
      contentTextStyle: base.textTheme.bodyMedium?.copyWith(
        color: scheme.onInverseSurface,
        fontWeight: .w600,
      ),
      shape: const RoundedRectangleBorder(borderRadius: _largeRadius),
    ),
    chipTheme: ChipThemeData(
      shape: const StadiumBorder(),
      backgroundColor: scheme.surfaceContainerHighest,
      selectedColor: scheme.secondaryContainer,
      checkmarkColor: scheme.onSecondaryContainer,
      labelStyle: base.textTheme.labelLarge?.copyWith(fontWeight: .w700),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: scheme.primary,
      circularTrackColor: scheme.surfaceContainerHighest,
      linearTrackColor: scheme.surfaceContainerHighest,
    ),
    dividerTheme: DividerThemeData(
      color: scheme.outlineVariant.withValues(alpha: .6),
      thickness: 1,
      space: 1,
    ),
    tooltipTheme: TooltipThemeData(
      decoration: ShapeDecoration(
        color: scheme.inverseSurface,
        shape: const StadiumBorder(),
      ),
      textStyle: base.textTheme.labelMedium?.copyWith(
        color: scheme.onInverseSurface,
        fontWeight: .w700,
      ),
    ),
    menuTheme: MenuThemeData(
      style: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(scheme.surfaceContainerHigh),
        surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
        shadowColor: WidgetStatePropertyAll(
          scheme.shadow.withValues(alpha: .2),
        ),
        elevation: const WidgetStatePropertyAll(3),
        padding: const WidgetStatePropertyAll(EdgeInsets.all(8)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
      ),
    ),
    menuButtonTheme: MenuButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        minimumSize: const WidgetStatePropertyAll(Size(180, 48)),
        textStyle: WidgetStatePropertyAll(
          base.textTheme.bodyLarge?.copyWith(fontWeight: .w700),
        ),
        overlayColor: WidgetStatePropertyAll(
          scheme.primary.withValues(alpha: .08),
        ),
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: scheme.surfaceContainerHigh,
      surfaceTintColor: Colors.transparent,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      textStyle: base.textTheme.bodyLarge?.copyWith(fontWeight: .w700),
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      menuStyle: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(scheme.surfaceContainerHigh),
        surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: scheme.primaryContainer,
      foregroundColor: scheme.onPrimaryContainer,
      shape: const RoundedRectangleBorder(borderRadius: _largeRadius),
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 1,
      highlightElevation: 0,
    ),
    splashFactory: splashFactory,
    splashColor: scheme.primary.withValues(alpha: .12),
    highlightColor: scheme.primary.withValues(alpha: .08),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        for (final p in TargetPlatform.values)
          p: const FadeThroughPageTransitionsBuilder(),
      },
    ),
  );
}
