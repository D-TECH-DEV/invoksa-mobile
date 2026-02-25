import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';

class ClientSelector extends StatelessWidget {
  final String name;
  final String email;
  final String imageUrl;

  const ClientSelector({
    Key? key,
    required this.name,
    required this.email,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Client', style: AppTextStyles.headingMedium),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.person_add_outlined, size: 18),
              label: const Text('Changer'),
              style: TextButton.styleFrom(foregroundColor: AppColors.accent),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: AppRadius.medium,
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(imageUrl),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: AppTextStyles.headingMedium.copyWith(fontSize: 16)),
                    Text(email, style: AppTextStyles.caption),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ],
          ),
        ),
      ],
    );
  }
}

class ArticleEntryCard extends StatelessWidget {
  final int index;
  final String description;
  final int quantity;
  final double unitPrice;

  const ArticleEntryCard({
    Key? key,
    required this.index,
    required this.description,
    required this.quantity,
    required this.unitPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Description', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () {},
              ),
            ],
          ),
          TextField(
            decoration: InputDecoration(
              hintText: 'Ex: Consultation UX',
              border: OutlineInputBorder(borderRadius: AppRadius.small),
              contentPadding: const EdgeInsets.all(12),
            ),
            controller: TextEditingController(text: description),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Quantité', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                    const SizedBox(height: 4),
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: AppRadius.small),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                      controller: TextEditingController(text: quantity.toString()),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Prix Unitaire (€)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                    const SizedBox(height: 4),
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: AppRadius.small),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                      controller: TextEditingController(text: unitPrice.toStringAsFixed(0)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Total: ${(quantity * unitPrice).toStringAsFixed(2)} €',
              style: AppTextStyles.headingMedium.copyWith(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class InvoiceSummaryCard extends StatelessWidget {
  final double subtotal;
  final double tax;
  final double total;

  const InvoiceSummaryCard({
    Key? key,
    required this.subtotal,
    required this.tax,
    required this.total,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: AppRadius.medium,
      ),
      child: Column(
        children: [
          _buildSummaryRow('Sous-total', '${subtotal.toStringAsFixed(2)} €'),
          const SizedBox(height: 8),
          _buildSummaryRow('TVA (20%)', '${tax.toStringAsFixed(2)} €'),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Général', style: AppTextStyles.headingMedium),
              Text('${total.toStringAsFixed(2)} €', style: AppTextStyles.headingLarge.copyWith(fontSize: 20)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class PaymentMethodSelector extends StatelessWidget {
  final String selectedMethod;

  const PaymentMethodSelector({Key? key, required this.selectedMethod}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.payment_outlined, size: 20, color: AppColors.textPrimary),
            SizedBox(width: 8),
            Text('Mode de Paiement', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            _buildChip('Virement', selectedMethod == 'Virement'),
            const SizedBox(width: 8),
            _buildChip('Espèces', selectedMethod == 'Espèces'),
            const SizedBox(width: 8),
            _buildChip('Carte', selectedMethod == 'Carte'),
          ],
        ),
      ],
    );
  }

  Widget _buildChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.accent.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isSelected ? AppColors.accent : AppColors.border),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppColors.accent : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
