import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:invoksa/core/constants/api_constants.dart';
import 'package:invoksa/core/services/api_service.dart';
import '../models/user.dart';

class AuthRepository {
  final String baseUrl = "http://10.0.2.2:8080/api";

  Future<User> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(ApiConstants.login),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Email ou mot de passe incorrect");
    }
  }
}