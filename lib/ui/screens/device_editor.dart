import 'package:declar_ui/declar_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m3e_core/m3e_core.dart';

import '../../api/syncthing_models.dart';
import '../../i18n/strings.g.dart';
import '../../state/devices_providers.dart';
import '../widgets/adaptive_modal.dart';
import '../widgets/text_field.dart';
import 'qr_pair_screen.dart';

Future<void> showDeviceEditor(
  BuildContext context,
  WidgetRef ref, {
  DeviceConfig? existing,
  String? prefillId,
}) {
  return showAdaptiveModal(
    context,
    builder: (context) =>
        _DeviceEditor(existing: existing, prefillId: prefillId),
  );
}

class _DeviceEditor extends ConsumerStatefulWidget {
  const _DeviceEditor({this.existing, this.prefillId});

  final DeviceConfig? existing;
  final String? prefillId;

  @override
  ConsumerState<_DeviceEditor> createState() => _DeviceEditorState();
}

class _DeviceEditorState extends ConsumerState<_DeviceEditor> {
  late final _name = TextEditingController(text: widget.existing?.name ?? '');
  late final _id = TextEditingController(
    text: widget.existing?.deviceId ?? widget.prefillId ?? '',
  );
  late bool _introducer = widget.existing?.introducer ?? false;
  late bool _autoAccept = widget.existing?.autoAcceptFolders ?? false;

  bool get _isNew => widget.existing == null;

  @override
  void dispose() {
    _name.dispose();
    _id.dispose();
    super.dispose();
  }

  Future<void> _scan() async {
    final code = await showQrPairScreen(context, startOnScan: true);
    if (code != null && mounted) setState(() => _id.text = code);
  }

  Future<void> _save() async {
    final id = _id.text.trim();
    if (id.isEmpty) return;
    final device = DeviceConfig(
      deviceId: id,
      name: _name.text.trim(),
      addresses: widget.existing?.addresses ?? const ['dynamic'],
      paused: widget.existing?.paused ?? false,
      introducer: _introducer,
      autoAcceptFolders: _autoAccept,
    );
    await ref.read(devicesControllerProvider).save(device);
    if (mounted) {
      Navigator.pop(context);
      context.showSnackBar(context.t.devices.added);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.devices;
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
          ExpressiveTextField(controller: _name, label: t.name, hint: t.name),
          ExpressiveTextField(
            controller: _id,
            label: t.id,
            hint: t.idHint,
            maxLines: 2,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: M3EButton.icon(
              onPressed: _scan,
              icon: const Icon(Icons.qr_code_scanner_rounded),
              label: Text(t.scan),
              style: .tonal,
              size: .sm,
            ),
          ),
          SwitchListTile(
            value: _introducer,
            onChanged: (v) => setState(() => _introducer = v),
            title: Text(t.introducer),
            contentPadding: EdgeInsets.zero,
          ),
          SwitchListTile(
            value: _autoAccept,
            onChanged: (v) => setState(() => _autoAccept = v),
            title: Text(t.autoAccept),
            contentPadding: EdgeInsets.zero,
          ),
          FilledButton(onPressed: _save, child: Text(context.t.common.save)),
        ],
      ),
    );
  }
}
