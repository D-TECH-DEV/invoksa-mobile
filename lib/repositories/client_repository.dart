import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:invoksa/core/constants/api_constants.dart';
import 'package:invoksa/core/services/api_service.dart';
import 'package:invoksa/models/client.dart';
import 'package:invoksa/models/invoice.dart';

class ClientRepository {
  final ApiService _apiService = ApiService();
  final String _cacheKey = 'clients';

  Future<List<Client>> getMyClients({bool useCache = true}) async {
    final box = await Hive.openBox('offlineCache');
    
    try {
      final response = await _apiService.get(ApiConstants.myClients, useCache: false);
      
      List<Client> clients = [];
      if (response is List) {
        clients = response.map((json) => Client.fromJson(json)).toList();
      } else if (response is Map) {
        clients = [Client.fromJson(response as Map<String, dynamic>)];
      }

      // Update cache
      if (clients.isNotEmpty) {
        final jsonList = clients.map((e) => e.toJson()).toList();
        await box.put(_cacheKey, jsonEncode(jsonList));
      }
      
      return clients;
    } catch (e) {
      if (useCache) {
        final cached = box.get(_cacheKey);
        if (cached != null) {
          final List<dynamic> decoded = jsonDecode(cached);
          return decoded.map((e) => Client.fromJson(e)).toList();
        }
      }
      rethrow;
    }
  }

  Future<Client> createClient(String name, String email, String phone) async{
    final Client client = Client(name: name, email: email, phone: phone);
    final response = await _apiService.post(ApiConstants.clients, client.toJson());
    return Client.fromJson(response);
  }

  Future<Client> updateClient(int id, String name, String email, String phone) async {
    final response = await _apiService.put("${ApiConstants.clients}/$id", {
      "name": name,
      "email": email,
      "phone": phone,
    });
    return Client.fromJson(response);
  }

  Future<void> deleteClient(int id) async {
    await _apiService.delete("${ApiConstants.clients}/$id");
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