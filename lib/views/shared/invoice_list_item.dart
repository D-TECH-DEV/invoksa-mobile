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
  }) : borderStatus = _getStatusColor(status);

  static Color _getStatusColor(String status) {
    switch (status) {
      case "paid":
        return Colors.green;
      case "unpaid":
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

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
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    late IconData iconData;
    late Color iconColor;
    late Color bgColor;

    switch (status) {
      case "paid":
        iconData = Icons.check;
        iconColor = Colors.green;
        bgColor = AppColors.scaffoldBackground;
        break;

      case "pending":
        iconData = Icons.pending;
        iconColor = Colors.orange;
        bgColor = AppColors.scaffoldBackground;
        break;
      case "unpaid":
        iconData = Icons.warning;
        iconColor = Colors.red;
        bgColor = AppColors.scaffoldBackground;
        break;


      default:
        iconData = Icons.help_outline;
        iconColor = AppColors.textPrimary;
        bgColor = AppColors.scaffoldBackground;
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
    String text;
    Color? bgColor;
    Color textColor;

    switch (status) {
      case "paid":
        text = 'Payé';
        bgColor = null;
        textColor = Colors.green;
        break;

      case "pending":
        text = 'En attente';
        bgColor = null;
        textColor = Colors.orange;
        break;

      case "unpaid":
        text = 'Non payé';
        bgColor = Colors.white;
        textColor = Colors.red;
        break;

      default:
        text = 'Inconnu';
        bgColor = Colors.grey.shade300;
        textColor = Colors.black;
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
