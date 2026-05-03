import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:invoksa/core/constants/api_constants.dart';
import 'package:invoksa/core/services/api_service.dart';
import '../core/services/token_service.dart';
import '../models/user.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();
  final TokenService _tokenService = TokenService();

  Future<Map<String, dynamic>> login(String username, String email, String password) async {
    final response = await _apiService.post(ApiConstants.login, {
      "username": username,
      "email": email,
      "password": password,
    });

    if (response.containsKey('token')) {
      await _tokenService.saveToken(response['token']);
      return {
        "user": User.fromJson(response['user']),
      };
    } else {
      throw Exception("Réponse invalide du serveur");
    }
  }

  Future<User> register(String username, String email, String password) async {
    final response = await _apiService.post(ApiConstants.register, {
      "username": username,
      "email": email,
      "password": password,
      "role": "ROLE_USER"
    });

    if (response.containsKey('user')) {
       return User.fromJson(response['user']);
    }
    return User.fromJson(response);
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    await _apiService.post("/auth/change-password", {
      "oldPassword": oldPassword,
      "newPassword": newPassword,
    });
  }

  Future<void> deleteAccount() async {
    await _apiService.delete("/auth/me");
  }
}
