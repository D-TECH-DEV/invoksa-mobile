import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_radius.dart';
import 'widgets/invoice_detail_widgets.dart';

class InvoiceDetailScreen extends StatelessWidget {
  const InvoiceDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: AppColors.textPrimary, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Facture #INV-2024-0012',
          style: AppTextStyles.headingMedium,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.textPrimary),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.file_download_outlined, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.border),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            const InvoiceStatusCard(
              status: 'En attente',
              totalAmount: '4 800,00 €',
              dueDate: 'Échéance le 26 Octobre 2024',
            ),
            const SizedBox(height: AppSpacing.xl),
            const ClientInfoSection(
              name: 'Jean Dupont',
              company: 'Dupont & Co Digital',
              email: 'j.dupont@example.com',
              phone: '+33 6 12 34 56 78',
              address: '42 Rue de la Paix, 75002 Paris',
              imageUrl: 'https://i.pravatar.cc/150?img=11',
            ),
            const SizedBox(height: AppSpacing.xl),
            InvoiceItemsTable(
              items: [
                InvoiceItemData(description: 'Design de Logo & Branding', quantity: 1, price: '1 200,00 €'),
                InvoiceItemData(description: 'Développement Landing Page', quantity: 1, price: '2 500,00 €'),
                InvoiceItemData(description: 'Maintenance Mensuelle (Oct)', quantity: 2, price: '300,00 €'),
              ],
              subtotal: '4 000,00 €',
              tax: '800,00 €',
              total: '4 800,00 €',
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: AppSpacing.sm),
                Text('Émise le : 12 Octobre 2024', style: AppTextStyles.caption),
              ],
            ),
            const SizedBox(height: 120), // Bottom buttons space
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: const RoundedRectangleBorder(borderRadius: AppRadius.medium),
                  elevation: 0,
                ),
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.check_circle_outline, color: Colors.white),
                    SizedBox(width: AppSpacing.md),
                    Text('Marquer comme payée', style: AppTextStyles.button),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppColors.primary),
                  shape: const RoundedRectangleBorder(borderRadius: AppRadius.medium),
                ),
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.share_outlined, color: AppColors.primary),
                    SizedBox(width: AppSpacing.md),
                    Text(
                      'Partager la facture',
                      style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
