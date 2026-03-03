import 'package:flutter/material.dart';
import 'package:invoksa/view_models/client_viewmodel.dart';
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
  late final Client client = widget.client;
  @override
  void dispose() {
    super.dispose();
    _clientViewModel.dispose();
  }

  @override
  void initState() {
    _clientViewModel.getClientInvoices(client.id!);
    _clientViewModel.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.chevron_left, color: AppColors.textPrimary, size: 24),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined, color: AppColors.textPrimary),
            onPressed: () {},
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
             Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
              child: ClientHeaderDetail(
                name: widget.client.name,
                role: 'Directeur Marketing',
                company: 'TechSolutions SA',
                imageUrl: 'https://i.pravatar.cc/150?img=11',
                isPremium: false,
              ),
            ),
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
                      const Text(
                        'LISTE DES FACTURES (4)',
                        style: TextStyle(
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

    if (invoices.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Text("Aucune facture pour ce client"),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: invoices.length,
      itemBuilder: (context, index) {
        final invoice = invoices[index];

        return InvoiceListItem(
          invoiceId: invoice.number! ,
          date: '12 Oct 2023',
          amount: '${invoice.total} F',
          status: invoice.status,
          invoice: invoice,
        );
      },
    );
  }
}
