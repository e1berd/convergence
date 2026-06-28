import 'package:declar_ui/declar_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m3e_core/m3e_core.dart';

import '../../i18n/strings.g.dart';
import '../../state/devices_providers.dart';
import '../../state/engine_providers.dart';
import '../../state/folders_providers.dart';
import '../widgets/empty_state.dart';
import '../widgets/expressive.dart';
import '../widgets/folder_card.dart';
import 'folder_editor.dart';

class FoldersScreen extends ConsumerWidget {
  const FoldersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t.folders;
    final endpoint = ref.watch(endpointProvider);
    final folders = ref.watch(foldersProvider).value ?? const [];
    final pending = ref.watch(pendingFoldersProvider).value ?? const [];

    if (endpoint == null) {
      return EmptyState(
        icon: Icons.folder_rounded,
        title: context.t.status.empty,
      );
    }

    if (folders.isEmpty && pending.isEmpty) {
      return EmptyState(
        icon: Icons.create_new_folder_rounded,
        title: t.empty,
        subtitle: t.emptyHint,
        action: M3EButton.icon(
          onPressed: () => showFolderEditor(context, ref),
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
                  for (final p in pending) _PendingFolderBanner(label: p.label),
                  for (final folder in folders)
                    FolderCard(
                      folder: folder,
                      onEdit: () =>
                          showFolderEditor(context, ref, existing: folder),
                    ),
                ],
              ),
            ),
          ),
        )
        .floatingAction(
          FloatingActionButton.extended(
            onPressed: () => showFolderEditor(context, ref),
            icon: const Icon(Icons.add_rounded),
            label: Text(t.add),
          ),
        );
  }
}

class _PendingFolderBanner extends ConsumerWidget {
  const _PendingFolderBanner({required this.label});

  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final t = context.t.devices;
    return ExpressivePanel(
      color: colors.tertiaryContainer,
      child: Row(
        children: [
          Icon(
            Icons.create_new_folder_rounded,
            color: colors.onTertiaryContainer,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  t.pendingFolderTitle,
                ).size(13).weight(.w800).color(colors.onTertiaryContainer),
                Text(label, maxLines: 1)
                    .size(12)
                    .color(colors.onTertiaryContainer.withValues(alpha: .85)),
              ],
            ),
          ),
          FilledButton(
            onPressed: () => showFolderEditor(context, ref),
            child: Text(t.accept),
          ),
        ],
      ),
    );
  }
}
