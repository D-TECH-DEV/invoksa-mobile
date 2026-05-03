import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_radius.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/routes/app_routes.dart';
import '../../models/invoice.dart';


class InvoiceListItem extends StatelessWidget {
  final Invoice invoice;

  final String invoiceId;
  final String? clientName;
  final String date;
  final String amount;
  final String status;
  final VoidCallback? onChanged;
  final VoidCallback? onDelete;
  final Color borderStatus;

  InvoiceListItem({
    super.key,
    required this.invoice,
    required this.invoiceId,
    this.clientName,
    required this.date,
    required this.amount,
    required this.status,
    this.onChanged,
    this.onDelete,
  }) : borderStatus = invoice.statusColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.pushNamed(
          context,
          AppRoutes.invoiceDetail,
          arguments: invoice,
        );
        if (onChanged != null) {
          onChanged!();
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: AppRadius.large,
          border: Border.all(color: AppColors.border.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: AppColors.borderAccent.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildIcon(),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    invoiceId,
                    style: AppTextStyles.headingMedium.copyWith(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    clientName ?? "Client inconnu",
                    style: AppTextStyles.body.copyWith(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    date,
                    style: AppTextStyles.caption.copyWith(fontSize: 11, color: AppColors.textGrey.withOpacity(0.7)),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amount,
                  style: AppTextStyles.headingMedium.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildStatusBadge(),
              ],
            ),
            const SizedBox(width: AppSpacing.sm),
            PopupMenuButton<String>(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.more_vert, color: AppColors.textSecondary, size: 20),
              onSelected: (value) async {
                if (value == 'delete' && onDelete != null) {
                  onDelete!();
                } else if (value == 'edit') {
                  final result = await Navigator.pushNamed(
                    context,
                    AppRoutes.invoiceCreate,
                    arguments: invoice,
                  );
                  if (result == true && onChanged != null) {
                    onChanged!();
                  }
                }
              },
              itemBuilder: (context) => [
                if (invoice.currentStatusName != 'PAID')
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, color: AppColors.primary, size: 20),
                        SizedBox(width: 8),
                        Text('Modifier'),
                      ],
                    ),
                  ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, color: Colors.red, size: 20),
                      SizedBox(width: 8),
                      Text('Supprimer', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    late IconData iconData;
    final iconColor = invoice.statusColor;
    const bgColor = AppColors.scaffoldBackground;

    switch (invoice.currentStatusName) {
      case "PAID":
        iconData = Icons.check;
        break;
      case "DRAFT":
        iconData = Icons.edit_document;
        break;
      case "PENDING":
        iconData = Icons.pending;
        break;
      default:
        iconData = Icons.help_outline;
    }

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.border.withOpacity(0.3),
        ),
      ),
      child: Icon(iconData, color: iconColor, size: 18),
    );
  }

  Widget _buildStatusBadge() {
    final text = invoice.statusLabel;
    final textColor = invoice.statusColor;
    Color? bgColor;

    if (invoice.currentStatusName == 'DRAFT') {
      bgColor = Colors.grey.shade200;
    } else if (invoice.currentStatusName == 'UNPAID') {
      bgColor = Colors.white;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: bgColor != null
          ? BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(4),
            )
          : null,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}
