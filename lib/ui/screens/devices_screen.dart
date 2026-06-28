import 'package:declar_ui/declar_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../i18n/strings.g.dart';
import '../../state/devices_providers.dart';
import '../../state/engine_providers.dart';
import '../widgets/device_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/expressive.dart';
import 'device_editor.dart';
import 'qr_pair_screen.dart';

class DevicesScreen extends ConsumerWidget {
  const DevicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t.devices;
    final colors = context.colors;
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

    return Scaffold()
        .body(
          SingleChildScrollView(
            child: ExpressiveResponsiveCenter(
              maxWidth: 760,
              child: Column(
                crossAxisAlignment: .stretch,
                spacing: 14,
                children: [
                  if (localId != null) _PairingCard(deviceId: localId),
                  for (final p in pending)
                    _PendingDeviceBanner(deviceId: p.deviceId, name: p.name),
                  if (remotes.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        t.emptyHint,
                        textAlign: .center,
                      ).size(14).color(colors.onSurfaceVariant),
                    )
                  else
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

class _PairingCard extends ConsumerWidget {
  const _PairingCard({required this.deviceId});

  final String deviceId;

  Future<void> _openPairing(
    BuildContext context,
    WidgetRef ref, {
    required bool scan,
  }) async {
    final code = await showQrPairScreen(
      context,
      myDeviceId: deviceId,
      startOnScan: scan,
    );
    if (code != null && context.mounted) {
      showDeviceEditor(context, ref, prefillId: code);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final t = context.t.devices;
    return ExpressivePanel(
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Row(
            children: [
              ExpressiveIconContainer(
                icon: Icons.hub_rounded,
                size: 44,
                radius: 14,
                color: colors.secondaryContainer,
                foregroundColor: colors.onSecondaryContainer,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(t.thisDevice).size(15).weight(.w800),
                    Text(t.myQrHint).size(12).color(colors.onSurfaceVariant),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Center(
            child: GestureDetector(
              onTap: () => _openPairing(context, ref, scan: false),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: colors.outlineVariant),
                ),
                child: QrImageView(
                  data: deviceId,
                  size: 168,
                  backgroundColor: colors.surface,
                  eyeStyle: QrEyeStyle(
                    eyeShape: QrEyeShape.circle,
                    color: colors.onSurface,
                  ),
                  dataModuleStyle: QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.circle,
                    color: colors.onSurface,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          _DeviceIdRow(deviceId: deviceId),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: () => _openPairing(context, ref, scan: true),
            icon: const Icon(Icons.qr_code_scanner_rounded),
            label: Text(t.scan),
            style: FilledButton.styleFrom(minimumSize: const Size(0, 52)),
          ),
        ],
      ),
    );
  }
}

class _DeviceIdRow extends StatelessWidget {
  const _DeviceIdRow({required this.deviceId});

  final String deviceId;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 4, 4, 4),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              deviceId,
              maxLines: 1,
            ).size(12).color(colors.onSurfaceVariant),
          ),
          IconButton(
            icon: const Icon(Icons.copy_rounded, size: 18),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: deviceId));
              context.showSnackBar(context.t.common.copied);
            },
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
