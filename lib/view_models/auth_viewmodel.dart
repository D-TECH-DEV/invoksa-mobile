import 'package:flutter/material.dart';
import '../repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();


  bool isLoading = false;
  String? errorMessage;

  Future<bool> login(String username, String email, String password) async {
    try {
      if (username=="" || email==""|| password=="") {
        errorMessage = "Veuillez remplir tous les champs";
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
      errorMessage = e.toString().replaceAll("Exception: ", "");
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String username, String email, String password) async {
    try {
      if (username=="" || email=="" || password=="") {
        errorMessage = "Veuillez remplir tous les champs";
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
      errorMessage = e.toString().replaceAll("Exception: ", "");
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}