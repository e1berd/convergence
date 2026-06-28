import 'package:flutter/material.dart';
import 'package:m3e_core/m3e_core.dart';

import 'expressive_motion.dart';

export 'expressive_motion.dart';
export 'package:m3e_core/m3e_core.dart' show Shapes;

const expressiveDuration = Duration(milliseconds: 520);
const expressiveFastDuration = Duration(milliseconds: 260);
const expressiveCurve = Easing.emphasizedDecelerate;
const expressiveExitCurve = Easing.emphasizedAccelerate;
const expressiveCompactBreakpoint = 720.0;
const expressiveMediumBreakpoint = 900.0;
const expressiveExpandedBreakpoint = 1200.0;

bool expressiveHasBottomNav(BuildContext context) =>
    MediaQuery.sizeOf(context).width < expressiveCompactBreakpoint;

EdgeInsets expressiveScreenPadding(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  final horizontal = width >= expressiveExpandedBreakpoint
      ? 32.0
      : width >= expressiveCompactBreakpoint
      ? 24.0
      : 16.0;
  return EdgeInsets.fromLTRB(
    horizontal,
    width >= expressiveCompactBreakpoint ? 16 : 8,
    horizontal,
    expressiveHasBottomNav(context) ? 96 : 28,
  );
}

int expressiveGridColumns(
  BuildContext context, {
  double minTileWidth = 360,
  int maxColumns = 3,
}) {
  final width = MediaQuery.sizeOf(context).width;
  if (width < expressiveMediumBreakpoint) return 1;
  final available = width - expressiveScreenPadding(context).horizontal;
  return (available / minTileWidth).floor().clamp(2, maxColumns);
}

class ExpressiveResponsiveCenter extends StatelessWidget {
  const ExpressiveResponsiveCenter({
    super.key,
    required this.child,
    this.maxWidth = 1180,
    this.padding,
    this.alignment = Alignment.topCenter,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: padding ?? expressiveScreenPadding(context),
          child: child,
        ),
      ),
    );
  }
}

List<BoxShadow> expressiveShadow(ColorScheme colors, {double strength = 1}) => [
  BoxShadow(
    color: colors.shadow.withValues(alpha: .07 * strength),
    blurRadius: 22 * strength,
    offset: Offset(0, 8 * strength),
  ),
  BoxShadow(
    color: colors.shadow.withValues(alpha: .04 * strength),
    blurRadius: 3,
    offset: const Offset(0, 1),
  ),
];

class ExpressivePanel extends StatelessWidget {
  const ExpressivePanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.radius = 32,
    this.color,
    this.elevated = true,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Color? color;
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return AnimatedContainer(
      duration: expressiveFastDuration,
      curve: expressiveCurve,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: .2)),
        boxShadow: elevated ? expressiveShadow(colors) : null,
      ),
      child: child,
    );
  }
}

class ExpressiveSection extends StatelessWidget {
  const ExpressiveSection({
    super.key,
    required this.title,
    required this.children,
    this.margin = EdgeInsets.zero,
    this.trailing,
  });

  final String title;
  final List<Widget> children;
  final EdgeInsetsGeometry margin;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ExpressiveReveal(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title.toUpperCase(),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0,
                    ),
                  ),
                ),
                ?trailing,
              ],
            ),
          ),
          AnimatedContainer(
            duration: expressiveFastDuration,
            curve: expressiveCurve,
            margin: margin,
            decoration: BoxDecoration(
              color: colors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: colors.outlineVariant.withValues(alpha: .2),
              ),
              boxShadow: expressiveShadow(colors),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < children.length; i++) ...[
                  if (i > 0)
                    Divider(
                      height: 1,
                      indent: 72,
                      color: colors.outlineVariant.withValues(alpha: .42),
                    ),
                  children[i],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ExpressiveIconContainer extends StatefulWidget {
  const ExpressiveIconContainer({
    super.key,
    required this.icon,
    this.color,
    this.foregroundColor,
    this.size = 52,
    this.radius = 18,
    this.shape,
    this.spinning = false,
  });

  final IconData icon;
  final Color? color;
  final Color? foregroundColor;
  final double size;
  final double radius;
  final Shapes? shape;
  final bool spinning;

  @override
  State<ExpressiveIconContainer> createState() =>
      _ExpressiveIconContainerState();
}

class _ExpressiveIconContainerState extends State<ExpressiveIconContainer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _spin;

  @override
  void initState() {
    super.initState();
    _spin = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );
    if (widget.spinning) _spin.repeat();
  }

  @override
  void didUpdateWidget(ExpressiveIconContainer old) {
    super.didUpdateWidget(old);
    if (widget.spinning && !_spin.isAnimating) {
      _spin.repeat();
    } else if (!widget.spinning && _spin.isAnimating) {
      _spin
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _spin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final bg = widget.color ?? colors.primaryContainer;
    final fg = widget.foregroundColor ?? colors.onPrimaryContainer;
    final shape = widget.shape;

    Widget background = shape == null
        ? AnimatedContainer(
            duration: expressiveFastDuration,
            curve: expressiveCurve,
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(widget.radius),
            ),
          )
        : M3EContainer(
            shape,
            width: widget.size,
            height: widget.size,
            color: bg,
            child: const SizedBox.expand(),
          );
    if (widget.spinning) {
      background = RotationTransition(turns: _spin, child: background);
    }

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          background,
          Icon(widget.icon, color: fg, size: widget.size * .44),
        ],
      ),
    );
  }
}

class ExpressiveStatusPill extends StatelessWidget {
  const ExpressiveStatusPill({
    super.key,
    required this.label,
    this.icon,
    this.color,
    this.foregroundColor,
  });

  final String label;
  final IconData? icon;
  final Color? color;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final fg = foregroundColor ?? colors.onTertiaryContainer;
    return AnimatedContainer(
      duration: expressiveFastDuration,
      curve: expressiveCurve,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color ?? colors.tertiaryContainer,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: fg),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: fg,
              fontWeight: FontWeight.w800,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}
