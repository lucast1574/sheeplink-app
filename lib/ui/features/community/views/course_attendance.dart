import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../data/repositories/community_repository.dart';
import '../../../../data/services/api_client.dart';
import '../../../core/widgets/app_icon.dart';
import '../view_models/community_view_model.dart';

class CourseAttendance extends StatefulWidget {
  const CourseAttendance({super.key, required this.model});
  final CommunityViewModel model;
  @override
  State<CourseAttendance> createState() => _CourseAttendanceState();
}

class _CourseAttendanceState extends State<CourseAttendance> {
  List<dynamic>? courses;
  String? error;
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final repo = widget.model.repository as ApiCommunityRepository;
      final rows = (await repo.client.dio.get<List<dynamic>>(
        '/academy/courses',
      )).data!;
      final own = rows
          .where(
            (c) =>
                c['status'] != 'FINISHED' &&
                (c['leaderId'] is Map ? c['leaderId']['_id'] : c['leaderId']) ==
                    widget.model.session!.id,
          )
          .toList();
      for (final course in own) {
        if (course['coverVersion'] != null) {
          course['coverUrl'] =
              '${repo.client.dio.options.baseUrl}/course-portal/${course['_id']}/cover?v=${course['coverVersion']}';
        }
      }
      if (mounted) setState(() => courses = own);
    } catch (e) {
      if (mounted) setState(() => error = friendlyError(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (error != null) return Text(error!);
    if (courses == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (courses!.isEmpty) {
      return const Text('No tienes cursos activos asignados como maestro.');
    }
    if (courses!.length == 1) {
      return CourseRoster(model: widget.model, course: courses!.first);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Asistencia de cursos',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 16),
        for (final course in courses!)
          Card(
            child: InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => Scaffold(
                    appBar: AppBar(title: Text(course['name'])),
                    body: SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: const EdgeInsets.all(16),
                      child: CourseRoster(model: widget.model, course: course),
                    ),
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    if (course['coverUrl'] is String)
                      FutureBuilder<dynamic>(
                        future:
                            (widget.model.repository as ApiCommunityRepository)
                                .client
                                .dio
                                .get<List<int>>(
                                  course['coverUrl'],
                                  options: Options(
                                    responseType: ResponseType.bytes,
                                  ),
                                ),
                        builder: (context, snapshot) => snapshot.hasData
                            ? SizedBox(
                                width: 64,
                                height: 64,
                                child: Image.memory(
                                  Uint8List.fromList(
                                    List<int>.from(snapshot.data.data),
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const AppIcon(Symbol.calendar, size: 40),
                      )
                    else
                      const AppIcon(Symbol.calendar, size: 40),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        course['name'],
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    const AppIcon(Symbol.arrow),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class CourseRoster extends StatefulWidget {
  const CourseRoster({super.key, required this.model, required this.course});
  final CommunityViewModel model;
  final Map<String, dynamic> course;
  @override
  State<CourseRoster> createState() => _CourseRosterState();
}

class _CourseRosterState extends State<CourseRoster> {
  List<dynamic>? students;
  final marks = <String, bool>{};
  String? message;
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
      final root = '/academy/courses/${widget.course['_id']}';
      final rows = (await repo.client.dio.get<List<dynamic>>(
        '$root/students',
      )).data!;
      final attendance = (await repo.client.dio.get<List<dynamic>>(
        '$root/attendance',
        queryParameters: {'from': date, 'to': date},
      )).data!;
      for (final r in attendance) {
        marks[r['memberId']] = r['present'] == true;
      }
      if (mounted) {
        setState(
          () => students = rows.where((s) => s['result'] != 'REMOVED').toList(),
        );
      }
    } catch (e) {
      if (mounted) setState(() => message = friendlyError(e));
    }
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        widget.course['name'],
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      Text('Asistencia de hoy · $date'),
      if (message != null) Text(message!),
      if (students == null) const LinearProgressIndicator(),
      for (final s in students ?? [])
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s['memberName'] ?? 'Alumno'),
                const SizedBox(height: 12),
                Row(
                  spacing: 8,
                  children: [
                    for (final present in [true, false])
                      Expanded(
                        child: ChoiceChip(
                          label: Text(present ? 'Presente' : 'Ausente'),
                          selected: marks[s['memberId']] == present,
                          onSelected: busy
                              ? null
                              : (_) => setState(
                                  () => marks[s['memberId']] = present,
                                ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      FilledButton(
        onPressed:
            busy ||
                students == null ||
                students!.isEmpty ||
                students!.any((s) => !marks.containsKey(s['memberId']))
            ? null
            : () async {
                setState(() => busy = true);
                try {
                  await repo.client.dio.post<void>(
                    '/academy/courses/${widget.course['_id']}/attendance',
                    data: {
                      'date': date,
                      'records': [
                        for (final s in students!)
                          {
                            'memberId': s['memberId'],
                            'present': marks[s['memberId']],
                          },
                      ],
                    },
                  );
                  if (mounted) setState(() => message = 'Asistencia guardada.');
                } catch (e) {
                  if (mounted) setState(() => message = friendlyError(e));
                } finally {
                  if (mounted) setState(() => busy = false);
                }
              },
        child: Text(busy ? 'Guardando…' : 'Guardar asistencia'),
      ),
    ],
  );
}
