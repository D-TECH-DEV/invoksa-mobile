import 'package:flutter/material.dart';
import '../../repositories/auth_repository.dart';
import '../../core/services/token_service.dart';
import '../../models/user.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  final TokenService _tokenService = TokenService();

  bool isLoading = false;
  String? errorMessage;

  Future<bool> login(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();

      User user = await _authRepository.login(email, password);

      //await _tokenService.saveToken(user.token);

      isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}