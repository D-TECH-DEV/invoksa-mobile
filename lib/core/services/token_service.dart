import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TokenService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'jwt_token', value: token);
  }

  Future<String?> getToken() async {
    String? token = await _storage.read(key: 'jwt_token');

    if (token != null && JwtDecoder.isExpired(token)) {
      await deleteToken();
      return null;
    }

    return token;
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'jwt_token');
  }
}