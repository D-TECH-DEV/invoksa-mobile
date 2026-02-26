import 'package:flutter/material.dart';
import 'package:invoksa/core/services/api_service.dart';
import 'package:invoksa/models/client.dart';
import 'package:invoksa/repositories/client_repository.dart';

class ClientViewModel extends ChangeNotifier {
  final ClientRepository _clientRepository = ClientRepository();

  bool isLoading = false;
  String? errorMessage;

  List<Client> clients = [];

  Future<bool> getMyClient() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      clients = await _clientRepository.getMyClients();

      isLoading = false;
      errorMessage = null;
      notifyListeners();

      return true;

    } catch(e) {
      errorMessage = e.toString().replaceAll("Error", "");
      isLoading = false;
      notifyListeners();
    }
    return false;

  }

  @override
  void dispose () {
    clients.clear();
    super.dispose();
  }
}
