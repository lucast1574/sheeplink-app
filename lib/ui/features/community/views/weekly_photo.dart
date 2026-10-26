import '../../../core/widgets/report_content.dart';
import '../../../core/widgets/photo_policy.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../data/services/photo_service.dart';
import '../view_models/community_view_model.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/feedback_panel.dart';

class WeeklyPhoto extends StatefulWidget {
  const WeeklyPhoto({super.key, required this.model});
  final CommunityViewModel model;
  @override
  State<WeeklyPhoto> createState() => _WeeklyPhotoState();
}

class _WeeklyPhotoState extends State<WeeklyPhoto> {
  final _photos = PhotoService();
  String? error;
  Uint8List? recovered;
  @override
  void initState() {
    super.initState();
    recover();
  }

  Future<void> recover() async {
    try {
      final bytes = await _photos.recover();
      if (mounted && bytes != null) setState(() => recovered = bytes);
    } catch (_) {
      /* A fresh picker session has no recovery result on some platforms. */
    }
  }

  Future<void> pick(ImageSource source) async {
    if (!await acceptPhotoPolicy(context, widget.model.session!.id) ||
        !mounted) {
      return;
    }
    widget.model.photoSelection(true);
    setState(() => error = null);
    try {
      final photo = await _photos.pick(source);
      if (mounted && photo != null) widget.model.setPhoto(photo);
    } catch (_) {
      if (mounted) {
        setState(
          () => error =
              'No pudimos preparar la foto. Prueba con una imagen JPG o PNG más pequeña.',
        );
      }
    } finally {
      widget.model.photoSelection(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.model, photo = model.pendingPhoto ?? model.photoBytes;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          'La foto de esta semana',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 6),
        const Text(
          'Un recuerdo de la reunión, junto a su asistencia. El pastor podrá revisarlo en el historial.',
        ),
        const SizedBox(height: 14),
        if (photo != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.memory(
              photo,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              semanticLabel: 'Foto de la reunión semanal',
              errorBuilder: (context, error, stack) =>
                  const FeedbackPanel('No pudimos mostrar esta foto.'),
            ),
          ),
        if (photo == null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFEDF1E8),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Column(
              children: [
                AppIcon(Symbol.camera),
                SizedBox(height: 8),
                Text('Todavía no hay una foto de esta reunión.'),
              ],
            ),
          ),
        if (model.canWrite)
          Wrap(
            spacing: 12,
            children: [
              TextButton.icon(
                onPressed: model.busy || model.pickingPhoto
                    ? null
                    : () => pick(ImageSource.camera),
                icon: const AppIcon(Symbol.camera, size: 20),
                label: const Text('Tomar foto'),
              ),
              TextButton(
                onPressed: model.busy || model.pickingPhoto
                    ? null
                    : () => pick(ImageSource.gallery),
                child: const Text('Elegir de galería'),
              ),
              if (model.pendingPhoto != null)
                TextButton(
                  onPressed: model.busy ? null : model.discardPhoto,
                  child: const Text('Deshacer cambio'),
                ),
            ],
          ),
        if (model.photoBytes != null)
          TextButton(
            onPressed: () => openContentReport(
              context,
              model.repository,
              'Célula ${model.cell?.id}; semana ${model.week}; foto de reunión',
            ),
            child: const Text('Reportar esta foto o usuario'),
          ),
        if (model.pickingPhoto) const Text('Preparando la foto…'),
        if (model.pendingPhoto != null)
          const Text('Foto pendiente. Se enviará al guardar la reunión.'),
        if (recovered != null && model.canWrite)
          FeedbackPanel(
            'El teléfono recuperó una foto que no se había enviado. Comprueba que corresponde a esta semana.',
            action: TextButton(
              onPressed: model.busy
                  ? null
                  : () async {
                      if (!await acceptPhotoPolicy(
                            context,
                            model.session!.id,
                          ) ||
                          !mounted) {
                        return;
                      }
                      model.setPhoto(recovered!);
                      setState(() => recovered = null);
                    },
              child: const Text('Usar en esta semana'),
            ),
          ),
        if (error ?? model.photoError case final message?)
          FeedbackPanel(message, error: true),
      ],
    );
  }
}
