import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'photo_processing.dart';
export 'photo_processing.dart';

class PhotoService {
  PhotoService({ImagePicker? picker}) : _picker = picker ?? ImagePicker();
  final ImagePicker _picker;
  static const pickerTimeout = Duration(minutes: 2);
  static const preparationTimeout = Duration(seconds: 30);

  Future<Uint8List?> pick(ImageSource source) async {
    final file = await _picker
        .pickImage(
          source: source,
          maxWidth: 1280,
          maxHeight: 1280,
          imageQuality: 75,
          requestFullMetadata: false,
        )
        .timeout(
          pickerTimeout,
          onTimeout: () =>
              throw const PhotoException(PhotoFailure.pickerTimeout),
        );
    if (file == null) return null;
    return _prepare(file).timeout(
      preparationTimeout,
      onTimeout: () =>
          throw const PhotoException(PhotoFailure.preparationTimeout),
    );
  }

  Future<Uint8List> _prepare(XFile file) async {
    if (await file.length() > 20 * 1024 * 1024) {
      throw const PhotoException(PhotoFailure.fileTooLarge);
    }
    return compute(preparePhoto, await file.readAsBytes());
  }

  Future<Uint8List?> recover() async {
    // Lost-data recovery is an Android activity-restoration API, not an iOS picker.
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return null;
    final lost = await _picker.retrieveLostData();
    if (lost.files?.isNotEmpty != true) {
      if (lost.exception != null) throw lost.exception!;
      return null;
    }
    return _prepare(lost.files!.first).timeout(
      preparationTimeout,
      onTimeout: () =>
          throw const PhotoException(PhotoFailure.preparationTimeout),
    );
  }
}
