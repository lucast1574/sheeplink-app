import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';
import '../../../../domain/models/personal_profile.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_icon.dart';

class ServiceSection extends StatelessWidget {
  const ServiceSection({
    super.key,
    required this.assignments,
    this.busy = false,
    this.onAccept,
    this.onDecline,
  });
  final List<ServiceAssignment> assignments;
  final bool busy;
  final Future<void> Function(ServiceAssignment shift)? onAccept;
  final Future<void> Function(ServiceAssignment shift, String? reason)?
  onDecline;

  Future<void> _confirmAbsence(
    BuildContext context,
    ServiceAssignment shift,
  ) async {
    final controller = TextEditingController();
    final reason = await showDialog<String?>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reportar ausencia'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${shift.ministry} · ${shift.time}'),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLength: 200,
              decoration: const InputDecoration(
                labelText: 'Motivo (opcional)',
                hintText: 'Ej. Viaje o tema familiar',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Confirmar ausencia'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (reason != null && onDecline != null) {
      await onDecline!(shift, reason.isEmpty ? null : reason);
    }
  }
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final upcoming =
        assignments
            .where(
              (s) =>
                  !s.blocked &&
                  s.confirmation != 'DECLINED' &&
                  s.startsAt.add(const Duration(hours: 3)).isAfter(now),
            )
            .toList()
          ..sort((a, b) => a.startsAt.compareTo(b.startsAt));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const AppIcon(Symbol.calendar, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Tu servicio',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (upcoming.isEmpty)
          const Text(
            'No tienes turnos próximos asignados. Cuando tu líder programe uno, aparecerá aquí.',
          ),
        for (final shift in upcoming.take(3))
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: shift.confirmed ? AppTheme.leaf : Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateUtils.isSameDay(
                        shift.startsAt,
                        tz.TZDateTime.from(now, shift.startsAt.location),
                      )
                      ? (shift.confirmed
                            ? 'Hoy te toca servir'
                            : 'Asignación de hoy')
                      : '${DateFormat("EEEE d 'de' MMMM", 'es').format(shift.startsAt)} · ${shift.time}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  shift.ministry,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '${shift.role.isEmpty ? 'Servicio' : shift.role} · ${shift.time}',
                ),
                if (!shift.confirmed)
                  const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Text(
                      'Asignación pendiente de confirmar. Aún no genera recordatorios.',
                    ),
                  ),
                if (shift.shiftId.isNotEmpty &&
                    (onAccept != null || onDecline != null)) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (!shift.confirmed && onAccept != null)
                        FilledButton(
                          onPressed: busy ? null : () => onAccept!(shift),
                          child: const Text('Aceptar'),
                        ),
                      if (onDecline != null)
                        OutlinedButton(
                          onPressed: busy
                              ? null
                              : () => _confirmAbsence(context, shift),
                          child: const Text('No puedo asistir'),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}
