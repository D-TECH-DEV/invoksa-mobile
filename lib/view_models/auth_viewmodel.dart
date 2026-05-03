import 'package:flutter/material.dart';
import '../repositories/auth_repository.dart';
import '../core/utils/validators.dart';
import '../core/utils/error_handler.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  bool isLoading = false;
  String? errorMessage;

  Future<bool> login(String username, String email, String password) async {
    try {
      final emailError = AppValidators.validateEmail(email);
      final passwordError = AppValidators.validatePassword(password);
      final usernameError = AppValidators.validateRequired(username, "Nom d'utilisateur");

      if (emailError != null || passwordError != null || usernameError != null) {
        errorMessage = emailError ?? passwordError ?? usernameError;
        notifyListeners();
        return false;
      }

      isLoading = true;
      errorMessage = null;
      notifyListeners();

      await _authRepository.login(
        username,
        email,
        password,
      );

      isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      errorMessage = ErrorHandler.getFriendlyMessage(e);
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String username, String email, String password) async {
    try {
      final emailError = AppValidators.validateEmail(email);
      final passwordError = AppValidators.validatePassword(password);
      final usernameError = AppValidators.validateRequired(username, "Nom d'utilisateur");

      if (emailError != null || passwordError != null || usernameError != null) {
        errorMessage = emailError ?? passwordError ?? usernameError;
        notifyListeners();
        return false;
      }

      isLoading = true;
      errorMessage = null;
      notifyListeners();

      await _authRepository.register(
        username,
        email,
        password,
      );

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = ErrorHandler.getFriendlyMessage(e);
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}