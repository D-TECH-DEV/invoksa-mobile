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
      
      // Sort invoices by date and take recent ones
      final sortedInvoices = List<Invoice>.from(invoices)
        ..sort((a, b) => (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)));
      recentInvoices = sortedInvoices.take(5).toList();

      // Fetch clients
      final clients = await _clientRepository.getMyClients();
      
      // For recent clients, we could sort by createdAt if available, 
      // or just take the latest ones added.
      // Assuming Client also has createdAt
      final sortedClients = List<Client>.from(clients)
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      recentClients = sortedClients.take(5).toList();

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
    }
  }
}
