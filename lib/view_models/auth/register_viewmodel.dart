import 'package:flutter/material.dart';
import '../../repositories/auth_repository.dart';
import '../../models/user.dart';

class RegisterViewModel extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  String? errorMessage;

  Future<bool> register() async {
    try {
      if (nameController.text.isEmpty || emailController.text.isEmpty || passwordController.text.isEmpty) {
        errorMessage = "Veuillez remplir tous les champs";
        notifyListeners();
        return false;
      }

      isLoading = true;
      errorMessage = null;
      notifyListeners();

      await _authRepository.register(
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
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
