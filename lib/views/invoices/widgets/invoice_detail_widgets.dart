import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';

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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'INV-#$invoiceNumber',
          style: AppTextStyles.headingLarge.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        _buildStatusBadge(),
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
        color = AppColors.slate400;
        break;
      case 'PENDING':
        text = 'En attente';
        color = AppColors.slate600;
        break;
      default:
        text = status;
        color = AppColors.slate600;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.slate200),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}

class InvoiceDatesSection extends StatelessWidget {
  final String issuedDate;
  final String dueDate;

  const InvoiceDatesSection({
    super.key,
    required this.issuedDate,
    required this.dueDate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Date d'emission:",
                style: AppTextStyles.caption.copyWith(color: AppColors.slate500, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text(
                issuedDate,
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, fontSize: 15),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Date d'échéance:",
                style: AppTextStyles.caption.copyWith(color: AppColors.slate500, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text(
                dueDate,
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, fontSize: 15),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class InvoicePartiesSection extends StatelessWidget {
  final String clientName;
  final String clientAddress;
  final String clientEmail;
  final String clientAvatar;

  const InvoicePartiesSection({
    super.key,
    required this.clientName,
    required this.clientAddress,
    required this.clientEmail,
    required this.clientAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bill From (Assuming static host data for now based on UI)
        /*Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bill from',
                style: AppTextStyles.caption.copyWith(color: AppColors.slate500, fontSize: 13),
              ),
              const SizedBox(height: AppSpacing.md),
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.slate200,
                 child: Icon(Icons.business, size: 20, color: AppColors.slate500),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text('YouSoft Invoksa', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 2),
              Text(
                '553, Park Avenue, East\nSide New York',
                style: AppTextStyles.caption.copyWith(color: AppColors.slate500, fontSize: 12, height: 1.4),
              ),
            ],
          ),
        ),*/
        // Bill To
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: AppSpacing.md),
              CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(clientAvatar),
                backgroundColor: AppColors.slate200,
              ),
              const SizedBox(width: AppSpacing.sm),
              Column(
                children: [
                  Text(clientName, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(
                    clientAddress.isEmpty ? clientEmail : clientAddress,
                    style: AppTextStyles.caption.copyWith(color: AppColors.slate500, fontSize: 12, height: 1.4),
                  ),
                ],
              )
            ],
          ),
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
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.slate200.withValues(alpha: 0.8)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.slate50,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  border: Border(bottom: BorderSide(color: AppColors.slate200.withValues(alpha: 0.5))),
                ),
                child: Row(
                  children: [
                    Expanded(flex: 3, child: Text('Description', style: AppTextStyles.caption.copyWith(fontSize: 12))),
                    Expanded(child: Text('Qté x Prix', style: AppTextStyles.caption.copyWith(fontSize: 12), textAlign: TextAlign.center)),
                    Expanded(child: Text('Montant', style: AppTextStyles.caption.copyWith(fontSize: 12), textAlign: TextAlign.right)),
                  ],
                ),
              ),
              // Items
              ...items.asMap().entries.map((entry) {
                int index = entry.key;
                InvoiceItemData item = entry.value;
                bool isLast = index == items.length - 1;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    border: isLast ? null : Border(bottom: BorderSide(color: AppColors.slate200.withValues(alpha: 0.5))),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 16, child: Text('${index + 1}.', style: AppTextStyles.body.copyWith(fontSize: 13, fontWeight: FontWeight.w500))),
                      const SizedBox(width: 8),
                      Expanded(flex: 3, child: Text(item.description, style: AppTextStyles.body.copyWith(fontSize: 13, fontWeight: FontWeight.w500), maxLines: 2, overflow: TextOverflow.ellipsis)),
                      Expanded(child: Text('${item.quantity} x ${item.price}', style: AppTextStyles.body.copyWith(fontSize: 13, fontWeight: FontWeight.w500), textAlign: TextAlign.center)),
                      //Expanded(child: Text('${item.price} FCFA', style: AppTextStyles.body.copyWith(fontSize: 13, color: AppColors.slate600), textAlign: TextAlign.right)),
                      Expanded(child: Text('${item.amount} FCFA', style: AppTextStyles.body.copyWith(fontSize: 13, fontWeight: FontWeight.w600), textAlign: TextAlign.right)),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}


