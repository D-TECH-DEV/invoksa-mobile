import 'package:invoksa/core/constants/api_constants.dart';
import 'package:invoksa/core/services/api_service.dart';
import 'package:invoksa/models/client.dart';
import 'package:invoksa/models/invoice.dart';

class ClientRepository {

  final ApiService _apiService = ApiService();

  Future<List<Client>> getMyClients() async {
    final response = await _apiService.get(ApiConstants.myClients);

    if (response == null) {
      return [];
    }

    if (response is List) {
      return response.map((json) => Client.fromJson(json)).toList();
    } else if (response is Map) {
      return [Client.fromJson(response as Map<String, dynamic>)];
    } else {
      throw Exception("Format de réponse inattendu");
    }
  }

  Future<Client> createClient(String name, String email, String phone) async{
    final Client client = Client(name: name, email: email, phone: phone);
    final response = await _apiService.post(ApiConstants.clients, client.toJson());
    return Client.fromJson(response);
  }

  Future<List<Invoice>> loadClientInvoices(int idClient) async {
    final response = await _apiService.get(
        "${ApiConstants.invoicesClient}/$idClient"
    );

    if (response == null) {
      return [];
    }

    if (response is List) {
      return response.map((json) => Invoice.fromJson(json)).toList();
    } else if (response is Map) {
      return [Invoice.fromJson(response as Map<String, dynamic>)];
    } else {
      throw Exception("Format de réponse inattendu");
    }
  }
}