import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'secure_cookie_storage.dart';

class ApiClient {
  ApiClient({Dio? transport, this.storage = const FlutterSecureStorage()}) {
    cookies = PersistCookieJar(storage: SecureCookieStorage(storage));
    dio =
        transport ??
        Dio(
          BaseOptions(
            baseUrl: const String.fromEnvironment(
              'API_URL',
              defaultValue: 'https://dashboard-sheeplink.nexode.app/api',
            ),
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 25),
            headers: {
              'X-Requested-With': 'XMLHttpRequest',
              'User-Agent': 'SheepLink/0.1 (Flutter)',
            },
          ),
        );
    dio.interceptors.add(CookieManager(cookies));
  }
  final FlutterSecureStorage storage;
  late final Dio dio;
  late final PersistCookieJar cookies;
  Future<void> clearSession() => cookies.deleteAll();
}

String friendlyError(Object error) {
  if (error is DioException) {
    final body = error.response?.data;
    if (body is Map && body['message'] is String) {
      return body['message'] as String;
    }
    if (error.response?.statusCode == 401) {
      return 'Tu sesión terminó. Vuelve a ingresar.';
    }
    return 'No pudimos conectar. Revisa tu conexión e inténtalo de nuevo.';
  }
  return 'No pudimos completar la acción. Inténtalo de nuevo.';
}
