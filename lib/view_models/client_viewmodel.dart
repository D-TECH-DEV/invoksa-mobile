import 'package:flutter/material.dart';
import 'package:invoksa/models/client.dart';
import 'package:invoksa/models/invoice.dart';
import 'package:invoksa/repositories/client_repository.dart';

class ClientViewModel extends ChangeNotifier {
  final ClientRepository _clientRepository = ClientRepository();

  bool isLoading = false;
  String? errorMessage;

  List<Client> clients = [];
  List<Invoice> invoices = [];

  Future<bool> loadClients() async {
    try {
      isLoading = true;
      notifyListeners();

      clients = await _clientRepository.getMyClients();

      isLoading = false;
      notifyListeners();
      return true;

    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> addClient(String name, String email, String phone) async {
    try {
      isLoading = true;
      notifyListeners();

      final newClient = await _clientRepository.createClient(
        name.trim(),
        email.trim(),
        phone.trim(),
      );

      clients.insert(0, newClient); // 🔥 Mise à jour locale instantanée

      isLoading = false;
      notifyListeners();
      return true;

    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> getClientInvoices(int idClient) async {
    try {
      isLoading= true;
      errorMessage = null;
      notifyListeners();

      invoices = await _clientRepository.loadClientInvoices(idClient);

      isLoading = false;
      errorMessage = null;
      notifyListeners();
      return true;
    } catch(e) {
      isLoading = false;
      errorMessage = e.toString().replaceAll("error", "");
    }
    return false;
  }
}