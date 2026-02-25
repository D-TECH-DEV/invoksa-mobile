import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';

class InvoiceStatusCard extends StatelessWidget {
  final String status;
  final String totalAmount;
  final String dueDate;

  const InvoiceStatusCard({
    Key? key,
    required this.status,
    required this.totalAmount,
    required this.dueDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(
            status.toUpperCase(),
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            totalAmount,
            style: AppTextStyles.headingLarge.copyWith(fontSize: 32),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            dueDate,
            style: AppTextStyles.caption.copyWith(fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class ClientInfoSection extends StatelessWidget {
  final String name;
  final String company;
  final String email;
  final String phone;
  final String address;
  final String imageUrl;

  const ClientInfoSection({
    Key? key,
    required this.name,
    required this.company,
    required this.email,
    required this.phone,
    required this.address,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Informations Client',
          style: AppTextStyles.headingMedium,
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: AppRadius.medium,
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              Row(
                children: [
                   CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(imageUrl),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: AppTextStyles.headingMedium.copyWith(fontSize: 16)),
                      Text(company, style: AppTextStyles.caption),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              _buildInfoRow(Icons.mail_outline, email),
              const SizedBox(height: AppSpacing.sm),
              _buildInfoRow(Icons.phone_outlined, phone),
              const SizedBox(height: AppSpacing.sm),
              _buildInfoRow(Icons.location_on_outlined, address),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.body.copyWith(fontSize: 14, color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}

class InvoiceItemsTable extends StatelessWidget {
  final List<InvoiceItemData> items;
  final String subtotal;
  final String tax;
  final String total;

  const InvoiceItemsTable({
    Key? key,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.total,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             const Text('Articles', style: AppTextStyles.headingMedium),
             const Icon(Icons.receipt_long_outlined, color: AppColors.textSecondary),
           ],
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: AppRadius.medium,
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              _buildTableHeader(),
              const Divider(height: 24),
              ...items.map((item) => _buildItemRow(item)).toList(),
              const SizedBox(height: AppSpacing.lg),
              _buildSummaryRow('Sous-total', subtotal),
              const SizedBox(height: AppSpacing.sm),
              _buildSummaryRow('TVA (20%)', tax),
              const Divider(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total à régler', style: AppTextStyles.headingMedium),
                  Text(total, style: AppTextStyles.headingLarge.copyWith(fontSize: 20)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTableHeader() {
    return Row(
      children: [
        const Expanded(flex: 3, child: Text('Description', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
        const Expanded(child: Center(child: Text('Qté', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)))),
        const Expanded(child: Align(alignment: Alignment.centerRight, child: Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)))),
      ],
    );
  }

  Widget _buildItemRow(InvoiceItemData item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(item.description, style: AppTextStyles.body.copyWith(fontSize: 13)),
          ),
          Expanded(
            child: Center(child: Text(item.quantity.toString(), style: AppTextStyles.body.copyWith(fontSize: 13))),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(item.price, style: AppTextStyles.headingMedium.copyWith(fontSize: 13)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.caption.copyWith(fontSize: 14)),
        Text(value, style: AppTextStyles.body.copyWith(fontSize: 14)),
      ],
    );
  }
}

class InvoiceItemData {
  final String description;
  final int quantity;
  final String price;

  InvoiceItemData({required this.description, required this.quantity, required this.price});
}
