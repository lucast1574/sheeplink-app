import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureCookieStorage implements Storage {
  const SecureCookieStorage(this.storage);
  final FlutterSecureStorage storage;
  String key(String value) => 'sheeplink.cookie.$value';
  @override
  Future<void> init(bool persistSession, bool ignoreExpires) async {}
  @override
  Future<String?> read(String name) => storage.read(key: key(name));
  @override
  Future<void> write(String name, String value) =>
      storage.write(key: key(name), value: value);
  @override
  Future<void> delete(String name) => storage.delete(key: key(name));
  @override
  Future<void> deleteAll(List<String> keys) async {
    for (final name in keys) {
      await delete(name);
    }
  }
}
