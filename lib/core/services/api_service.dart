import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';

class ApiService {
  ApiService._();

  static final ApiService instance = ApiService._();

  String? _token;

  // 🔐 Set Token
  void setToken(String token) {
    _token = token;
  }

  // 🔑 Headers dynamiques
  Map<String, String> get _headers {
    final headers = {
      "Content-Type": ApiConstants.contentType,
    };

    if (_token != null) {
      headers[ApiConstants.authorization] =
      "${ApiConstants.bearer} $_token";
    }

    return headers;
  }

  // 📥 GET
  Future<dynamic> get(String endpoint) async {
    final response = await http
        .get(
      Uri.parse("${ApiConstants.baseUrl}$endpoint"),
      headers: _headers,
    )
        .timeout(ApiConstants.connectTimeout);

    return _handleResponse(response);
  }

  // 📤 POST
  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final response = await http
        .post(
      Uri.parse("${ApiConstants.baseUrl}$endpoint"),
      headers: _headers,
      body: jsonEncode(data),
    )
        .timeout(ApiConstants.connectTimeout);

    return _handleResponse(response);
  }

  // ✏ PUT
  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    final response = await http
        .put(
      Uri.parse("${ApiConstants.baseUrl}$endpoint"),
      headers: _headers,
      body: jsonEncode(data),
    )
        .timeout(ApiConstants.connectTimeout);

    return _handleResponse(response);
  }

  // ❌ DELETE
  Future<dynamic> delete(String endpoint) async {
    final response = await http
        .delete(
      Uri.parse("${ApiConstants.baseUrl}$endpoint"),
      headers: _headers,
    )
        .timeout(ApiConstants.connectTimeout);

    return _handleResponse(response);
  }

  // 🔎 Gestion des réponses
  dynamic _handleResponse(http.Response response) {
    final body = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    } else {
      throw Exception(body["message"] ?? "Erreur API");
    }
  }
}