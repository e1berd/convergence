import 'package:flutter/material.dart';
import 'package:m3e_core/m3e_core.dart';
import 'package:motor/motor.dart';

class ExpressiveMenuItem {
  const ExpressiveMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool destructive;
}

class ExpressiveMenuButton extends StatefulWidget {
  const ExpressiveMenuButton({
    super.key,
    required this.items,
    this.icon = Icons.more_vert_rounded,
  });

  final List<ExpressiveMenuItem> items;
  final IconData icon;

  @override
  State<ExpressiveMenuButton> createState() => _ExpressiveMenuButtonState();
}

class _ExpressiveMenuButtonState extends State<ExpressiveMenuButton>
    with TickerProviderStateMixin {
  final _buttonKey = GlobalKey();
  final _portal = OverlayPortalController();
  late final SingleMotionController _open;
  late final SingleMotionController _close;
  bool _closing = false;

  static const _menuWidth = 280.0;

  @override
  void initState() {
    super.initState();
    _open = SingleMotionController(
      motion: M3EMotion.expressiveSpatialFast.toMotion(),
      vsync: this,
      initialValue: 0,
    );
    _close = SingleMotionController(
      motion: M3EMotion.expressiveEffectsDefault.toMotion(),
      vsync: this,
      initialValue: 0,
    )..addListener(_onCloseTick);
  }

  void _onCloseTick() {
    if (_closing && _close.value >= 0.999 && _portal.isShowing) {
      _portal.hide();
      _closing = false;
      _close.value = 0;
    }
  }

  void _toggle() => _portal.isShowing ? _dismiss() : _show();

  void _show() {
    _closing = false;
    _close.value = 0;
    _portal.show();
    _open
      ..value = 0
      ..animateTo(1);
  }

  void _dismiss() {
    if (_closing) return;
    _closing = true;
    _close
      ..value = 0
      ..animateTo(1);
  }

  void _select(ExpressiveMenuItem item) {
    _dismiss();
    item.onTap();
  }

  @override
  void dispose() {
    _open.dispose();
    _close.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: _portal,
      overlayChildBuilder: _buildOverlay,
      child: IconButton(
        key: _buttonKey,
        icon: Icon(widget.icon),
        onPressed: _toggle,
      ),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    final box = _buttonKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return const SizedBox.shrink();
    final rect = box.localToGlobal(Offset.zero) & box.size;
    final media = MediaQuery.of(context);
    final screen = media.size;
    final menuHeight = widget.items.length * 48.0 + 16;
    final spaceBelow = screen.height - rect.bottom;
    final openUp = spaceBelow < menuHeight + 16 && rect.top > spaceBelow;

    final top = (openUp ? rect.top - menuHeight - 6 : rect.bottom + 6).clamp(
      media.padding.top + 8,
      screen.height - menuHeight - 8,
    );
    final left = (rect.right - _menuWidth).clamp(
      8.0,
      screen.width - _menuWidth - 8,
    );

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _dismiss,
          ),
        ),
        Positioned(
          left: left,
          top: top,
          width: _menuWidth,
          child: AnimatedBuilder(
            animation: Listenable.merge([_open, _close]),
            builder: (context, child) {
              final appear = _open.value.clamp(0.0, 1.2);
              final hide = _close.value.clamp(0.0, 1.0);
              final scale = (0.85 + 0.15 * appear) * (1 - 0.05 * hide);
              final opacity = appear.clamp(0.0, 1.0) * (1 - hide);
              return Opacity(
                opacity: opacity.clamp(0.0, 1.0),
                child: Transform.translate(
                  offset: Offset(0, (1 - appear) * (openUp ? 8 : -8)),
                  child: Transform.scale(
                    scale: scale,
                    alignment: openUp
                        ? Alignment.bottomRight
                        : Alignment.topRight,
                    child: child,
                  ),
                ),
              );
            },
            child: _MenuCard(items: widget.items, onSelect: _select),
          ),
        ),
      ],
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({required this.items, required this.onSelect});

  final List<ExpressiveMenuItem> items;
  final ValueChanged<ExpressiveMenuItem> onSelect;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: colors.surfaceContainerHigh,
      elevation: 3,
      shadowColor: colors.shadow.withValues(alpha: .2),
      surfaceTintColor: Colors.transparent,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final item in items)
              _MenuRow(item: item, onTap: () => onSelect(item)),
          ],
        ),
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({required this.item, required this.onTap});

  final ExpressiveMenuItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final fg = item.destructive ? colors.error : colors.onSurface;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      overlayColor: WidgetStatePropertyAll(fg.withValues(alpha: .08)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Icon(item.icon, size: 20, color: fg),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                item.label,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: fg,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
