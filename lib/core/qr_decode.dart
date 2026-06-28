import 'dart:io';

import 'package:image/image.dart' as img;
import 'package:zxing2/qrcode.dart';

Future<String?> decodeQrFromImage(String path) async {
  final bytes = await File(path).readAsBytes();
  final decoded = img.decodeImage(bytes);
  if (decoded == null) return null;

  final pixels = decoded
      .convert(numChannels: 4)
      .getBytes(order: img.ChannelOrder.abgr)
      .buffer
      .asInt32List();
  final source = RGBLuminanceSource(decoded.width, decoded.height, pixels);
  final bitmap = BinaryBitmap(HybridBinarizer(source));
  try {
    return QRCodeReader().decode(bitmap).text;
  } on Object {
    return null;
  }
}
