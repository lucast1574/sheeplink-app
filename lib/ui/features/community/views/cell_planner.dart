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
      participants = [...?data['members'], ...?data['plannerMembers']];
      participants = {
        for (final member in participants) member['_id']: member,
      }.values.toList();
      items = [
        for (final i in plan?['items'] ?? []) Map<String, dynamic>.from(i),
      ];
      if (items.isEmpty) {
        items = [
          for (final name in ['Bienvenida', 'Alabanza', 'Palabra', 'Oración'])
            {'key': name, 'title': name, 'minutes': 10, 'notes': ''},
        ];
      }
      if (mounted) {
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
        for (final item in items)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(item['title']),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  initialValue:
                      participants.any((m) => m['_id'] == item['memberId'])
                      ? item['memberId']
                      : '',
                  decoration: const InputDecoration(),
                  items: [
                    const DropdownMenuItem(
                      value: '',
                      child: Text('Sin asignar'),
                    ),
                    for (final member in participants)
                      DropdownMenuItem(
                        value: member['_id'] as String,
                        child: Text(member['name']),
                      ),
                  ],
                  onChanged: editable
                      ? (value) => setState(() => item['memberId'] = value)
                      : null,
                ),
              ],
            ),
          ),
        if (error != null) Text(error!),
        if (editable)
          FilledButton(
            onPressed: busy || widget.model.cell == null
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    setState(() => busy = true);
                    try {
                      await repo.client.dio.put<void>(
                        '/care/cells/${widget.model.cell!.id}/plan',
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
      ],
    );
  }
}
