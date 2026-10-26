import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';

Future<bool> acceptPhotoPolicy(BuildContext context, String userId) async {
  const storage = FlutterSecureStorage();
  final key = 'sheeplink.photo-policy.2026-10-22.$userId';
  if (await storage.read(key: key) == 'true') return true;
  if (!context.mounted) return false;
  final accepted = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Fotos que cuidan de todos'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sube solo fotos que tengas permiso de compartir. No se permite contenido sexual, violencia, odio, acoso ni explotación de menores. Puedes reportar contenido o usuarios desde Perfil o junto a la foto de la reunión.',
          ),
          TextButton(
            onPressed: () => launchUrl(
              Uri.parse('https://sheeplink.nexode.app/terminos'),
              mode: LaunchMode.externalApplication,
            ),
            child: const Text('Leer términos y condiciones'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Aceptar y continuar'),
        ),
      ],
    ),
  );
  if (accepted == true) {
    await storage.write(key: key, value: 'true');
    return true;
  }
  return false;
}
