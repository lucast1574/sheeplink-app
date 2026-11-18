import 'package:flutter/services.dart';
import '../../../data/services/photo_service.dart';
import '../../../l10n/locale.dart';

String photoFailureMessage(Object error) {
  if (error is PlatformException &&
      const {
        'camera_access_denied',
        'camera_access_restricted',
        'photo_access_denied',
        'photo_access_restricted',
        'permission_denied',
      }.contains(error.code)) {
    return tr(
      'Permiso denegado. Puedes habilitarlo en los ajustes del teléfono.',
    );
  }
  if (error is PhotoException) {
    return tr(switch (error.failure) {
      PhotoFailure.fileTooLarge => 'Usa una foto de menos de 20 MB.',
      PhotoFailure.invalidImage => 'No pudimos leer esta foto. Usa JPG o PNG.',
      PhotoFailure.compressedTooLarge =>
        'La foto sigue siendo muy grande. Prueba con una más pequeña.',
      PhotoFailure.pickerTimeout =>
        'El selector de fotos no respondió. Ciérralo y vuelve a intentarlo.',
      PhotoFailure.preparationTimeout =>
        'La foto tardó demasiado en prepararse. Intenta con otra imagen.',
    });
  }
  return tr(
    'No pudimos preparar la foto. Prueba con una imagen JPG o PNG más pequeña.',
  );
}
