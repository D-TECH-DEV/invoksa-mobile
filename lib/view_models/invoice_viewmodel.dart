import 'package:flutter/foundation.dart';
import 'package:invoksa/models/client.dart';
import 'package:invoksa/models/invoice.dart';
import 'package:invoksa/models/invoice_item.dart';
import 'package:invoksa/repositories/client_repository.dart';
import 'package:invoksa/repositories/invoice_repository.dart';
import 'package:invoksa/services/invoice_services.dart';

class InvoiceViewmodel extends ChangeNotifier {
  final InvoiceRepository _invoiceRepository = InvoiceRepository();
  final InvoiceServices _invoiceServices = InvoiceServices();
  final ClientRepository _clientRepository = ClientRepository();
  bool isLoading = false;
  String? errorMessage;

  List<Invoice> allInvoices = [];
  List<Invoice> invoices = [];
  List<Client> clients = [];
  List<InvoiceItem> invoiceItemsAdd = [];
  Invoice? invoice;

  /// Texte saisi par l'utilisateur dans la barre de recherche
  String searchQuery = '';

  /// Filtre de statut actif ("all", "paid", "pending", "unpaid")
  String _activeStatusFilter = 'all';

  Future <bool> addInvoice(Map<String, dynamic> client, List<Map<String, dynamic>> invoiceItems) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final newInvoice = await _invoiceServices.createInvoice(client, invoiceItems);
      //invoices.insert(0, newInvoice);
      await loadClients();

      isLoading = false;
      errorMessage = null;
      notifyListeners();
      return true;

    } catch (e) {
      errorMessage = e.toString().replaceAll("", "");
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> getInvoices() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      allInvoices = await _invoiceRepository.getInvoice();
      invoices = List.from(allInvoices);

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

  Future<bool> getInvoiceById(int id)  async{
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      invoice = await _invoiceRepository.getById(id);

      isLoading = false;
      errorMessage = null;
      notifyListeners();
      return true;
    } catch(e) {
      isLoading = false;
      errorMessage = e.toString().replaceAll("Error", "");
      notifyListeners();
      return false;
    }

  }

  /// Filtre la liste par statut. Compatible avec la recherche textuelle.
  void filterInvoices(String filter) {
    _activeStatusFilter = filter.toLowerCase();
    _applyFilters();
  }

  /// Filtre la liste en temps réel selon la saisie utilisateur.
  /// Recherche dans le numéro de facture et le nom du client.
  void searchInvoices(String query) {
    searchQuery = query.trim().toLowerCase();
    _applyFilters();
  }

  /// Réinitialise la recherche textuelle et restaure la liste filtrée par statut.
  void clearSearch() {
    searchQuery = '';
    _applyFilters();
  }

  /// Point unique de filtrage : combine statut + recherche textuelle.
  void _applyFilters() {
    List<Invoice> result = allInvoices;

    // Filtre par statut
    if (_activeStatusFilter != 'all') {
      result = result
          .where((inv) => inv.status.toLowerCase() == _activeStatusFilter)
          .toList();
    }

    // Filtre par texte (numéro de facture ou nom du client)
    if (searchQuery.isNotEmpty) {
      result = result.where((inv) {
        final matchNumber =
            (inv.number ?? '').toLowerCase().contains(searchQuery);
        final matchClient =
            inv.client.name.toLowerCase().contains(searchQuery);
        return matchNumber || matchClient;
      }).toList();
    }

    invoices = result;
    notifyListeners();
  }
}

