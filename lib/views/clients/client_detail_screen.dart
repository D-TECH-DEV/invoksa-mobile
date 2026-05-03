import 'package:flutter/material.dart';
import 'package:invoksa/view_models/client_viewmodel.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_radius.dart';
import '../../core/routes/app_routes.dart';
import '../../models/client.dart';
import '../shared/invoice_list_item.dart';
import 'widgets/client_detail_widgets.dart';

class ClientDetailScreen extends StatefulWidget {
  final Client client;
  const ClientDetailScreen({
    super.key,
    required this.client
  });

  @override
  State<ClientDetailScreen> createState() => _ClientDetailScreenState();
}

class _ClientDetailScreenState extends State<ClientDetailScreen> {
  final ClientViewModel _clientViewModel = ClientViewModel();
  late Client client = widget.client;

  @override
  void dispose() {
    _clientViewModel.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadData();
    _clientViewModel.addListener(() {
      if (mounted) setState(() {});
    });
  }

  void _loadData() {
    _clientViewModel.getClientInvoices(client.id!);
  }

  void _deleteClient() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le client ?'),
        content: Text('Voulez-vous vraiment supprimer ${client.name} ? Cette action est irréversible.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          TextButton(
            onPressed: () async {
              final success = await _clientViewModel.deleteClient(client.id!);
              if (success && mounted) {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context, true); // Go back to list
              }
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Calcul des statistiques pour le résumé
    double totalBilled = 0;
    double totalPaid = 0;
    for (var inv in _clientViewModel.invoices) {
      totalBilled += inv.total;
      if (inv.status.toLowerCase() == 'paid') {
        totalPaid += inv.total;
      }
    }
    double totalPending = totalBilled - totalPaid;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Color(0xFFF3F4F6),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.chevron_left, color: AppColors.textPrimary, size: 24),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: AppColors.textPrimary),
            onPressed: () async {
              final result = await Navigator.pushNamed(
                context, 
                AppRoutes.clientCreate, 
                arguments: client
              );
              if (result == true) {
                Navigator.pop(context, true); // Refresh list
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: _deleteClient,
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
             Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
              child: ClientHeaderDetail(
                name: client.name,
                role: client.phone,
                company: client.email,
                imageUrl: 'https://i.pravatar.cc/150?img=${client.id}',
                isPremium: false,
              ),
            ),
            
            // Résumé financier
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: ClientSummaryCards(
                totalBilled: totalBilled,
                totalPaid: totalPaid,
                totalPending: totalPending,
              ),
            ),
            
            const SizedBox(height: AppSpacing.lg),
            const Divider(height: 1, color: AppColors.border),
            
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchBar(),
                  const SizedBox(height: AppSpacing.lg),
                  const FilterTabGroup(),
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'HISTORIQUE DES FACTURES (${_clientViewModel.invoices.length})',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          letterSpacing: 0.5,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      TextButton.icon(
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        onPressed: () {},
                        icon: const Text(
                          'Trier par',
                          style: TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        label: const Icon(Icons.north_east, size: 14, color: AppColors.accent),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildInvoicesList(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.invoiceCreate);
        },
        backgroundColor: AppColors.accent,
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: AppRadius.medium,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppColors.textSecondary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher par n° de facture...',
                hintStyle: AppTextStyles.caption.copyWith(fontSize: 14),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoicesList() {
    final invoices = _clientViewModel.invoices;

    if (_clientViewModel.isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (invoices.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Text("Aucun historique trouvé"),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: invoices.length,
      itemBuilder: (context, index) {
        final invoice = invoices[index];
        final dateStr = invoice.createdAt != null 
            ? DateFormat('dd MMM yyyy').format(invoice.createdAt!)
            : 'Date inconnue';

        return InvoiceListItem(
          invoiceId: invoice.number ?? "FAC-${invoice.id}",
          clientName: client.name,
          date: dateStr,
          amount: '${invoice.total.toInt()} F',
          status: invoice.status,
          invoice: invoice,
        );
      },
    );
  }
}
