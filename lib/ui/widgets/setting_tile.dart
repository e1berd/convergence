import 'package:declar_ui/declar_ui.dart';

import 'expressive.dart';

class SettingTile extends StatelessWidget {
  const SettingTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ListTile(
      onTap: onTap,
      leading: ExpressiveIconContainer(
        icon: icon,
        color: colors.secondaryContainer,
        foregroundColor: colors.onSecondaryContainer,
        size: 44,
        radius: 14,
      ),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: trailing != null
          ? AnimatedSwitcher(duration: expressiveFastDuration, child: trailing)
          : null,
    );
  }
}
