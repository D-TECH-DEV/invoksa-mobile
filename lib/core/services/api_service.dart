import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import 'token_service.dart';

class ApiService {
  final TokenService _tokenService = TokenService();

  //  Headers dynamiques (toujours à jour)
  Future<Map<String, String>> _headers() async {
    final token = await _tokenService.getToken();

    final headers = {
      "Content-Type": ApiConstants.contentType,
    };

    if (token != null) {
      headers[ApiConstants.authorization] =
      "${ApiConstants.bearer} $token";
    }

    return headers;
  }

  // GET
  Future<dynamic> get(String endpoint) async {
    final response = await http
        .get(
      Uri.parse("${ApiConstants.baseUrl}$endpoint"),
      headers: await _headers(),
    )
        .timeout(ApiConstants.connectTimeout);

    return _handleResponse(response);
  }

  //  POST
  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final response = await http
        .post(
      Uri.parse("${ApiConstants.baseUrl}$endpoint"),
      headers: await _headers(),
      body: jsonEncode(data),
    )
        .timeout(ApiConstants.connectTimeout);

    return _handleResponse(response);
  }

  // PUT
  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    final response = await http
        .put(
      Uri.parse("${ApiConstants.baseUrl}$endpoint"),
      headers: await _headers(),
      body: jsonEncode(data),
    )
        .timeout(ApiConstants.connectTimeout);

    return _handleResponse(response);
  }

  //  DELETE
  Future<dynamic> delete(String endpoint) async {
    final response = await http
        .delete(
      Uri.parse("${ApiConstants.baseUrl}$endpoint"),
      headers: await _headers(),
    )
        .timeout(ApiConstants.connectTimeout);

    return _handleResponse(response);
  }

  //  Gestion des réponses
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response.body.isEmpty ? {} : jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception("Session expirée. Veuillez vous reconnecter.");
    } else {
      String errorMessage;
      try {
        final body = jsonDecode(response.body);
        errorMessage = body["message"] ?? "Erreur API: ${response.statusCode}";
      } catch (_) {
        // Not a JSON response
        errorMessage = "Erreur Serveur (${response.statusCode}): ${response.body.split('\n').first}";
      }
      throw Exception(errorMessage);
    }
  }
}