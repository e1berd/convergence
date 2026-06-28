import 'package:declar_ui/declar_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/syncthing_models.dart';
import '../../core/format.dart';
import '../../i18n/strings.g.dart';
import '../../platform/open_path.dart';
import '../../state/folders_providers.dart';
import 'expressive.dart';
import 'expressive_menu.dart';

class FolderCard extends ConsumerWidget {
  const FolderCard({super.key, required this.folder, required this.onEdit});

  final FolderConfig folder;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final t = context.t.folders;
    final status = ref.watch(folderStatusProvider(folder.id)).value;
    final controller = ref.read(foldersControllerProvider);
    final progress = status?.completion ?? 1.0;
    final paused = folder.paused;
    final syncing = !paused && status?.state == 'syncing';

    return ExpressivePanel(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              ExpressiveIconContainer(
                icon: paused
                    ? Icons.pause_rounded
                    : syncing
                    ? Icons.sync_rounded
                    : Icons.folder_rounded,
                size: 48,
                shape: syncing ? Shapes.sunny : Shapes.clampShell,
                spinning: syncing,
                color: colors.secondaryContainer,
                foregroundColor: colors.onSecondaryContainer,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      folder.displayName,
                      maxLines: 1,
                    ).size(17).weight(.w800),
                    Text(
                      folder.path,
                      maxLines: 1,
                    ).size(12).color(colors.onSurfaceVariant),
                  ],
                ),
              ),
              _FolderMenu(folder: folder, onEdit: onEdit),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ExpressiveStatusPill(
                label: _stateLabel(context, status?.state),
                color: colors.surfaceContainerHighest,
                foregroundColor: colors.onSurface,
              ),
              const Spacer(),
              if (status != null)
                Text(
                  formatBytes(status.globalBytes),
                ).size(12).color(colors.onSurfaceVariant),
              const SizedBox(width: 8),
              IconButton.filledTonal(
                onPressed: () => controller.scan(folder.id),
                icon: const Icon(Icons.refresh_rounded, size: 20),
                tooltip: t.scanNow,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _stateLabel(BuildContext context, String? state) {
    final t = context.t.status;
    return switch (state) {
      'idle' => t.idle,
      'syncing' => t.syncing,
      'scanning' => t.scanning,
      'paused' => t.paused,
      _ => state ?? t.idle,
    };
  }
}

class _FolderMenu extends ConsumerWidget {
  const _FolderMenu({required this.folder, required this.onEdit});

  final FolderConfig folder;
  final VoidCallback onEdit;

  Future<void> _open(BuildContext context) async {
    if (await openFolderInManager(folder.path)) return;
    if (context.mounted) {
      context.showSnackBar('${context.t.folders.open}: ${folder.path}');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final controller = ref.read(foldersControllerProvider);
    return ExpressiveMenuButton(
      items: [
        ExpressiveMenuItem(
          icon: Icons.folder_open_rounded,
          label: t.folders.open,
          onTap: () => _open(context),
        ),
        ExpressiveMenuItem(
          icon: Icons.edit_rounded,
          label: t.common.edit,
          onTap: onEdit,
        ),
        ExpressiveMenuItem(
          icon: folder.paused ? Icons.play_arrow_rounded : Icons.pause_rounded,
          label: folder.paused ? t.common.resume : t.common.pause,
          onTap: () => controller.setPaused(folder, !folder.paused),
        ),
        ExpressiveMenuItem(
          icon: Icons.delete_rounded,
          label: t.folders.remove,
          destructive: true,
          onTap: () => controller.remove(folder.id),
        ),
      ],
    );
  }
}
