import 'package:declar_ui/declar_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/syncthing_models.dart';
import '../../core/format.dart';
import '../../i18n/strings.g.dart';
import '../../state/devices_providers.dart';
import '../../state/system_providers.dart';
import 'expressive.dart';
import 'expressive_menu.dart';

class DeviceCard extends ConsumerWidget {
  const DeviceCard({super.key, required this.device, required this.onEdit});

  final DeviceConfig device;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final connection = ref
        .watch(connectionsProvider)
        .value
        ?.devices[device.deviceId];
    final online = connection?.connected ?? false;

    return ExpressivePanel(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              ExpressiveIconContainer(
                icon: online ? Icons.computer_rounded : Icons.cloud_off_rounded,
                size: 48,
                radius: 16,
                color: online
                    ? colors.tertiaryContainer
                    : colors.surfaceContainerHighest,
                foregroundColor: online
                    ? colors.onTertiaryContainer
                    : colors.onSurfaceVariant,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      device.displayName,
                      maxLines: 1,
                    ).size(17).weight(.w800),
                    Text(
                      device.shortId,
                    ).size(12).color(colors.onSurfaceVariant),
                  ],
                ),
              ),
              _DeviceMenu(device: device, onEdit: onEdit),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              ExpressiveStatusPill(
                label: online
                    ? context.t.common.online
                    : context.t.common.offline,
                icon: online
                    ? Icons.check_circle_rounded
                    : Icons.circle_outlined,
                color: online
                    ? colors.tertiaryContainer
                    : colors.surfaceContainerHighest,
                foregroundColor: online
                    ? colors.onTertiaryContainer
                    : colors.onSurfaceVariant,
              ),
              const Spacer(),
              if (connection != null) ...[
                _Rate(
                  icon: Icons.download_rounded,
                  value: formatBytes(connection.inBytes),
                ),
                const SizedBox(width: 12),
                _Rate(
                  icon: Icons.upload_rounded,
                  value: formatBytes(connection.outBytes),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _Rate extends StatelessWidget {
  const _Rate({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      mainAxisSize: .min,
      children: [
        Icon(icon, size: 15, color: colors.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(value).size(12).color(colors.onSurfaceVariant),
      ],
    );
  }
}

class _DeviceMenu extends ConsumerWidget {
  const _DeviceMenu({required this.device, required this.onEdit});

  final DeviceConfig device;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final controller = ref.read(devicesControllerProvider);
    return ExpressiveMenuButton(
      items: [
        ExpressiveMenuItem(
          icon: Icons.edit_rounded,
          label: t.common.edit,
          onTap: onEdit,
        ),
        ExpressiveMenuItem(
          icon: device.paused ? Icons.play_arrow_rounded : Icons.pause_rounded,
          label: device.paused ? t.common.resume : t.common.pause,
          onTap: () => controller.setPaused(device, !device.paused),
        ),
        ExpressiveMenuItem(
          icon: Icons.delete_rounded,
          label: t.devices.remove,
          destructive: true,
          onTap: () => controller.remove(device.deviceId),
        ),
      ],
    );
  }
}
