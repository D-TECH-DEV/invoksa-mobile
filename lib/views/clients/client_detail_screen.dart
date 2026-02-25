import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_radius.dart';
import 'widgets/client_detail_widgets.dart';

class ClientDetailScreen extends StatelessWidget {
  const ClientDetailScreen({Key? key}) : super(key: key);

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
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
              child: ClientHeaderDetail(
                name: 'Jean-Pierre Durand',
                role: 'Directeur Marketing',
                company: 'TechSolutions SA',
                imageUrl: 'https://i.pravatar.cc/150?img=11',
                isPremium: true,
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
                  const ClientInvoiceItem(
                    invoiceId: 'Facture 2024-042',
                    date: '12 Mars 2024',
                    amount: '1 450,00 €',
                    status: 'Payé',
                    isPaid: true,
                  ),
                  const ClientInvoiceItem(
                    invoiceId: 'Facture 2024-045',
                    date: '25 Mars 2024',
                    amount: '890,50 €',
                    status: 'En attente',
                  ),
                  const ClientInvoiceItem(
                    invoiceId: 'Facture 2024-048',
                    date: '02 Avril 2024',
                    amount: '2 100,00 €',
                    status: 'Payé',
                    isPaid: true,
                  ),
                  const ClientInvoiceItem(
                    invoiceId: 'Facture 2024-051',
                    date: '15 Avril 2024',
                    amount: '320,00 €',
                    status: 'En attente',
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
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
}
