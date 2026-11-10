import 'planner_activity_picker.dart';
import 'planner_activity_order.dart';
import '../../../core/widgets/person_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../data/repositories/community_repository.dart';
import '../../../../data/services/api_client.dart';
import '../view_models/community_view_model.dart';
import 'attendance_view.dart';

class CellWorkspace extends StatefulWidget {
  const CellWorkspace({super.key, required this.model});
  final CommunityViewModel model;
  @override
  State<CellWorkspace> createState() => _CellWorkspaceState();
}

class _CellWorkspaceState extends State<CellWorkspace> {
  bool planning = false;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      SegmentedButton<bool>(
        segments: const [
          ButtonSegment(value: false, label: Text('Asistencia')),
          ButtonSegment(value: true, label: Text('Planificador')),
        ],
        selected: {planning},
        onSelectionChanged: (v) {
          FocusScope.of(context).unfocus();
          setState(() => planning = v.first);
        },
      ),
      const SizedBox(height: 16),
      if (planning)
        CellPlanner(
          key: ValueKey('${widget.model.cell?.id}/${widget.model.day}'),
          model: widget.model,
        )
      else
        AttendanceView(model: widget.model),
    ],
  );
}

class CellPlanner extends StatefulWidget {
  const CellPlanner({super.key, required this.model});
  final CommunityViewModel model;
  @override
  State<CellPlanner> createState() => _CellPlannerState();
}

class _CellPlannerState extends State<CellPlanner> {
  final title = TextEditingController();
  List<Map<String, dynamic>> items = [];
  List<dynamic> participants = [];
  Map<String, dynamic>? plan;
  Map<String, dynamic> settings = {};
  List<Map<String, dynamic>> get activityOptions {
    final result = [...items];
    for (final raw in [...?settings['activities'], ...?settings['options']]) {
      final item = Map<String, dynamic>.from(raw);
      if (!result.any((x) => x['title'] == item['title'])) result.add(item);
    }
    return orderPlannerActivities(result);
  }

