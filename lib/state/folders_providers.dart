import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/syncthing_models.dart';
import 'engine_providers.dart';

final foldersProvider = FutureProvider<List<FolderConfig>>((ref) async {
  final client = ref.watch(clientProvider);
  ref.watch(refreshTickProvider);
  if (client == null) return const [];
  return client.folders();
});

final folderStatusProvider = FutureProvider.family<FolderStatus?, String>((
  ref,
  folderId,
) async {
  final client = ref.watch(clientProvider);
  ref.watch(refreshTickProvider);
  if (client == null) return null;
  return client.folderStatus(folderId);
});

final foldersControllerProvider = Provider(FoldersController.new);

class FoldersController {
  FoldersController(this._ref);

  final Ref _ref;

  Future<void> save(FolderConfig folder) async {
    await _ref.read(clientProvider)?.putFolder(folder);
    _ref.invalidate(foldersProvider);
  }

  Future<void> remove(String id) async {
    await _ref.read(clientProvider)?.deleteFolder(id);
    _ref.invalidate(foldersProvider);
  }

  Future<void> scan(String id) async {
    await _ref.read(clientProvider)?.scan(folderId: id);
    _ref.invalidate(folderStatusProvider(id));
  }

  Future<void> setPaused(FolderConfig folder, bool paused) =>
      save(folder.copyWith(paused: paused));
}
