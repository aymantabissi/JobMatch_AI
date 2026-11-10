
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TokenStorage {
  static const _key = 'jwt_token';

  final _storage = const FlutterSecureStorage();

  Future<String?> read() {
    return _storage.read(key: _key);
  }

  Future<void> save(String token) {
    return _storage.write(key: _key, value: token);
  }

  Future<void> clear() {
    return _storage.delete(key: _key);
  }
}

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  return TokenStorage();
});
