import 'package:declar_ui/declar_ui.dart';

import 'expressive.dart';
import 'sync_logo.dart';

class RailDestination {
  const RailDestination(this.icon, this.selectedIcon, this.label);

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

class SideRail extends StatelessWidget {
  const SideRail({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<RailDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: colors.surfaceContainerLowest,
      child: SizedBox(
        width: 108,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 16, bottom: 12),
              child: SyncLogo(size: 48),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 4),
                children: [
                  for (var i = 0; i < destinations.length; i++)
                    _RailItem(
                      destination: destinations[i],
                      selected: i == selectedIndex,
                      onTap: () => onSelected(i),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RailItem extends StatefulWidget {
  const _RailItem({
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final RailDestination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_RailItem> createState() => _RailItemState();
}

class _RailItemState extends State<_RailItem> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final selected = widget.selected;
    final fg = selected ? colors.onSecondaryContainer : colors.onSurfaceVariant;

    return Semantics(
      button: true,
      selected: selected,
      label: widget.destination.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ExpressiveSpringScale(
            pressed: _pressed,
            selected: selected,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: expressiveFastDuration,
                  curve: expressiveCurve,
                  width: selected ? 64 : 48,
                  height: 40,
                  decoration: BoxDecoration(
                    color: selected
                        ? colors.secondaryContainer
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(selected ? 100 : 18),
                  ),
                  child: Icon(
                    selected
                        ? widget.destination.selectedIcon
                        : widget.destination.icon,
                    color: fg,
                    size: 25,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.destination.label,
                  maxLines: 1,
                ).size(12).weight(selected ? .w800 : .w600).color(fg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
