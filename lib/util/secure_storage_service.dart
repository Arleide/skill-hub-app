import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../model/login_response.dart';
import '../model/token_user.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();

  static const _keyAccessToken = 'access_token';
  static const _keyRefreshToken = 'refresh_token';

  // Salvar tokens
  static Future<void> saveLogin(LoginResponse response) async {
    await _storage.write(
      key: _keyAccessToken,
      value: response.accessToken,
    );

    await _storage.write(
      key: _keyRefreshToken,
      value: response.refreshTokenToken,
    );
  }

  // Access token
  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _keyAccessToken);
  }

  // Refresh token
  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _keyRefreshToken);
  }

  //Dados do usuário a partir do JWT
  static Future<TokenUser?> getLoggedUser() async {
    final token = await getAccessToken();

    if (token == null) return null;

    // Verifica se o token expirou
    if (JwtDecoder.isExpired(token)) {
      return null;
    }

    final Map<String, dynamic> claims = JwtDecoder.decode(token);

    return TokenUser.fromClaims(claims);
  }

  // Logout
  static Future<void> clear() async {
    await _storage.deleteAll();
  }
}
