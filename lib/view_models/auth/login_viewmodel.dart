import 'package:flutter/material.dart';
import '../../repositories/auth_repository.dart';
import '../../core/services/token_service.dart';
import '../../models/user.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  final TokenService _tokenService = TokenService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  String? errorMessage;

  Future<bool> login() async {
    try {
      if (nameController.text.isEmpty || emailController.text.isEmpty || passwordController.text.isEmpty) {
        errorMessage = "Veuillez remplir tous les champs";
        notifyListeners();
        return false;
      }

      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final result = await _authRepository.login(
        nameController.text.trim(),
        emailController.text.trim(),
        passwordController.text,
      );

      isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      errorMessage = e.toString().replaceAll("Exception: ", "");
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}