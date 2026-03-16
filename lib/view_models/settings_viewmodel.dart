import 'package:invoksa/core/services/token_service.dart';

class SettingsViewmodel {
  final TokenService _tokenService = TokenService();
  Future<bool> logout() async {
    _tokenService.deleteToken();
    return false;
  }
}