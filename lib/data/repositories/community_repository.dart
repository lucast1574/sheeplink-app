import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import '../../domain/models/personal_profile.dart';
import '../../domain/models/weekly_meeting.dart';
import '../../domain/models/community.dart';
import '../services/api_client.dart';

abstract interface class CommunityRepository {
  Future<PersonalProfile> personal();
  Future<void> reportContent(String context, String message, String requestId);
  Future<Session> updateAvatar(String photoData);
  Future<WeeklyMeeting> meeting(String cellId, String week);
  Future<WeeklyMeeting> saveMeeting(
    String cellId,
    String week,
    String date,
    String? photoData,
  );
  Future<Uint8List> photo(String url);
  Future<Session> session();
  Future<Session> login(String email, String password);
  Future<Session> loginGoogle(String firebaseIdToken);
  Future<void> logout();
  Future<List<Cell>> cells();
  Future<List<Member>> members(String cellId);
  Future<Map<String, bool>> attendance(String cellId, String day);
  Future<void> saveAttendance(
    String cellId,
    String day,
    Map<String, bool> records,
  );
  Future<void> registerDevice(String token);
  Future<void> revokeDevice(String token);
}

class ApiCommunityRepository implements CommunityRepository {
  ApiCommunityRepository(this.client);
  final ApiClient client;
  String? _photoUser;
  Future<Session> _restorePhoto(Session session) async {
    _photoUser = session.id;
    if (session.photoUrl != null) return session;
    final cached = await client.storage.read(
      key: 'sheeplink.google-photo.${session.id}',
    );
    return session.withPhoto(googlePhoto(cached));
  }

  @override
  Future<void> reportContent(
    String context,
    String message,
    String requestId,
  ) async {
    const escape = HtmlEscape();
    await client.dio.post<void>(
      '/support/tickets',
      data: {
        'title': 'Reporte de contenido o usuario',
        'html':
            '<p>${escape.convert(context)}</p><p>${escape.convert(message)}</p>',
        'images': <String>[],
        'requestId': requestId,
      },
    );
  }

  @override
  Future<Session> updateAvatar(String photoData) async => Session.fromJson(
    (await client.dio.patch<Map<String, dynamic>>(
      '/personal/profile',
      data: {'photoUrl': photoData},
    )).data!,
  );
  @override
  Future<PersonalProfile> personal() async => PersonalProfile.fromJson(
    (await client.dio.get<Map<String, dynamic>>('/personal')).data!,
  );
  @override
  Future<WeeklyMeeting> meeting(String cellId, String week) async =>
      WeeklyMeeting.fromJson(
        (await client.dio.get<Map<String, dynamic>>(
          '/cells/$cellId/meetings/$week',
        )).data!,
      );
  @override
  Future<WeeklyMeeting> saveMeeting(
    String cellId,
    String week,
    String date,
    String? photoData,
  ) async => WeeklyMeeting.fromJson(
    (await client.dio.put<Map<String, dynamic>>(
      '/cells/$cellId/meetings/$week',
      data: {'date': date, 'photoData': ?photoData},
    )).data!,
  );
  @override
  Future<Uint8List> photo(String url) async {
    final base = Uri.parse(client.dio.options.baseUrl);
    final target = base.resolve(url);
    if (target.scheme == 'https' &&
        target.host.endsWith('.googleusercontent.com') &&
        target.userInfo.isEmpty &&
        target.port == 443) {
      final response =
          await Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 15),
              followRedirects: false,
            ),
          ).get<List<int>>(
            target.toString(),
            options: Options(responseType: ResponseType.bytes),
          );
      return Uint8List.fromList(response.data!);
    }
    if (target.origin != base.origin ||
        !(target.path.startsWith('/api/cells/') ||
            target.path.startsWith('/api/media/'))) {
      throw StateError('Invalid photo');
    }
    final response = await client.dio.get<List<int>>(
      target.toString(),
      options: Options(responseType: ResponseType.bytes),
    );
    return Uint8List.fromList(response.data!);
  }

  @override
  Future<Session> session() async => _restorePhoto(
    Session.fromJson(
      (await client.dio.get<Map<String, dynamic>>('/auth/me')).data!,
    ),
  );
  @override
  Future<Session> login(String email, String password) async =>
      Session.fromJson(
        (await client.dio.post<Map<String, dynamic>>(
          '/auth/login',
          data: {'email': email, 'password': password},
        )).data!,
      );
  @override
  Future<Session> loginGoogle(String firebaseIdToken) async {
    final session = Session.fromJson(
      (await client.dio.post<Map<String, dynamic>>(
        '/auth/google',
        data: {'idToken': firebaseIdToken},
      )).data!,
    );
    // Only inspect a token after the backend accepted its verified Google identity.
    try {
      final claims =
          jsonDecode(
                utf8.decode(
                  base64Url.decode(
                    base64Url.normalize(firebaseIdToken.split('.')[1]),
                  ),
                ),
              )
              as Map<String, dynamic>;
      final photo = googlePhoto(claims['picture']);
      if (photo != null) {
        await client.storage.write(
          key: 'sheeplink.google-photo.${session.id}',
          value: photo,
        );
      }
    } catch (_) {
      /* A missing optional image must never fail authentication. */
    }
    return _restorePhoto(session);
  }

  @override
  Future<void> logout() async {
    try {
      await client.dio
          .post<void>('/auth/logout')
          .timeout(const Duration(seconds: 4));
    } on DioException {
      /* Local sign-out remains available offline. */
    } on TimeoutException {
      /* Do not hold the user in the account while offline. */
    } finally {
      await client.clearSession();
    }
    if (_photoUser != null) {
      await client.storage.delete(key: 'sheeplink.google-photo.$_photoUser');
    }
    _photoUser = null;
  }

  @override
  Future<List<Cell>> cells() async => ((await client.dio.get<List<dynamic>>(
    '/cells',
  )).data!).map((e) => Cell.fromJson(e as Map<String, dynamic>)).toList();
  @override
  Future<List<Member>> members(String cellId) async =>
      ((await client.dio.get<List<dynamic>>(
        '/members',
        queryParameters: {'cellId': cellId, 'status': 'ACTIVE'},
      )).data!).map((e) => Member.fromJson(e as Map<String, dynamic>)).toList();
  @override
  Future<Map<String, bool>> attendance(String cellId, String day) async {
    final rows = (await client.dio.get<List<dynamic>>(
      '/attendances',
      queryParameters: {'cellId': cellId, 'from': day, 'to': day},
    )).data!;
    return {
      for (final row in rows)
        (row['memberId'] is Map ? row['memberId']['_id'] : row['memberId'])
                as String:
            row['present'] as bool,
    };
  }

  @override
  Future<void> saveAttendance(
    String cellId,
    String day,
    Map<String, bool> records,
  ) async {
    await client.dio.post<void>(
      '/attendances',
      data: {
        'cellId': cellId,
        'date': day,
        'records': records.entries
            .map((e) => {'memberId': e.key, 'present': e.value})
            .toList(),
      },
    );
  }

  @override
  Future<void> registerDevice(String token) async {
    await client.dio.post<void>(
      '/notifications/devices',
      data: {'token': token},
    );
  }

  @override
  Future<void> revokeDevice(String token) async {
    await client.dio.delete<void>(
      '/notifications/devices',
      data: {'token': token},
    );
  }
}
