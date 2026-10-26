import '../../../core/widgets/report_content.dart';
import 'package:url_launcher/url_launcher.dart';
import 'profile_header.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../../../../data/services/notification_service.dart';
import '../../community/view_models/community_view_model.dart';
import '../../../core/widgets/feedback_panel.dart';
import '../../../core/widgets/app_icon.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({
    super.key,
    required this.model,
    required this.notifications,
  });
  final CommunityViewModel model;
  final NotificationService notifications;
  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool working = false;
  String? error;
  Future<void> action(Future<void> Function() run) async {
    if (working) return;
    setState(() => working = true);
    try {
      await run();
    } catch (_) {
      if (mounted) {
        setState(
          () => error =
              'No pudimos completar la acción. Revisa tu conexión e inténtalo de nuevo.',
        );
      }
    } finally {
      if (mounted) setState(() => working = false);
    }
  }

  Future<void> logout() async {
    if (widget.model.pickingPhoto) return;
    if (widget.model.dirty && !await confirmDiscard(context)) return;
    await action(() async {
      try {
        await widget.notifications.disable().timeout(
          const Duration(seconds: 3),
        );
      } catch (_) {
        /* Notification cleanup must not block signing out. */
      }
      await widget.model.logout();
    });
  }

  Widget info(String title, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 4),
        Text(value),
      ],
    ),
  );
  @override
  Widget build(BuildContext context) {
    final notices = widget.notifications;
    final profile = widget.model.personal;
    return ListenableBuilder(
      listenable: notices,
      builder: (context, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileHeader(model: widget.model),
          const SizedBox(height: 24),
          if (profile.phone.isNotEmpty) info('Teléfono', profile.phone),
          if (profile.birthday != null)
            info(
              'Cumpleaños',
              DateFormat("d 'de' MMMM", 'es').format(profile.birthday!),
            ),
          if (profile.ministries.isNotEmpty)
            info('Ministerios', profile.ministries.join(' · ')),
          if (widget.model.cell != null)
            info('Mi célula', widget.model.cell!.name),
          if (profile.responsibilities.isNotEmpty)
            info('A mi cargo', profile.responsibilities.join('\n')),
          const SizedBox(height: 24),
          const AppIcon(Symbol.bell),
          const SizedBox(height: 12),
          Text(
            'Un recordatorio cercano',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          const Text(
            'Cumpleaños y servicio, a tu manera. Los turnos confirmados se recuerdan a las 19:00 del día anterior y dos horas antes. Abre la app para mantener tus avisos actualizados.',
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: working
                  ? null
                  : () => action(
                      () => notices.enabled
                          ? notices.disable()
                          : notices.enable(
                              widget.model.members,
                              widget.model.cell?.timezone ?? 'America/Lima',
                              assignments: profile.assignments,
                            ),
                    ),
              child: Text(
                working
                    ? 'Un momento…'
                    : notices.enabled
                    ? 'Desactivar avisos'
                    : 'Activar notificaciones',
              ),
            ),
          ),
          if (notices.enabled) ...[
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: const Text('Cumpleaños de mi célula'),
              value: notices.birthdaysEnabled,
              onChanged: working
                  ? null
                  : (value) => action(
                      () => notices.preferences(
                        birthdays: value,
                        members: widget.model.members,
                        timezone: widget.model.cell?.timezone ?? 'America/Lima',
                        assignments: profile.assignments,
                      ),
                    ),
            ),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: const Text('Mis turnos de servicio'),
              value: notices.serviceEnabled,
              onChanged: working
                  ? null
                  : (value) => action(
                      () => notices.preferences(
                        service: value,
                        members: widget.model.members,
                        timezone: widget.model.cell?.timezone ?? 'America/Lima',
                        assignments: profile.assignments,
                      ),
                    ),
            ),
          ],
          if (notices.status != null) ...[
            const SizedBox(height: 12),
            FeedbackPanel(notices.status!),
          ],
          if (error != null) ...[
            const SizedBox(height: 12),
            FeedbackPanel(error!, error: true),
          ],
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            children: [
              TextButton(
                onPressed: () => action(() async {
                  if (!await launchUrl(
                    Uri.parse('https://sheeplink.nexode.app/privacidad'),
                    mode: LaunchMode.externalApplication,
                  )) {
                    throw StateError('No browser');
                  }
                }),
                child: const Text('Privacidad'),
              ),
              TextButton(
                onPressed: () => action(() async {
                  if (!await launchUrl(
                    Uri.parse('https://sheeplink.nexode.app/terminos'),
                    mode: LaunchMode.externalApplication,
                  )) {
                    throw StateError('No browser');
                  }
                }),
                child: const Text('Términos'),
              ),
            ],
          ),
          TextButton(
            onPressed: () => openContentReport(
              context,
              widget.model.repository,
              'Perfil móvil; comunidad ${widget.model.session!.churchName}',
            ),
            child: const Text('Reportar contenido o usuario'),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF80524A),
                backgroundColor: const Color(0xFFF6EFEB),
                side: const BorderSide(color: Color(0xFFE5D7D0)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const AppIcon(Symbol.logout, size: 20),
              onPressed:
                  working || widget.model.busy || widget.model.pickingPhoto
                  ? null
                  : logout,
              label: const Text('Cerrar sesión'),
            ),
          ),
        ],
      ),
    );
  }
}
