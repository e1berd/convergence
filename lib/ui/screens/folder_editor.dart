import 'dart:math';

import 'package:declar_ui/declar_ui.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m3e_core/m3e_core.dart';

import '../../api/syncthing_models.dart';
import '../../i18n/strings.g.dart';
import '../../state/devices_providers.dart';
import '../../state/folders_providers.dart';
import '../widgets/adaptive_modal.dart';
import '../widgets/text_field.dart';

Future<void> showFolderEditor(
  BuildContext context,
  WidgetRef ref, {
  FolderConfig? existing,
}) {
  return showAdaptiveModal(
    context,
    builder: (context) => _FolderEditor(existing: existing),
  );
}

const _types = ['sendreceive', 'sendonly', 'receiveonly'];

class _FolderEditor extends ConsumerStatefulWidget {
  const _FolderEditor({this.existing});

  final FolderConfig? existing;

  @override
  ConsumerState<_FolderEditor> createState() => _FolderEditorState();
}

class _FolderEditorState extends ConsumerState<_FolderEditor> {
  late final _label = TextEditingController(text: widget.existing?.label ?? '');
  late String _path = widget.existing?.path ?? '';
  late int _typeIndex = _types.indexOf(widget.existing?.type ?? 'sendreceive');
  late final Set<String> _shared = {
    ...?widget.existing?.devices.map((d) => d.deviceId),
  };

  @override
  void dispose() {
    _label.dispose();
    super.dispose();
  }

  bool get _isNew => widget.existing == null;

  Future<void> _pickPath() async {
    final picked = await FilePicker.platform.getDirectoryPath();
    if (picked != null) setState(() => _path = picked);
  }

  Future<void> _save() async {
    final localId = ref.read(localDeviceIdProvider).value;
    final devices = {
      ..._shared,
      ?localId,
    }.map((id) => FolderDeviceRef(deviceId: id)).toList();
    final folder = (widget.existing ?? _blank()).copyWith(
      label: _label.text.trim(),
      type: _types[_typeIndex],
      devices: devices,
    );
    await ref.read(foldersControllerProvider).save(folder);
    if (mounted) {
      Navigator.pop(context);
      context.showSnackBar(context.t.folders.added);
    }
  }

  FolderConfig _blank() => FolderConfig(
    id: _randomFolderId(),
    label: '',
    path: _path,
    type: 'sendreceive',
    devices: const [],
    rescanIntervalS: 3600,
    paused: false,
  );

  @override
  Widget build(BuildContext context) {
    final t = context.t.folders;
    final colors = context.colors;
    final devices = ref.watch(devicesProvider).value ?? const [];
    final canSave = _path.isNotEmpty;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        8,
        20,
        20 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .stretch,
        spacing: 16,
        children: [
          Text(_isNew ? t.add : context.t.common.edit).size(22).weight(.w800),
          ExpressiveTextField(
            controller: _label,
            label: t.label,
            hint: t.label,
          ),
          _PathPicker(path: _path, onPick: _pickPath),
          Column(
            crossAxisAlignment: .start,
            spacing: 8,
            children: [
              Text(
                t.type,
              ).size(12).weight(.w700).color(colors.onSurfaceVariant),
              M3EToggleButtonGroup(
                actions: [
                  M3EToggleButtonGroupAction(label: Text(t.typeSendReceive)),
                  M3EToggleButtonGroupAction(label: Text(t.typeSendOnly)),
                  M3EToggleButtonGroupAction(label: Text(t.typeReceiveOnly)),
                ],
                type: .connected,
                size: .sm,
                style: .tonal,
                selectedIndex: _typeIndex,
                onSelectedIndexChanged: (i) {
                  if (i != null) setState(() => _typeIndex = i);
                },
              ),
            ],
          ),
          if (devices.isNotEmpty)
            Column(
              crossAxisAlignment: .start,
              spacing: 8,
              children: [
                Text(
                  t.sharedWith,
                ).size(12).weight(.w700).color(colors.onSurfaceVariant),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final d in devices)
                      FilterChip(
                        label: Text(d.displayName),
                        selected: _shared.contains(d.deviceId),
                        onSelected: (v) => setState(() {
                          v
                              ? _shared.add(d.deviceId)
                              : _shared.remove(d.deviceId);
                        }),
                      ),
                  ],
                ),
              ],
            ),
          FilledButton(
            onPressed: canSave ? _save : null,
            child: Text(context.t.common.save),
          ),
        ],
      ),
    );
  }
}

class _PathPicker extends StatelessWidget {
  const _PathPicker({required this.path, required this.onPick});

  final String path;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final t = context.t.folders;
    return Column(
      crossAxisAlignment: .start,
      spacing: 6,
      children: [
        Text(t.path).size(12).weight(.w700).color(colors.onSurfaceVariant),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 4, 4, 4),
          decoration: BoxDecoration(
            color: colors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(path.isEmpty ? t.choosePath : path, maxLines: 1)
                    .size(14)
                    .color(
                      path.isEmpty ? colors.onSurfaceVariant : colors.onSurface,
                    ),
              ),
              IconButton.filledTonal(
                onPressed: onPick,
                icon: const Icon(Icons.folder_open_rounded, size: 20),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

String _randomFolderId() {
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final rng = Random();
  String part() =>
      List.generate(5, (_) => chars[rng.nextInt(chars.length)]).join();
  return '${part()}-${part()}';
}
