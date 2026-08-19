import 'package:flutter/foundation.dart';
import '../models/client.dart';
import '../models/invoice.dart';
import '../repositories/invoice_repository.dart';
import '../repositories/client_repository.dart';

enum DashboardPeriod { week, month, year }

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

  // Toutes les factures chargées, utilisées pour recalculer le graphe
  // à chaque changement de période sans refaire d'appel réseau.
  List<Invoice> _invoices = [];

  DashboardPeriod selectedPeriod = DashboardPeriod.year;

  // Données du graphe pour la période sélectionnée :
  // - Année  : mois (1-12)     -> revenu du mois
  // - Mois   : jour du mois    -> revenu du jour
  // - Semaine: jour de semaine (1=lundi..7=dimanche) -> revenu du jour
  Map<int, double> chartData = {};

  // Total des revenus sur la période sélectionnée (affiché en haut du dashboard).
  double periodRevenue = 0;

  Future<void> loadDashboardData() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      // Fetch all invoices
      final invoices = await _invoiceRepository.getInvoice();
      _invoices = invoices;
      totalInvoices = invoices.length;

      // Calculate stats
      paidInvoices = invoices.where((inv) => inv.status.toUpperCase() == 'PAID').length;
      pendingInvoices = invoices.where((inv) => inv.status.toUpperCase() == 'PENDING').length;
      totalRevenue = invoices.fold(0, (sum, inv) => sum + inv.total);

      _computeChartData();

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

  /// Change la période affichée (semaine / mois / année) et recalcule
  /// aussitôt le graphe à partir des factures déjà chargées.
  void setPeriod(DashboardPeriod period) {
    if (selectedPeriod == period) return;
    selectedPeriod = period;
    _computeChartData();
    notifyListeners();
  }

  void _computeChartData() {
    switch (selectedPeriod) {
      case DashboardPeriod.year:
        chartData = _revenueByMonthOfYear();
        break;
      case DashboardPeriod.month:
        chartData = _revenueByDayOfMonth();
        break;
      case DashboardPeriod.week:
        chartData = _revenueByDayOfWeek();
        break;
    }
    periodRevenue = chartData.values.fold(0, (sum, v) => sum + v);
  }

  // Revenu de l'année en cours, réparti par mois (1-12).
  Map<int, double> _revenueByMonthOfYear() {
    final now = DateTime.now();
    final Map<int, double> data = {for (var i = 1; i <= 12; i++) i: 0};
    for (var inv in _invoices) {
      final d = inv.createdAt;
      if (d != null && d.year == now.year) {
        data[d.month] = (data[d.month] ?? 0) + inv.total;
      }
    }
    return data;
  }

  // Revenu du mois en cours, réparti par jour.
  Map<int, double> _revenueByDayOfMonth() {
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final Map<int, double> data = {for (var i = 1; i <= daysInMonth; i++) i: 0};
    for (var inv in _invoices) {
      final d = inv.createdAt;
      if (d != null && d.year == now.year && d.month == now.month) {
        data[d.day] = (data[d.day] ?? 0) + inv.total;
      }
    }
    return data;
  }

  // Revenu de la semaine en cours (lundi -> dimanche), réparti par jour.
  Map<int, double> _revenueByDayOfWeek() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    final Map<int, double> data = {for (var i = 1; i <= 7; i++) i: 0};
    for (var inv in _invoices) {
      final d = inv.createdAt;
      if (d == null) continue;
      final dayOnly = DateTime(d.year, d.month, d.day);
      final diff = dayOnly.difference(startOfWeek).inDays;
      if (diff >= 0 && diff < 7) {
        data[diff + 1] = (data[diff + 1] ?? 0) + inv.total;
      }
    }
    return data;
  }

  String _getFriendlyErrorMessage(dynamic e) {
    String error = e.toString().toLowerCase();
    if (error.contains('network') || error.contains('connection')) {
      return "Impossible de charger le tableau de bord. Vérifiez votre connexion.";
    }
    return "Une erreur est survenue lors du chargement des données.";
  }
}
