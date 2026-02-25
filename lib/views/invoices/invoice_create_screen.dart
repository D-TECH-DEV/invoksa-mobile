import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_radius.dart';
import 'widgets/invoice_form_widgets.dart';

class InvoiceCreateScreen extends StatelessWidget {
  const InvoiceCreateScreen({Key? key}) : super(key: key);

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
        title: const Text('Nouvelle Facture', style: AppTextStyles.headingMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_outlined, color: AppColors.textPrimary),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ClientSelector(
              name: 'Jean Dupont',
              email: 'jean.dupont@email.com',
              imageUrl: 'https://i.pravatar.cc/150?img=11',
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.category_outlined, size: 20),
                    SizedBox(width: 8),
                    Text('Articles', style: AppTextStyles.headingMedium),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('2 Articles', style: TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            const ArticleEntryCard(
              index: 0,
              description: 'Consultation Design UX',
              quantity: 1,
              unitPrice: 850,
            ),
            const ArticleEntryCard(
              index: 1,
              description: 'Développement Frontend (Heures)',
              quantity: 10,
              unitPrice: 75,
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildAddArticleButton(),
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: const [
                Icon(Icons.summarize_outlined, size: 20),
                SizedBox(width: 8),
                Text('Résumé', style: AppTextStyles.headingMedium),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            const InvoiceSummaryCard(
              subtotal: 1600,
              tax: 320,
              total: 1920,
            ),
            const SizedBox(height: AppSpacing.xl),
            const PaymentMethodSelector(selectedMethod: 'Virement'),
            const SizedBox(height: AppSpacing.xl),
            _buildSaveButton(),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildAddArticleButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.border, style: BorderStyle.none),
      ),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: const BorderSide(color: AppColors.border, style: BorderStyle.solid),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.medium),
        ),
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
             Icon(Icons.add, color: AppColors.textSecondary, size: 20),
             SizedBox(width: 8),
             Text('Ajouter un article', style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.medium),
          elevation: 0,
        ),
        onPressed: () {},
        child: const Text('Enregistrer la facture', style: AppTextStyles.button),
      ),
    );
  }
}
