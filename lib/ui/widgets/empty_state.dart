import 'package:declar_ui/declar_ui.dart';

import 'expressive.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ExpressiveReveal(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: .min,
            children: [
              ExpressiveIconContainer(
                icon: icon,
                size: 96,
                shape: Shapes.flower,
                color: colors.secondaryContainer,
                foregroundColor: colors.onSecondaryContainer,
              ),
              const SizedBox(height: 24),
              Text(title, textAlign: .center).size(22).weight(.w800),
              if (subtitle != null) ...[
                const SizedBox(height: 8),
                Text(
                  subtitle!,
                  textAlign: .center,
                ).size(15).color(colors.onSurfaceVariant),
              ],
              if (action != null) ...[const SizedBox(height: 24), action!],
            ],
          ),
        ),
      ),
    );
  }
}
