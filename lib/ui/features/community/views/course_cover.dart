import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../data/repositories/community_repository.dart';
import '../view_models/community_view_model.dart';

class CourseCover extends StatefulWidget {
  const CourseCover({super.key, required this.course, required this.model});
  final Map<String, dynamic> course;
  final CommunityViewModel model;
  @override
  State<CourseCover> createState() => _CourseCoverState();
}

class _CourseCoverState extends State<CourseCover> {
  Future<Uint8List?>? image;
  @override
  void initState() {
    super.initState();
    image = load();
  }

  Future<Uint8List?> load() async {
    final url = widget.course['coverUrl'];
    if (url is! String) return null;
    try {
      final repo = widget.model.repository as ApiCommunityRepository;
      final response = await repo.client.dio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      return Uint8List.fromList(response.data!);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final alternate =
        widget.course['name'].toString().codeUnits.fold(0, (a, b) => a + b) %
            3 ==
        1;
    final background = alternate ? '#dce8df' : '#eee5d3';
    final accent = alternate ? '#345f4c' : '#776447';
    final fallback = SvgPicture.string(
      '''<svg xmlns="http://www.w3.org/2000/svg" width="640" height="360" viewBox="0 0 640 360">
      <rect width="640" height="360" fill="$background"/>
      <path d="M0 290h640v70H0z" fill="$accent" opacity=".12"/>
      <path d="M82 0h110v290H82z" fill="#ffffff" opacity=".3"/>
      <path d="M102 0v290m30-290v290m30-290v290" stroke="$accent" stroke-opacity=".12" stroke-width="2"/>
      <path d="M205 132q55-30 115 0 60-30 115 0v145q-60-30-115 0-55-30-115 0z" fill="$accent"/>
      <path d="M215 119q52-26 105 1 53-27 105-1v144q-52-26-105 1-53-27-105-1z" fill="#fffaf0"/>
      <path d="M320 120v144M237 151l59 8m-59 18 59 8m-59 18 59 8m48-52 59-8m-59 34 59-8m-59 34 59-8" stroke="$accent" stroke-width="3" opacity=".45"/>
      <path d="M492 290v-77q-46-35-37-67 35 8 37 52 10-78 44-91 16 47-32 101v82" fill="$accent" opacity=".7"/>
      <path d="M468 270h54l-8 43h-38z" fill="$accent"/>
    </svg>''',
      fit: BoxFit.cover,
      semanticsLabel: 'Portada ilustrada del curso',
    );
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: FutureBuilder<Uint8List?>(
        future: image,
        builder: (context, snapshot) => snapshot.data == null
            ? fallback
            : Image.memory(
                snapshot.data!,
                fit: BoxFit.cover,
                semanticLabel: 'Portada de ${widget.course['name']}',
                errorBuilder: (_, _, _) => fallback,
              ),
      ),
    );
  }
}
