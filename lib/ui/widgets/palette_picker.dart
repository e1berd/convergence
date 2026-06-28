import 'package:declar_ui/declar_ui.dart';

import '../theme.dart';
import 'expressive.dart';

class PalettePicker extends StatelessWidget {
  const PalettePicker({
    super.key,
    required this.selectedId,
    required this.onSelected,
  });

  final String selectedId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: stThemeSchemes.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 170,
        mainAxisExtent: 88,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final scheme = stThemeSchemes[index];
        final preview = stColorScheme(context.theme.brightness, scheme.id);
        return _PaletteCard(
          scheme: scheme,
          preview: preview,
          selected: scheme.id == selectedId,
          onTap: () => onSelected(scheme.id),
        );
      },
    );
  }
}

class _PaletteCard extends StatelessWidget {
  const _PaletteCard({
    required this.scheme,
    required this.preview,
    required this.selected,
    required this.onTap,
  });

  final StThemeScheme scheme;
  final ColorScheme preview;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ExpressiveSpringScale(
      selected: selected,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: expressiveFastDuration,
          curve: expressiveCurve,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: selected
                ? preview.secondaryContainer
                : colors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(selected ? 26 : 22),
            border: Border.all(
              color: selected ? preview.primary : colors.outlineVariant,
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: .start,
            mainAxisAlignment: .spaceBetween,
            children: [
              Row(
                children: [
                  _Swatch(color: preview.primary),
                  _Swatch(color: preview.secondary),
                  _Swatch(color: preview.tertiary),
                  const Spacer(),
                  Icon(
                    selected ? Icons.check_circle_rounded : scheme.icon,
                    size: 20,
                    color: selected ? preview.primary : colors.onSurfaceVariant,
                  ),
                ],
              ),
              Text(scheme.name, maxLines: 1)
                  .size(13)
                  .weight(.w800)
                  .color(
                    selected ? preview.onSecondaryContainer : colors.onSurface,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      margin: const EdgeInsets.only(right: 4),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: context.colors.surface.withValues(alpha: .8),
          width: 2,
        ),
      ),
    );
  }
}
