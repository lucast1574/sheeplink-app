import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../data/repositories/community_repository.dart';
import '../../../../data/services/api_client.dart';
import '../view_models/community_view_model.dart';

class DailyJournal extends StatefulWidget {
  const DailyJournal({super.key, required this.model});
  final CommunityViewModel model;
  @override
  State<DailyJournal> createState() => _DailyJournalState();
}

class _DailyJournalState extends State<DailyJournal> {
  final reading = TextEditingController(), reflection = TextEditingController();
  String? root, error;
  bool busy = false;
  String get date => DateFormat('yyyy-MM-dd').format(DateTime.now());
  ApiCommunityRepository get repo =>
      widget.model.repository as ApiCommunityRepository;
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final personal = (await repo.client.dio.get<Map<String, dynamic>>(
        '/personal',
      )).data!;
      final memberId = personal['member']?['_id'] ?? personal['member']?['id'];
      root = memberId == null
          ? '/personal/devotionals'
          : '/care/members/$memberId/devotionals';
      final data = (await repo.client.dio.get<Map<String, dynamic>>(
        root!,
        queryParameters: {'date': date},
      )).data!;
      if (mounted) {
        reading.text = data['entry']?['reading'] ?? '';
        reflection.text = data['entry']?['reflection'] ?? '';
        setState(() {});
      }
    } catch (e) {
      if (mounted) setState(() => error = friendlyError(e));
    }
  }

  @override
  void dispose() {
    reading.dispose();
    reflection.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Card(
    elevation: 0,
    color: Theme.of(context).colorScheme.surface,
    margin: EdgeInsets.zero,
    child: Padding(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Mi devocional de hoy',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          const Text('Lectura bíblica'),
          const SizedBox(height: 8),
          TextField(
            controller: reading,
            decoration: const InputDecoration(hintText: 'Ej. Salmo 23'),
            textInputAction: TextInputAction.next,
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
          ),
          const SizedBox(height: 16),
          const Text('Mi reflexión'),
          const SizedBox(height: 8),
          TextField(
            controller: reflection,
            minLines: 4,
            maxLines: 10,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => FocusScope.of(context).unfocus(),
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            decoration: const InputDecoration(
              hintText: '¿Qué te dejó la lectura de hoy?',
            ),
          ),
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(error!),
            ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: busy || root == null
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();
                      setState(() => busy = true);
                      try {
                        await repo.client.dio.put<void>(
                          root == '/personal/devotionals'
                              ? root!
                              : root!.replaceFirst(
                                  '/devotionals',
                                  '/devotional',
                                ),
                          data: {
                            'date': date,
                            'reading': reading.text.trim(),
                            'reflection': reflection.text.trim(),
                          },
                        );
                        if (mounted) {
                          setState(() => error = 'Devocional guardado.');
                        }
                      } catch (e) {
                        if (mounted) setState(() => error = friendlyError(e));
                      } finally {
                        if (mounted) setState(() => busy = false);
                      }
                    },
              child: Text(busy ? 'Guardando…' : 'Guardar devocional'),
            ),
          ),
        ],
      ),
    ),
  );
}
