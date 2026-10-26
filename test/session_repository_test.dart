import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheeplink/data/services/api_client.dart';
import 'package:sheeplink/data/repositories/community_repository.dart';

class SessionAdapter implements HttpClientAdapter {
  bool failLogout = false, rejectGoogle = false;
  String? customPhoto;
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? body,
    Future<void>? cancel,
  ) async {
    if (options.path == '/auth/logout' && failLogout) {
      throw DioException(
        requestOptions: options,
        type: DioExceptionType.connectionError,
      );
    }
    return ResponseBody.fromString(
      jsonEncode({
        'user': {
          'id': 'user',
          'name': 'Test User',
          'email': 'user@example.test',
          'permissions': [],
          if (customPhoto != null) 'photoUrl': customPhoto,
        },
        'church': {'name': 'Test'},
      }),
      options.path == '/auth/google' && rejectGoogle ? 403 : 200,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
        HttpHeaders.setCookieHeader: ['session=test-only; Path=/; HttpOnly'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const photo = 'https://lh3.googleusercontent.com/a/test';
  String token() =>
      'header.${base64Url.encode(utf8.encode(jsonEncode({'picture': photo})))}.signature';
  setUp(() => FlutterSecureStorage.setMockInitialValues({}));
  (ApiCommunityRepository, SessionAdapter, ApiClient) fixture() {
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api'));
    final adapter = SessionAdapter();
    dio.httpClientAdapter = adapter;
    final client = ApiClient(transport: dio);
    return (ApiCommunityRepository(client), adapter, client);
  }

  test(
    'accepted Google login persists photo across session restore and prefers custom avatar',
    () async {
      final (repo, adapter, client) = fixture();
      expect((await repo.loginGoogle(token())).photoUrl, photo);
      expect((await ApiCommunityRepository(client).session()).photoUrl, photo);
      adapter.customPhoto = '/api/media/users/user/avatar?v=1';
      expect((await repo.session()).photoUrl, adapter.customPhoto);
    },
  );
  test('rejected Google identity never stores its optional photo', () async {
    final (repo, adapter, client) = fixture();
    adapter.rejectGoogle = true;
    await expectLater(repo.loginGoogle(token()), throwsA(isA<DioException>()));
    expect(
      await client.storage.read(key: 'sheeplink.google-photo.user'),
      isNull,
    );
  });
  test('offline logout clears cookies and cached avatar', () async {
    final (repo, adapter, client) = fixture();
    await repo.loginGoogle(token());
    adapter.failLogout = true;
    await repo.logout();
    expect(
      await client.cookies.loadForRequest(
        Uri.parse('https://example.test/api'),
      ),
      isEmpty,
    );
    expect(
      await client.storage.read(key: 'sheeplink.google-photo.user'),
      isNull,
    );
  });
}
