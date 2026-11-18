import '../../../../l10n/locale.dart';
import '../../../core/widgets/report_content.dart';
import '../../../core/widgets/photo_policy.dart';
import '../../../core/widgets/photo_feedback.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../data/services/photo_service.dart';
import '../view_models/community_view_model.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/feedback_panel.dart';
import '../../../core/theme/app_theme.dart';

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
    final model = widget.model;
    if (model.busy || model.pickingPhoto || model.session == null) return;
    FocusManager.instance.primaryFocus?.unfocus();
    // Claim the entire operation, including consent, so a double tap cannot open
    // overlapping dialogs/native pickers. Always release it on every exit.
    model.photoSelection(true);
    setState(() => error = null);
    try {
      if (!await acceptPhotoPolicy(context, model.session!.id) || !mounted) {
        return;
      }
      final photo = await _photos.pick(source);
      if (mounted && photo != null) model.setPhoto(photo);
    } catch (e) {
      if (mounted) setState(() => error = photoFailureMessage(e));
    } finally {
      model.photoSelection(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.model, photo = model.pendingPhoto ?? model.photoBytes;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr("La foto de esta semana"),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 6),
        Text(
          tr(
            "Un recuerdo de la reunión, junto a su asistencia. El pastor podrá revisarlo en el historial.",
          ),
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
              semanticLabel: tr("Foto de la reunión semanal"),
              errorBuilder: (context, error, stack) =>
                  FeedbackPanel(tr("No pudimos mostrar esta foto.")),
            ),
          ),
        if (photo == null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                AppIcon(Symbol.camera),
                SizedBox(height: 8),
                Text(tr("Todavía no hay una foto de esta reunión.")),
              ],
            ),
          ),
        if (model.canWrite) ...[
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: model.busy || model.pickingPhoto
                      ? null
                      : () => pick(ImageSource.camera),
                  style: TextButton.styleFrom(alignment: Alignment.centerLeft),
                  icon: const AppIcon(Symbol.camera, size: 20),
                  label: Text(tr('Tomar foto')),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextButton(
                  onPressed: model.busy || model.pickingPhoto
                      ? null
                      : () => pick(ImageSource.gallery),
                  style: TextButton.styleFrom(alignment: Alignment.centerRight),
                  child: Text(
                    tr('Elegir de galería'),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
            ],
          ),
          if (model.pendingPhoto != null)
            TextButton(
              onPressed: model.busy ? null : model.discardPhoto,
              child: Text(tr('Deshacer cambio')),
            ),
        ],
        if (model.photoBytes != null)
          TextButton(
            onPressed: () => openContentReport(
              context,
              model.repository,
              tr("Célula {{p0}}; semana {{p1}}; foto de reunión", {
                'p0': model.cell?.id,
                'p1': model.week,
              }),
            ),
            child: Text(tr("Reportar esta foto o usuario")),
          ),
        if (model.pickingPhoto) Text(tr("Preparando la foto…")),
        if (model.pendingPhoto != null)
          Text(tr("Foto pendiente. Se enviará al guardar la reunión.")),
        if (recovered != null && model.canWrite)
          FeedbackPanel(
            tr(
              "El teléfono recuperó una foto que no se había enviado. Comprueba que corresponde a esta semana.",
            ),
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
              child: Text(tr("Usar en esta semana")),
            ),
          ),
        if (error ?? model.photoError case final message?)
          FeedbackPanel(message, error: true),
      ],
    );
  }
}
