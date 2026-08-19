import 'package:flutter/foundation.dart';
import '../models/client.dart';
import '../models/invoice.dart';
import '../repositories/invoice_repository.dart';
import '../repositories/client_repository.dart';

class DashboardViewModel extends ChangeNotifier {
  final InvoiceRepository _invoiceRepository = InvoiceRepository();
  final ClientRepository _clientRepository = ClientRepository();

  bool isLoading = false;
  String? errorMessage;

  int totalInvoices = 0;
  int paidInvoices = 0;
  int pendingInvoices = 0;
  double totalRevenue = 0;
  List<Client> recentClients = [];
  List<Invoice> recentInvoices = [];
  
  // Data for the chart: Month Index (1-12) -> Total Revenue
  Map<int, double> monthlyRevenue = {};

  Future<void> loadDashboardData() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      // Fetch all invoices
      final invoices = await _invoiceRepository.getInvoice();
      totalInvoices = invoices.length;
      
      // Calculate stats
      paidInvoices = invoices.where((inv) => inv.status.toUpperCase() == 'PAID').length;
      pendingInvoices = invoices.where((inv) => inv.status.toUpperCase() == 'PENDING').length;
      totalRevenue = invoices.fold(0, (sum, inv) => sum + inv.total);
      
      // Calculate monthly revenue for the current year
      monthlyRevenue = {};
      final now = DateTime.now();
      for (int i = 1; i <= 12; i++) {
        monthlyRevenue[i] = 0;
      }
      
      for (var inv in invoices) {
        if (inv.createdAt != null && inv.createdAt!.year == now.year) {
          int month = inv.createdAt!.month;
          monthlyRevenue[month] = (monthlyRevenue[month] ?? 0) + inv.total;
        }
      }

      // Tri par date de dernière modification (updatedAt) : le plus récemment
      // modifié en premier. Spécifique au dashboard — les autres écrans
      // (liste des factures/clients) gardent leur propre tri.
      final sortedInvoices = List<Invoice>.from(invoices)
        ..sort((a, b) => (b.updatedAt ?? b.createdAt ?? DateTime(0))
            .compareTo(a.updatedAt ?? a.createdAt ?? DateTime(0)));
      recentInvoices = sortedInvoices.take(5).toList();

      // Fetch clients
      final clients = await _clientRepository.getMyClients();

      final sortedClients = List<Client>.from(clients)
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      recentClients = sortedClients.take(5).toList();

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = _getFriendlyErrorMessage(e);
      notifyListeners();
    }
  }

  String _getFriendlyErrorMessage(dynamic e) {
    String error = e.toString().toLowerCase();
    if (error.contains('network') || error.contains('connection')) {
      return "Impossible de charger le tableau de bord. Vérifiez votre connexion.";
    }
    return "Une erreur est survenue lors du chargement des données.";
  }
}
