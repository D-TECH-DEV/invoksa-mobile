import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import 'token_service.dart';
import 'cache_service.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final TokenService _tokenService = TokenService();
  final CacheService _cacheService = CacheService();

  // Cache en mémoire (très rapide)
  static final Map<String, dynamic> _memoryCache = {};

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
  Future<dynamic> get(String endpoint, {bool useCache = false}) async {
    if (useCache) {
      // 1. Check memory cache
      if (_memoryCache.containsKey(endpoint)) {
        return _memoryCache[endpoint];
      }
      // 2. Check persistent cache
      final cached = await _cacheService.getCache(endpoint);
      if (cached != null) {
        _memoryCache[endpoint] = cached;
        return cached;
      }
    }

    final response = await http
        .get(
      Uri.parse("${ApiConstants.baseUrl}$endpoint"),
      headers: await _headers(),
    )
        .timeout(ApiConstants.connectTimeout);

    final data = _handleResponse(response);

    if (useCache) {
      _memoryCache[endpoint] = data;
      await _cacheService.setCache(endpoint, data);
    }

    return data;
  }

  // Clear Cache
  Future<void> clearCache() async {
    _memoryCache.clear();
    await _cacheService.clearAllCache();
  }

  // GET BYTES
  Future<Uint8List> getBytes(String endpoint) async {
    final response = await http
        .get(
      Uri.parse("${ApiConstants.baseUrl}$endpoint"),
      headers: await _headers(),
    )
        .timeout(ApiConstants.connectTimeout);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response.bodyBytes;
    } else if (response.statusCode == 401) {
      throw Exception("Session expirée. Veuillez vous reconnecter.");
    } else {
      throw Exception("Erreur de téléchargement: ${response.statusCode}");
    }
  }

  //  POST
  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final response = await http
        .post(
      Uri.parse("${ApiConstants.baseUrl.startsWith('http') ? '' : ApiConstants.baseUrl}$endpoint".startsWith('http') ? endpoint : "${ApiConstants.baseUrl}$endpoint"),
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
