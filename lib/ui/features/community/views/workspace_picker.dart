import 'package:flutter/material.dart';
import '../../../../data/repositories/community_repository.dart';
import '../../../../data/services/api_client.dart';
import '../view_models/community_view_model.dart';

class WorkspacePicker extends StatefulWidget {
  const WorkspacePicker({super.key, required this.model});
  final CommunityViewModel model;
  @override
  State<WorkspacePicker> createState() => _WorkspacePickerState();
}

class _WorkspacePickerState extends State<WorkspacePicker> {
  List<dynamic>? churches;
  String? error;
  bool busy = false;
  ApiCommunityRepository get repo =>
      widget.model.repository as ApiCommunityRepository;
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final rows = (await repo.client.dio.get<List<dynamic>>(
        '/admin/churches',
      )).data!;
      if (mounted) setState(() => churches = rows);
    } catch (e) {
      if (mounted) setState(() => error = friendlyError(e));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Tu espacio de trabajo')),
    body: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'Elige una iglesia',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 12),
        const Text(
          'Tu cuenta administra la plataforma. Selecciona la comunidad que quieres abrir en la app.',
        ),
        const SizedBox(height: 24),
        if (error != null) Text(error!),
        if (churches == null && error == null)
          const Center(child: CircularProgressIndicator()),
        for (final church in churches ?? [])
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              tileColor: Theme.of(context).inputDecorationTheme.fillColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(church['name']),
              subtitle: const Text('Abrir comunidad'),
              enabled: !busy,
              onTap: () async {
                setState(() {
                  busy = true;
                  error = null;
                });
                try {
                  await repo.selectWorkspace(
                    widget.model.session!.id,
                    church['id'] ?? church['_id'],
                  );
                  await widget.model.restore();
                } catch (e) {
                  if (mounted) setState(() => error = friendlyError(e));
                } finally {
                  if (mounted) setState(() => busy = false);
                }
              },
            ),
          ),
        if (error != null && churches == null)
          TextButton(onPressed: load, child: const Text('Reintentar')),
      ],
    ),
  );
}
