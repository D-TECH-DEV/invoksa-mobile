import 'package:flutter/material.dart';
import '../repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  bool isLoading = false;
  String? errorMessage;

  Future<bool> login(String username, String email, String password) async {
    try {
      if (username == "" || email == "" || password == "") {
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
      errorMessage = _getFriendlyErrorMessage(e);
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String username, String email, String password) async {
    try {
      if (username == "" || email == "" || password == "") {
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
      errorMessage = _getFriendlyErrorMessage(e);
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  String _getFriendlyErrorMessage(dynamic e) {
    String error = e.toString().toLowerCase();
    if (error.contains('network') || error.contains('connection')) {
      return "Problème de connexion. Veuillez vérifier votre internet.";
    } else if (error.contains('401') || error.contains('unauthorized')) {
      return "Identifiants incorrects. Veuillez réessayer.";
    } else if (error.contains('404')) {
      return "Serveur introuvable. Veuillez réessayer plus tard.";
    }
    return "Une erreur est survenue. Veuillez réessayer.";
  }
}