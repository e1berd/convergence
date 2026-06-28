import 'package:declar_ui/declar_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../i18n/strings.g.dart';
import '../../state/devices_providers.dart';
import '../../state/engine_providers.dart';
import '../widgets/device_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/expressive.dart';
import 'device_editor.dart';

class DevicesScreen extends ConsumerWidget {
  const DevicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t.devices;
    final endpoint = ref.watch(endpointProvider);
    final devices = ref.watch(devicesProvider).value ?? const [];
    final pending = ref.watch(pendingDevicesProvider).value ?? const [];
    final localId = ref.watch(localDeviceIdProvider).value;

    if (endpoint == null) {
      return EmptyState(
        icon: Icons.devices_rounded,
        title: context.t.status.empty,
      );
    }

    final remotes = devices.where((d) => d.deviceId != localId).toList();

    if (remotes.isEmpty && pending.isEmpty) {
      return EmptyState(
        icon: Icons.devices_other_rounded,
        title: t.empty,
        subtitle: t.emptyHint,
        action: FilledButton.icon(
          onPressed: () => showDeviceEditor(context, ref),
          icon: const Icon(Icons.add_rounded),
          label: Text(t.add),
        ),
      );
    }

    return Scaffold()
        .body(
          SingleChildScrollView(
            child: ExpressiveResponsiveCenter(
              maxWidth: 760,
              child: Column(
                crossAxisAlignment: .stretch,
                spacing: 14,
                children: [
                  if (localId != null) _ThisDeviceCard(deviceId: localId),
                  for (final p in pending)
                    _PendingDeviceBanner(deviceId: p.deviceId, name: p.name),
                  for (final device in remotes)
                    DeviceCard(
                      device: device,
                      onEdit: () =>
                          showDeviceEditor(context, ref, existing: device),
                    ),
                ],
              ),
            ),
          ),
        )
        .floatingAction(
          FloatingActionButton.extended(
            onPressed: () => showDeviceEditor(context, ref),
            icon: const Icon(Icons.add_rounded),
            label: Text(t.add),
          ),
        );
  }
}

class _ThisDeviceCard extends StatelessWidget {
  const _ThisDeviceCard({required this.deviceId});

  final String deviceId;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final t = context.t.devices;
    return ExpressivePanel(
      color: colors.primaryContainer,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  t.thisDevice,
                ).size(13).weight(.w800).color(colors.onPrimaryContainer),
                const SizedBox(height: 4),
                Text(deviceId, maxLines: 1)
                    .size(12)
                    .color(colors.onPrimaryContainer.withValues(alpha: .85)),
              ],
            ),
          ),
          IconButton.filledTonal(
            onPressed: () => _showQr(context, deviceId),
            icon: const Icon(Icons.qr_code_2_rounded),
          ),
        ],
      ),
    );
  }

  void _showQr(BuildContext context, String id) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.t.devices.showQr),
        content: SizedBox(
          width: 240,
          height: 240,
          child: QrImageView(
            data: id,
            backgroundColor: context.colors.surface,
            eyeStyle: QrEyeStyle(
              eyeShape: QrEyeShape.circle,
              color: context.colors.onSurface,
            ),
            dataModuleStyle: QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.circle,
              color: context.colors.onSurface,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.t.common.close),
          ),
        ],
      ),
    );
  }
}

class _PendingDeviceBanner extends ConsumerWidget {
  const _PendingDeviceBanner({required this.deviceId, required this.name});

  final String deviceId;
  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final t = context.t.devices;
    final controller = ref.read(devicesControllerProvider);
    return ExpressivePanel(
      color: colors.tertiaryContainer,
      child: Row(
        children: [
          Icon(Icons.person_add_rounded, color: colors.onTertiaryContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  t.pendingTitle,
                ).size(13).weight(.w800).color(colors.onTertiaryContainer),
                Text(name.isEmpty ? deviceId : name, maxLines: 1)
                    .size(12)
                    .color(colors.onTertiaryContainer.withValues(alpha: .85)),
              ],
            ),
          ),
          IconButton(
            onPressed: () => controller.dismissPendingDevice(deviceId),
            icon: Icon(Icons.close_rounded, color: colors.onTertiaryContainer),
          ),
          FilledButton(
            onPressed: () =>
                showDeviceEditor(context, ref, prefillId: deviceId),
            child: Text(t.accept),
          ),
        ],
      ),
    );
  }
}
