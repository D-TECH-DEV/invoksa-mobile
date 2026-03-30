import 'package:flutter/foundation.dart';
import 'package:invoksa/core/constants/api_constants.dart';
import 'package:invoksa/models/client.dart';
import 'package:invoksa/models/invoice.dart';
import 'package:invoksa/models/invoice_item.dart';
import 'package:invoksa/repositories/client_repository.dart';
import 'package:invoksa/repositories/invoice_repository.dart';
import 'package:invoksa/services/invoice_services.dart';
import 'package:share_plus/share_plus.dart';

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
  Invoice? invoiceAi;

  /// Texte saisi par l'utilisateur dans la barre de recherche
  String searchQuery = '';

  /// Filtre de statut actif ("all", "paid", "pending", "unpaid")
  String _activeStatusFilter = 'all';

  /// Option de tri active
  InvoiceSortOption _currentSortOption = InvoiceSortOption.newest;

  Future <bool> addInvoice(Map<String, dynamic> client, List<Map<String, dynamic>> invoiceItems) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final newInvoice = await _invoiceServices.createInvoice(client, invoiceItems, 500);
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

  Future<bool> loadInvoiceAi(String description) async {
    try {
      if(description=="") {
        return false;
      }

      isLoading= true;
      errorMessage = null;
      notifyListeners();

      invoiceAi = await _invoiceServices.sendInvoiceAi(description);

      isLoading= false;
      errorMessage = null;
      notifyListeners();
      return true;
    } catch(e) {
      isLoading = false;
      errorMessage = "Erreur IA: $e";
      debugPrint("AI Extraction Error: $e");
      notifyListeners();
      return false;
    }
  }

  Future<bool> changeStatusPaid(Invoice currentInvoice) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      // Ensure the invoice has an ID
      if (currentInvoice.id == null) {
        throw Exception("ID de facture manquant");
      }

      Invoice updatedInvoice =
        await _invoiceServices.markePaid(currentInvoice);
      final index = allInvoices.indexWhere((inv)
        => inv.id == currentInvoice.id);
      if (index != -1) {
        allInvoices[index] = updatedInvoice;
      }
      
      if (invoice?.id == currentInvoice.id) {
        invoice = updatedInvoice;
      }

      _applyFilters();

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
  void shareInvoice(String token) {
    String publicLink ="${ApiConstants.baseUrl}/i/$token";
    Share.share(
      "Bonjour ! Voici votre facture : $publicLink",
      subject: "Facture Invoksa",
    );
  }

  /// Filtre la liste par statut. Compatible avec la recherche textuelle.
  void filterInvoices(String filter) {
    _activeStatusFilter = filter.toLowerCase();
    _applyFilters();
  }

  /// Change l'option de tri
  void sortInvoices(InvoiceSortOption option) {
    _currentSortOption = option;
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

  /// Point unique de filtrage : combine statut + recherche textuelle + tri.
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
            (inv.client?.name ?? '').toLowerCase().contains(searchQuery);
        return matchNumber || matchClient;
      }).toList();
    }

    // Appliquer le tri
    switch (_currentSortOption) {
      case InvoiceSortOption.newest:
        result.sort((a, b) => (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)));
        break;
      case InvoiceSortOption.oldest:
        result.sort((a, b) => (a.createdAt ?? DateTime(0)).compareTo(b.createdAt ?? DateTime(0)));
        break;
      case InvoiceSortOption.amountHigh:
        result.sort((a, b) => b.total.compareTo(a.total));
        break;
      case InvoiceSortOption.amountLow:
        result.sort((a, b) => a.total.compareTo(b.total));
        break;
      case InvoiceSortOption.clientName:
        result.sort((a, b) => (a.client?.name ?? '').compareTo(b.client?.name ?? ''));
        break;
    }

    invoices = result;
    notifyListeners();
  }


}

enum InvoiceSortOption { newest, oldest, amountHigh, amountLow, clientName }

