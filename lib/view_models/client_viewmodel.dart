import 'package:flutter/material.dart';
import 'package:invoksa/models/client.dart';
import 'package:invoksa/models/invoice.dart';
import 'package:invoksa/repositories/client_repository.dart';

class ClientViewModel extends ChangeNotifier {
  final ClientRepository _clientRepository = ClientRepository();

  bool isLoading = false;
  String? errorMessage;

  /// Liste source brute, jamais modifiée par la recherche
  List<Client> _allClients = [];

  /// Liste affichée à l'écran (filtrée selon la recherche)
  List<Client> clients = [];
  List<Invoice> invoices = [];

  String searchQuery = '';

  /// Filtre [clients] en temps réel selon la saisie utilisateur.
  /// La recherche porte sur le nom, l'email et le téléphone.
  void searchClients(String query) {
    searchQuery = query.trim().toLowerCase();
    if (searchQuery.isEmpty) {
      clients = List.from(_allClients);
    } else {
      clients = _allClients.where((client) {
        return client.name.toLowerCase().contains(searchQuery) ||
            client.email.toLowerCase().contains(searchQuery) ||
            client.phone.toLowerCase().contains(searchQuery);
      }).toList();
    }
    notifyListeners();
  }

  /// Réinitialise la recherche et restore la liste complète.
  void clearSearch() {
    searchQuery = '';
    clients = List.from(_allClients);
    notifyListeners();
  }

  Future<bool> loadClients() async {
    try {
      isLoading = true;
      notifyListeners();

      final result = await _clientRepository.getMyClients();
      _allClients = result;
      clients = List.from(_allClients); // réinitialise aussi la liste affichée

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

      _allClients.insert(0, newClient); // maintient la source brute à jour
      clients.insert(0, newClient);     // 🔥 Mise à jour locale instantanée

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