import 'dart:typed_data';
import 'package:image/image.dart' as image;

enum PhotoFailure {
  fileTooLarge,
  invalidImage,
  compressedTooLarge,
  pickerTimeout,
  preparationTimeout,
}

class PhotoException implements Exception {
  const PhotoException(this.failure);
  final PhotoFailure failure;
  @override
  String toString() => 'PhotoException(${failure.name})';
}

/// Runs in an isolate. Keep this independent from Flutter bindings/localization.
Uint8List preparePhoto(Uint8List bytes) {
  var decoded = image.decodeImage(bytes);
  if (decoded == null) throw const PhotoException(PhotoFailure.invalidImage);
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
  throw const PhotoException(PhotoFailure.compressedTooLarge);
}
