import 'dart:async';

import 'package:flutter/material.dart';
import 'package:m3e_core/m3e_core.dart';
import 'package:motor/motor.dart';

const _expressiveFast = Duration(milliseconds: 260);
const _springReveal = M3EMotion.expressiveSpatialDefault;
const _springScale = M3EMotion.expressiveSpatialFast;

class ExpressiveSwitcher extends StatelessWidget {
  const ExpressiveSwitcher({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 520),
  });

  final Widget child;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      reverseDuration: _expressiveFast,
      switchInCurve: Easing.emphasizedDecelerate,
      switchOutCurve: Easing.emphasizedAccelerate,
      transitionBuilder: (child, animation) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Easing.emphasizedDecelerate,
          reverseCurve: Easing.emphasizedAccelerate,
        );
        return FadeTransition(opacity: curved, child: child);
      },
      child: child,
    );
  }
}

class ExpressiveLazyStack extends StatefulWidget {
  const ExpressiveLazyStack({
    super.key,
    required this.index,
    required this.length,
    required this.itemBuilder,
  });

  final int index;
  final int length;
  final Widget Function(int index) itemBuilder;

  @override
  State<ExpressiveLazyStack> createState() => _ExpressiveLazyStackState();
}

class _ExpressiveLazyStackState extends State<ExpressiveLazyStack> {
  final _visited = <int>{};
  final _cache = <int, Widget>{};

  @override
  void initState() {
    super.initState();
    _visited.add(widget.index);
    WidgetsBinding.instance.addPostFrameCallback((_) => _warmNext());
  }

  void _warmNext() {
    if (!mounted || _visited.length >= widget.length) return;
    for (var i = 0; i < widget.length; i++) {
      if (_visited.add(i)) break;
    }
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) => _warmNext());
  }

  @override
  void didUpdateWidget(ExpressiveLazyStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index) _visited.add(widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: widget.index,
      children: [
        for (var i = 0; i < widget.length; i++)
          _visited.contains(i)
              ? _cache.putIfAbsent(
                  i,
                  () => RepaintBoundary(child: widget.itemBuilder(i)),
                )
              : const SizedBox.shrink(),
      ],
    );
  }
}

class ExpressiveReveal extends StatefulWidget {
  const ExpressiveReveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.offset = 18,
  });

  final Widget child;
  final Duration delay;
  final double offset;

  @override
  State<ExpressiveReveal> createState() => _ExpressiveRevealState();
}

class _ExpressiveRevealState extends State<ExpressiveReveal>
    with SingleTickerProviderStateMixin {
  late final SingleMotionController _controller;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = SingleMotionController(
      motion: _springReveal.toMotion(),
      vsync: this,
      initialValue: 0,
    );
    if (widget.delay == Duration.zero) {
      _controller.animateTo(1);
    } else {
      _timer = Timer(widget.delay, () {
        if (mounted) _controller.animateTo(1);
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: RepaintBoundary(child: widget.child),
      builder: (context, child) {
        final value = _controller.value.clamp(0.0, 1.0);
        return Transform.translate(
          offset: Offset(0, (1 - value) * widget.offset),
          child: Transform.scale(
            scale: .98 + (.02 * value),
            alignment: Alignment.topCenter,
            child: child,
          ),
        );
      },
    );
  }
}

class ExpressiveSpringScale extends StatefulWidget {
  const ExpressiveSpringScale({
    super.key,
    required this.child,
    this.pressed = false,
    this.active = false,
    this.selected = false,
  });

  final Widget child;
  final bool pressed;
  final bool active;
  final bool selected;

  @override
  State<ExpressiveSpringScale> createState() => _ExpressiveSpringScaleState();
}

class _ExpressiveSpringScaleState extends State<ExpressiveSpringScale>
    with SingleTickerProviderStateMixin {
  late final SingleMotionController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SingleMotionController(
      motion: _springScale.toMotion(),
      vsync: this,
      initialValue: _target,
    );
  }

  @override
  void didUpdateWidget(ExpressiveSpringScale oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pressed != widget.pressed ||
        oldWidget.active != widget.active ||
        oldWidget.selected != widget.selected) {
      _controller.animateTo(_target);
    }
  }

  double get _target => widget.pressed
      ? .96
      : widget.active || widget.selected
      ? 1
      : .98;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) =>
          Transform.scale(scale: _controller.value, child: child),
    );
  }
}
