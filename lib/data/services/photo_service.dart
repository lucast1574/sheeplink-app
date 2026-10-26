import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as image;
import 'package:image_picker/image_picker.dart';

class PhotoService {
  final _picker = ImagePicker();
  Future<Uint8List?> pick(ImageSource source) async {
    final file = await _picker.pickImage(
      source: source,
      maxWidth: 1280,
      maxHeight: 1280,
      imageQuality: 75,
      requestFullMetadata: false,
    );
    if (file == null) return null;
    if (await file.length() > 20 * 1024 * 1024) {
      throw StateError('Usa una foto de menos de 20 MB.');
    }
    return compute(preparePhoto, await file.readAsBytes());
  }

  Future<Uint8List?> recover() async {
    final lost = await _picker.retrieveLostData();
    if (lost.files?.isNotEmpty != true) return null;
    final file = lost.files!.first;
    if (await file.length() > 20 * 1024 * 1024) return null;
    return compute(preparePhoto, await file.readAsBytes());
  }
}

Uint8List preparePhoto(Uint8List bytes) {
  var decoded = image.decodeImage(bytes);
  if (decoded == null) {
    throw StateError('No pudimos leer esta foto. Usa JPG o PNG.');
  }
  decoded = image.bakeOrientation(decoded);
  if (decoded.width > 1280 || decoded.height > 1280) {
    decoded = image.copyResize(
      decoded,
      width: decoded.width >= decoded.height ? 1280 : null,
      height: decoded.height > decoded.width ? 1280 : null,
    );
  }
  decoded.exif = image.ExifData();
  for (final quality in [75, 60, 45]) {
    final jpeg = image.encodeJpg(decoded, quality: quality);
    if (jpeg.length <= 512000) return jpeg;
  }
  throw StateError(
    'La foto sigue siendo muy grande. Prueba con una más pequeña.',
  );
}
