import 'package:declar_ui/declar_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format.dart';
import '../../i18n/strings.g.dart';
import '../../state/devices_providers.dart';
import '../../state/engine_providers.dart';
import '../../state/folders_providers.dart';
import '../../state/system_providers.dart';
import '../widgets/empty_state.dart';
import '../widgets/expressive.dart';

class StatusScreen extends ConsumerWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final t = context.t;
    final endpoint = ref.watch(endpointProvider);

    if (endpoint == null) {
      return EmptyState(
        icon: Icons.cloud_sync_rounded,
        title: t.status.empty,
        subtitle: t.engine.starting,
      );
    }

    final status = ref.watch(systemStatusProvider).value;
    final version = ref.watch(systemVersionProvider).value;
    final connections = ref.watch(connectionsProvider).value;
    final folders = ref.watch(foldersProvider).value ?? const [];
    final devices = ref.watch(devicesProvider).value ?? const [];
    final connected =
        connections?.devices.values.where((d) => d.connected).length ?? 0;

    final metrics = [
      _Metric(
        Icons.download_rounded,
        t.status.download,
        formatBytes(connections?.totals.inBytes ?? 0),
        colors.primaryContainer,
        colors.onPrimaryContainer,
      ),
      _Metric(
        Icons.upload_rounded,
        t.status.upload,
        formatBytes(connections?.totals.outBytes ?? 0),
        colors.tertiaryContainer,
        colors.onTertiaryContainer,
      ),
      _Metric(
        Icons.folder_rounded,
        t.status.totalFolders,
        '${folders.length}',
        colors.secondaryContainer,
        colors.onSecondaryContainer,
      ),
      _Metric(
        Icons.devices_rounded,
        t.status.totalDevices,
        '$connected / ${devices.length}',
        colors.surfaceContainerHighest,
        colors.onSurface,
      ),
    ];

    return SingleChildScrollView(
      child: ExpressiveResponsiveCenter(
        maxWidth: 900,
        child: Column(
          crossAxisAlignment: .stretch,
          spacing: 16,
          children: [
            _OverviewCard(
              uptime: status == null ? '—' : formatDuration(status.uptime),
              versionLabel: version?.version ?? '—',
            ),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: context.width >= 560 ? 4 : 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.15,
              children: [for (final m in metrics) _MetricCard(metric: m)],
            ),
            _DeviceIdCard(deviceId: status?.myId ?? ''),
          ],
        ),
      ),
    );
  }
}

class _Metric {
  const _Metric(this.icon, this.label, this.value, this.bg, this.fg);
  final IconData icon;
  final String label;
  final String value;
  final Color bg;
  final Color fg;
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({required this.uptime, required this.versionLabel});

  final String uptime;
  final String versionLabel;

  @override
  Widget build(BuildContext context) {
    final t = context.t.status;
    final colors = context.colors;
    return ExpressivePanel(
      child: Row(
        children: [
          ExpressiveIconContainer(
            icon: Icons.insights_rounded,
            size: 56,
            radius: 20,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(t.overview).size(18).weight(.w800),
                const SizedBox(height: 4),
                Text(
                  '${t.uptime}: $uptime · ${t.version} $versionLabel',
                ).size(13).color(colors.onSurfaceVariant),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.metric});

  final _Metric metric;

  @override
  Widget build(BuildContext context) {
    return ExpressiveReveal(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: metric.bg,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          crossAxisAlignment: .start,
          mainAxisAlignment: .spaceBetween,
          children: [
            Icon(metric.icon, color: metric.fg, size: 26),
            Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  metric.value,
                  maxLines: 1,
                ).size(22).weight(.w800).color(metric.fg),
                Text(
                  metric.label,
                ).size(12).weight(.w600).color(metric.fg.withValues(alpha: .8)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DeviceIdCard extends StatelessWidget {
  const _DeviceIdCard({required this.deviceId});

  final String deviceId;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    return ExpressivePanel(
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(t.status.deviceId).size(12).weight(.w700).color(colors.primary),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  deviceId.isEmpty ? '—' : deviceId,
                ).size(13).color(colors.onSurface),
              ),
              IconButton(
                icon: const Icon(Icons.copy_rounded, size: 18),
                onPressed: deviceId.isEmpty
                    ? null
                    : () {
                        Clipboard.setData(ClipboardData(text: deviceId));
                        context.showSnackBar(t.common.copied);
                      },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
