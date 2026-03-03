import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:invoksa/core/constants/api_constants.dart';
import '../core/services/token_service.dart';
import '../models/user.dart';

class AuthRepository {
  final TokenService _tokenService = TokenService();

  Future<Map<String, dynamic>> login(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse(ApiConstants.login),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "username": username,
        "email": email,
        "password": password,
      }),
    );

    final Map<String, dynamic> data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      _tokenService.saveToken(data['token']);
      return {
        "user": User.fromJson(data['user']),
        //"token": data['token'],
      };
    } else {
      throw Exception(data['error'] ?? "Email ou mot de passe incorrect !");
    }
  }

  Future<User> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse(ApiConstants.register),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "username": username,
        "email": email,
        "password": password,
        "role": "ROLE_USER"
      }),
    );

    final Map<String, dynamic> data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (data.containsKey('user')) {
         return User.fromJson(data['user']);
      }
      return User.fromJson(data);
    } else {
      throw Exception(data['message'] ?? "Erreur lors de l'inscription");
    }
  }
}