  Future<void> chooseActivities(bool habitual) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final options = activityOptions;
    final chosen = habitual
        ? options
              .where(
                (x) => (settings['activities'] as List? ?? []).any(
                  (a) => a['title'] == x['title'],
                ),
              )
              .map((x) => x['key'] as String)
              .toSet()
        : items
              .where((x) => x['enabled'] != false)
              .map((x) => x['key'] as String)
              .toSet();
    await showPlannerActivityPicker(
      context,
      title: habitual
          ? 'Actividades habituales'
          : 'Actividades de esta reunión',
      description: habitual
          ? 'Se usarán en las nuevas reuniones. Las reuniones guardadas no cambian.'
          : 'Elige lo que harán en esta fecha. Conservaremos las asignaciones de lo que no hagan.',
      options: options,
      selected: chosen,
      onSave: (selected) async {
        if (habitual) {
          final response = await repo.client.dio.put<Map<String, dynamic>>(
            '/care/cells/${widget.model.cell!.id}/planner-settings',
            data: {
              'activities': options
                  .where((x) => selected.contains(x['key']))
                  .toList(),
              'version': settings['version'] ?? 0,
            },
          );
          if (mounted) setState(() => settings = response.data!);
        } else if (mounted) {
          setState(
            () => items = [
              for (final option in options)
                {...option, 'enabled': selected.contains(option['key'])},
            ],
          );
        }
      },
    );
  }

  String? error;
  bool busy = false;
  bool loading = true;
  ApiCommunityRepository get repo =>
      widget.model.repository as ApiCommunityRepository;
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    if (widget.model.cell == null) {
      setState(() => loading = false);
      return;
    }
    try {
      final data = (await repo.client.dio.get<Map<String, dynamic>>(
        '/care/cells/${widget.model.cell!.id}',
        queryParameters: {'date': widget.model.day},
      )).data!;
      plan = data['plan'];
      settings = Map<String, dynamic>.from(data['plannerSettings'] ?? {});
      participants = [...?data['members'], ...?data['plannerMembers']];
      participants = {
        for (final member in participants) member['_id']: member,
      }.values.toList();
      items = [
        for (final i in plan?['items'] ?? settings['activities'] ?? [])
          Map<String, dynamic>.from(i),
      ];
      if (plan == null &&
          !settings.containsKey('activities') &&
          items.isEmpty) {
        items = [
          for (final name in [
            'Bienvenida',
            'Alabanza',
            'Palabra',
            'Oración',
            'Despedida',
          ])
            {'key': name, 'title': name, 'minutes': 10, 'notes': ''},
        ];
      }
      if (mounted) {
        items = orderPlannerActivities(items);
        title.text = plan?['title'] ?? '';
        setState(() {});
      }
    } catch (e) {
      if (mounted) setState(() => error = friendlyError(e));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editable =
        widget.model.session?.permissions.contains('planner.write') ?? false;
    if (widget.model.cell == null) {
      return const Text(
        'Selecciona una célula para consultar su plan semanal.',
      );
    }
    if (loading) return const Center(child: CircularProgressIndicator());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Plan de ${widget.model.cell!.name}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 6),
        Text(DateFormat("EEEE d 'de' MMMM", 'es').format(widget.model.date)),
        const SizedBox(height: 24),
        if (!editable) ...[
          const Text(
            'Puedes consultar el plan. Solo los responsables de la célula pueden editarlo.',
          ),
          const SizedBox(height: 16),
        ],
        const Text('Título del encuentro'),
        const SizedBox(height: 8),
        TextField(
          key: const ValueKey('meeting-title'),
          controller: title,
          readOnly: !editable,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => FocusScope.of(context).unfocus(),
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
          maxLength: 150,
          decoration: const InputDecoration(
            hintText: '¿Qué compartirán esta semana?',
            counterText: '',
          ),
        ),
        const SizedBox(height: 20),
        if (!items.any((i) => i['enabled'] != false))
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text('No hay actividades seleccionadas para esta reunión.'),
          ),
        for (final item in items.where((i) => i['enabled'] != false))
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  item['title'],
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                const Text('Responsable'),
                const SizedBox(height: 8),
                PersonPicker(
                  label: item['title'],
                  value: item['memberId'],
                  options: {
                    for (final member in participants)
                      member['_id'] as String: member['name'] as String,
                  },
                  onChanged: editable && !busy
                      ? (value) => setState(() => item['memberId'] = value)
                      : null,
                ),
                const SizedBox(height: 16),
                const Text('Descripción'),
                const SizedBox(height: 8),
                TextFormField(
                  key: ValueKey(
                    'activity-description-${item['key']}-${plan?['version'] ?? 0}',
                  ),
                  initialValue: item['notes'] as String? ?? '',
                  readOnly: !editable || busy,
                  minLines: 2,
                  maxLines: 5,
                  maxLength: 1000,
                  scrollPadding: const EdgeInsets.only(bottom: 120),
                  textInputAction: TextInputAction.done,
                  onChanged: (value) => item['notes'] = value,
                  onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
                  onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  decoration: InputDecoration(
                    hintText:
                        'Indicaciones para ${item['title'].toString().toLowerCase()}',
                    counterText: '',
                  ),
                ),
              ],
            ),
          ),
        if (error != null) ...[Text(error!), const SizedBox(height: 16)],
        const SizedBox(height: 12),
        if (editable)
          FilledButton(
            onPressed: busy || widget.model.cell == null
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    setState(() => busy = true);
                    try {
                      await repo.client.dio.put<void>(
                        '/care/cells/${plan?['cellId'] ?? widget.model.cell!.id}/plan',
                        data: {
                          'date': widget.model.day,
                          'title': title.text.trim(),
                          'items': items
                              .map(
                                (i) => {
                                  ...i,
                                  if (i['memberId'] == '') 'memberId': null,
                                },
                              )
                              .toList(),
                          'participantCellIds':
                              plan?['participantCellIds'] ?? [],
                          'version': plan?['version'] ?? 0,
                        },
                      );
                      await load();
                      if (mounted) setState(() => error = 'Plan guardado.');
                    } catch (e) {
                      if (mounted) setState(() => error = friendlyError(e));
                    } finally {
                      if (mounted) setState(() => busy = false);
                    }
                  },
            child: const Text('Guardar plan'),
          ),
        const SizedBox(height: 24),
        if (editable) ...[
          TextButton(
            onPressed: busy ? null : () => chooseActivities(false),
            child: const Text('Elegir actividades de esta reunión'),
          ),
          TextButton(
            onPressed: busy ? null : () => chooseActivities(true),
            child: const Text('Configurar actividades habituales'),
          ),
          const SizedBox(height: 20),
        ],
      ],
    );
  }
}
