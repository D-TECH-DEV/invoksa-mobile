import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;
import 'package:invoksa/core/constants/api_constants.dart';
import 'package:invoksa/models/client.dart';
import 'package:invoksa/models/invoice.dart';
import 'package:invoksa/models/invoice_item.dart';
import 'package:invoksa/repositories/client_repository.dart';
import 'package:invoksa/repositories/invoice_repository.dart';
import 'package:invoksa/services/invoice_services.dart';
import 'package:invoksa/core/services/storage_service.dart';
import 'package:invoksa/core/services/notification_service.dart';
import 'package:invoksa/core/utils/error_handler.dart';
import 'package:share_plus/share_plus.dart';

class InvoiceViewmodel extends ChangeNotifier {
  final InvoiceRepository _invoiceRepository = InvoiceRepository();
  final InvoiceServices _invoiceServices = InvoiceServices();
  final ClientRepository _clientRepository = ClientRepository();
  final StorageService _companyStorageService = StorageService();
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

  Future <bool> addInvoice(Map<String, dynamic> client, List<Map<String, dynamic>> invoiceItems, {int statusCode = 500}) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final newInvoice = await _invoiceServices.createInvoice(client, invoiceItems, statusCode);
      allInvoices.insert(0, newInvoice);
      _applyFilters();
      
      try {
        await loadClients();
      } catch (e) {
        if (kDebugMode) print("Error loading clients after invoice creation: $e");
      }
      
      errorMessage = null; // Clear any error set by loadClients

      if (statusCode == 500) { // PENDING
        try {
          // Schedule reminder for 30 days after creation
          final dueDate = newInvoice.createdAt?.add(const Duration(days: 30)) ?? DateTime.now().add(const Duration(days: 30));
          await NotificationService().scheduleInvoiceReminder(newInvoice.id!, newInvoice.number ?? "Facture", dueDate);
        } catch (e) {
          if (kDebugMode) print("Error scheduling notification: $e");
          // Non-critical error, don't throw
        }
      }

      isLoading = false;
      errorMessage = null;
      notifyListeners();
      return true;

    } catch (e) {
      errorMessage = ErrorHandler.getFriendlyMessage(e);
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateInvoice(int id, Map<String, dynamic> client, List<Map<String, dynamic>> invoiceItems, {int statusCode = 500}) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final updatedInvoice = await _invoiceServices.updateInvoice(id, client, invoiceItems, statusCode);
      
      final index = allInvoices.indexWhere((inv) => inv.id == id);
      if (index != -1) {
        allInvoices[index] = updatedInvoice;
      }
      
      if (invoice?.id == id) {
        invoice = updatedInvoice;
      }

      _applyFilters();

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = ErrorHandler.getFriendlyMessage(e);
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

      final box = Hive.box('offlineCache');

      try {
        allInvoices = await _invoiceRepository.getInvoice();
        // save to Hive
        final jsonList = allInvoices.map((e) => e.toJson()).toList();
        await box.put('invoices', jsonEncode(jsonList));
      } catch (e) {
        // Fallback to cache
        final cached = box.get('invoices');
        if (cached != null) {
          final List<dynamic> decoded = jsonDecode(cached);
          allInvoices = decoded.map((e) => Invoice.fromJson(e)).toList();
        } else {
          rethrow; // throw if no network and no cache
        }
      }

      invoices = List.from(allInvoices);

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      errorMessage = ErrorHandler.getFriendlyMessage(e);
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
      errorMessage = ErrorHandler.getFriendlyMessage(e);
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
      errorMessage = ErrorHandler.getFriendlyMessage(e);
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
      errorMessage = "Erreur IA: ${ErrorHandler.getFriendlyMessage(e)}";
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

      // Cancel reminder if it's paid
      await NotificationService().flutterLocalNotificationsPlugin.cancel(id: currentInvoice.id!);

      _applyFilters();

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = ErrorHandler.getFriendlyMessage(e);
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> markAsPending(Invoice currentInvoice) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      if (currentInvoice.id == null) {
        throw Exception("ID de facture manquant");
      }

      currentInvoice.statusCode = 500; // PENDING
      Invoice updatedInvoice = await _invoiceServices.updateInvoice(
        currentInvoice.id!,
        currentInvoice.client!.toJson(),
        (currentInvoice.items ?? []).map((e) => e.toJson()).toList(),
        500,
      );

      final index = allInvoices.indexWhere((inv) => inv.id == currentInvoice.id);
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
      errorMessage = ErrorHandler.getFriendlyMessage(e);
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteInvoice(int id) async {
    try {
      isLoading = true;
      notifyListeners();

      await _invoiceRepository.delete(id);
      allInvoices.removeWhere((inv) => inv.id == id);
      _applyFilters();

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

  Future<void> downloadInvoicePdf(Invoice invoice) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      if (invoice.id == null) {
        throw Exception("ID de facture invalide");
      }

      // Add Company Info for PDF configuration
      final info = await _companyStorageService.getCompanyInfo();

      final bytes = await _invoiceServices.getInvoicePdf(
        invoice.id!,
        color: info['color'], 
        name: info['name'], 
        tel: info['phone'], 
        email: info['email'], 
        address: info['address'], 
        legalMentions: info['legal']
      );
      final filename = "Facture_${invoice.number ?? invoice.id}.pdf";

      if (kIsWeb) {
        // Logique Web pour forcer le téléchargement du PDF
        final blob = html.Blob([bytes], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download", filename);
        html.document.body?.append(anchor);
        anchor.click();
        anchor.remove();
        html.Url.revokeObjectUrl(url);
      } else {
        // Logique Mobile/Desktop : sauvegarde temporaire et partage
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/$filename');
        await file.writeAsBytes(bytes);
        
        await Share.shareXFiles(
          [XFile(file.path)],
          subject: 'Votre facture $filename',
        );
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = ErrorHandler.getFriendlyMessage(e);
      notifyListeners();
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

