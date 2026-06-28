import 'dart:io' show Platform;

import 'package:declar_ui/declar_ui.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m3e_core/m3e_core.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../api/syncthing_models.dart';
import '../../core/qr_decode.dart';
import '../../i18n/strings.g.dart';
import '../../state/devices_providers.dart';
import '../widgets/adaptive_modal.dart';
import '../widgets/text_field.dart';

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
  bool get _useCamera => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  @override
  void dispose() {
    _name.dispose();
    _id.dispose();
    super.dispose();
  }

  Future<void> _scan() async {
    if (_useCamera) {
      final code = await Navigator.push<String>(
        context,
        MaterialPageRoute(builder: (_) => const _ScannerPage()),
      );
      if (code != null && mounted) setState(() => _id.text = code.trim());
      return;
    }
    final picked = await FilePicker.platform.pickFiles(type: FileType.image);
    final path = picked?.files.singleOrNull?.path;
    if (path == null) return;
    final code = await decodeQrFromImage(path);
    if (!mounted) return;
    if (code != null) {
      setState(() => _id.text = code.trim());
    } else {
      context.showSnackBar(context.t.devices.qrNotFound);
    }
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
              icon: Icon(
                _useCamera
                    ? Icons.qr_code_scanner_rounded
                    : Icons.image_search_rounded,
              ),
              label: Text(_useCamera ? t.scan : t.scanFromImage),
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

class _ScannerPage extends StatelessWidget {
  const _ScannerPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold()
        .appBar(AppBar(title: Text(context.t.devices.scan)))
        .body(
          MobileScanner(
            onDetect: (capture) {
              final value = capture.barcodes.firstOrNull?.rawValue;
              if (value != null) Navigator.pop(context, value);
            },
          ),
        );
  }
}
