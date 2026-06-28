import 'dart:io' show Platform;

import 'package:declar_ui/declar_ui.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:m3e_core/m3e_core.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../core/qr_decode.dart';
import '../../i18n/strings.g.dart';

bool get _cameraSupported =>
    kIsWeb || Platform.isAndroid || Platform.isIOS || Platform.isMacOS;

Future<String?> showQrPairScreen(
  BuildContext context, {
  String? myDeviceId,
  bool startOnScan = false,
}) {
  return Navigator.of(context).push<String>(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) =>
          QrPairScreen(myDeviceId: myDeviceId, startOnScan: startOnScan),
    ),
  );
}

class QrPairScreen extends StatefulWidget {
  const QrPairScreen({super.key, this.myDeviceId, this.startOnScan = false});

  final String? myDeviceId;
  final bool startOnScan;

  @override
  State<QrPairScreen> createState() => _QrPairScreenState();
}

class _QrPairScreenState extends State<QrPairScreen> {
  late int _tab = widget.startOnScan || widget.myDeviceId == null ? 1 : 0;
  MobileScannerController? _controller;
  bool _handled = false;

  bool get _showToggle => widget.myDeviceId != null;

  @override
  void initState() {
    super.initState();
    if (_tab == 1) _startCamera();
  }

  void _startCamera() {
    if (!_cameraSupported || _controller != null) return;
    _controller = MobileScannerController(detectionTimeoutMs: 250);
  }

  void _stopCamera() {
    _controller?.dispose();
    _controller = null;
  }

  void _selectTab(int tab) {
    setState(() => _tab = tab);
    tab == 1 ? _startCamera() : _stopCamera();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_handled) return;
    final value = capture.barcodes.firstOrNull?.rawValue;
    if (value == null) return;
    _handled = true;
    _stopCamera();
    Navigator.pop(context, value.trim());
  }

  Future<void> _pickImage() async {
    final picked = await FilePicker.platform.pickFiles(type: FileType.image);
    final path = picked?.files.singleOrNull?.path;
    if (path == null) return;
    final code = await decodeQrFromImage(path);
    if (!mounted) return;
    if (code != null) {
      _handled = true;
      Navigator.pop(context, code.trim());
    } else {
      context.showSnackBar(context.t.devices.qrNotFound);
    }
  }

  @override
  void dispose() {
    _stopCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.devices;
    return Scaffold()
        .appBar(AppBar(title: Text(t.pairTitle)))
        .body(
          SafeArea(
            child: Column(
              children: [
                if (_showToggle)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                    child: M3EToggleButtonGroup(
                      actions: [
                        M3EToggleButtonGroupAction(label: Text(t.myQrTab)),
                        M3EToggleButtonGroupAction(label: Text(t.scanTab)),
                      ],
                      type: .connected,
                      size: .sm,
                      style: .tonal,
                      selectedIndex: _tab,
                      onSelectedIndexChanged: (i) {
                        if (i != null) _selectTab(i);
                      },
                    ),
                  ),
                Expanded(
                  child: _tab == 0
                      ? _MyQrView(deviceId: widget.myDeviceId ?? '')
                      : _ScanView(
                          controller: _controller,
                          onDetect: _onDetect,
                          onPickImage: _pickImage,
                        ),
                ),
              ],
            ),
          ),
        );
  }
}

class _MyQrView extends StatelessWidget {
  const _MyQrView({required this.deviceId});

  final String deviceId;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final t = context.t.devices;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: .min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: colors.outlineVariant),
              ),
              child: QrImageView(
                data: deviceId,
                size: 240,
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
            const SizedBox(height: 20),
            Text(
              t.myQrHint,
              textAlign: .center,
            ).size(14).color(colors.onSurfaceVariant),
            const SizedBox(height: 14),
            M3EButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: deviceId));
                context.showSnackBar(context.t.common.copied);
              },
              icon: const Icon(Icons.copy_rounded),
              label: Text(deviceId),
              style: .tonal,
              size: .sm,
            ),
          ],
        ),
      ),
    );
  }
}

class _ScanView extends StatelessWidget {
  const _ScanView({
    required this.controller,
    required this.onDetect,
    required this.onPickImage,
  });

  final MobileScannerController? controller;
  final void Function(BarcodeCapture) onDetect;
  final VoidCallback onPickImage;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final t = context.t.devices;

    if (controller == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: .min,
            children: [
              Icon(
                Icons.no_photography_rounded,
                size: 56,
                color: colors.onSurfaceVariant,
              ),
              const SizedBox(height: 16),
              Text(
                t.cameraUnsupported,
                textAlign: .center,
              ).size(15).color(colors.onSurfaceVariant),
              const SizedBox(height: 20),
              M3EButton.icon(
                onPressed: onPickImage,
                icon: const Icon(Icons.image_search_rounded),
                label: Text(t.scanFromImage),
              ),
            ],
          ),
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        MobileScanner(controller: controller, onDetect: onDetect),
        IgnorePointer(
          child: Center(
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: colors.primary, width: 4),
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 32,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: colors.surface.withValues(alpha: .85),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(t.pointCamera).size(13).weight(.w700),
            ),
          ),
        ),
      ],
    );
  }
}
