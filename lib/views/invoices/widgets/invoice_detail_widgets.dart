import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/currency_utils.dart';
import '../../shared/avatar_profil.dart';

class InvoiceHeaderSection extends StatelessWidget {
  final String invoiceNumber;
  final String status;

  const InvoiceHeaderSection({
    super.key,
    required this.invoiceNumber,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Facture',
              style: AppTextStyles.caption.copyWith(color: AppColors.slate500, fontSize: 14),
            ),
            _buildStatusBadge(),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          invoiceNumber,
          style: AppTextStyles.headingLarge.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge() {
    String text;
    Color color;

    switch (status.toUpperCase()) {
      case 'PAID':
        text = 'Payée';
        color = AppColors.success;
        break;
      case 'UNPAID':
        text = 'Impayée';
        color = AppColors.danger;
        break;
      case 'DRAFT':
        text = 'Brouillon';
        color = AppColors.slate500;
        break;
      case 'PENDING':
        text = 'En attente';
        color = const Color(0xFFD97706);
        break;
      default:
        text = status;
        color = AppColors.slate600;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

class InvoiceInfoCard extends StatelessWidget {
  final String clientName;
  final String clientAddress;
  final String clientEmail;
  final String issuedDate;
  final String dueDate;

  const InvoiceInfoCard({
    super.key,
    required this.clientName,
    required this.clientAddress,
    required this.clientEmail,
    required this.issuedDate,
    required this.dueDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.slate200.withValues(alpha: 0.8)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InitialsAvatar(
                fullName: clientName,
                radius: 20,
                backgroundColor: AppColors.accent.withValues(alpha: 0.15),
                textColor: AppColors.accent,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      clientName,
                      style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold, fontSize: 15),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      clientEmail.isEmpty ? clientAddress : clientEmail,
                      style: AppTextStyles.caption.copyWith(color: AppColors.slate500, fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildDateColumn('Émission', issuedDate)),
              Expanded(child: _buildDateColumn('Échéance', dueDate)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateColumn(String label, String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.slate500, fontSize: 13),
        ),
        const SizedBox(height: 4),
        Text(
          date,
          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ],
    );
  }
}

class InvoiceItemData {
  final String description;
  final int quantity;
  final String price;
  final String amount;

  InvoiceItemData({
    required this.description,
    required this.quantity,
    required this.price,
    required this.amount,
  });
}

class InvoiceItemsSection extends StatelessWidget {
  final List<InvoiceItemData> items;

  const InvoiceItemsSection({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Articles',
          style: AppTextStyles.caption.copyWith(color: AppColors.slate500, fontSize: 13),
        ),
        const SizedBox(height: AppSpacing.md),
        ...items.map((item) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.slate200.withValues(alpha: 0.8)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.description,
                        style: AppTextStyles.body.copyWith(fontSize: 15, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${item.quantity} x ${item.price}',
                        style: AppTextStyles.caption.copyWith(fontSize: 13, color: AppColors.slate500),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  item.amount,
                  style: AppTextStyles.body.copyWith(fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
