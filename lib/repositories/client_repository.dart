import 'package:invoksa/core/services/api_service.dart';
import 'package:invoksa/models/client.dart';

class ClientRepository {

  final ApiService _apiService = ApiService();

  Future<List<Client>> getMyClients() async {
    final response = await _apiService.get("/clients/me");

    if (response == null) {
      return [];
    }

    if (response is List) {
      return response.map((json) => Client.fromJson(json)).toList();
    } else if (response is Map) {
      // Si l'API renvoie un seul objet au lieu d'une liste
      return [Client.fromJson(response as Map<String, dynamic>)];
    } else {
      throw Exception("Format de réponse inattendu");
    }
  }
}