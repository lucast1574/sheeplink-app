import '../../../l10n/locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';

Future<bool> acceptPhotoPolicy(
  BuildContext context,
  String userId, {
  FlutterSecureStorage storage = const FlutterSecureStorage(),
}) async {
  final key = 'sheeplink.photo-policy.2026-10-22.$userId';
  try {
    if (await storage.read(key: key).timeout(const Duration(seconds: 3)) ==
        'true') {
      return true;
    }
  } catch (_) {
    // Ask again rather than failing or assuming consent.
  }
  if (!context.mounted) return false;
  final accepted = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(tr("Fotos que cuidan de todos")),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr(
                "Sube solo fotos que tengas permiso de compartir. No se permite contenido sexual, violencia, odio, acoso ni explotación de menores. Puedes reportar contenido o usuarios desde Perfil o junto a la foto de la reunión.",
              ),
            ),
            TextButton(
              onPressed: () => launchUrl(
                Uri.parse('https://sheeplink.app/terminos'),
                mode: LaunchMode.externalApplication,
              ),
              child: Text(tr("Leer términos y condiciones")),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(tr("Cancelar")),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(tr("Aceptar y continuar")),
        ),
      ],
    ),
  );
  if (accepted == true) {
    try {
      await storage
          .write(key: key, value: 'true')
          .timeout(const Duration(seconds: 3));
    } catch (_) {
      // The user has explicitly consented; storage failure must not block picking.
    }
    return true;
  }
  return false;
}
