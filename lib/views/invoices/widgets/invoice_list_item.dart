import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/routes/app_routes.dart';

enum InvoiceListStatus { paid, pending, unpaid }

class InvoiceListItem extends StatelessWidget {
  final String invoiceId;
  final String clientName;
  final String date;
  final String amount;
  final InvoiceListStatus status;

  const InvoiceListItem({
    Key? key,
    required this.invoiceId,
    required this.clientName,
    required this.date,
    required this.amount,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.invoiceDetail);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: AppRadius.large,
          border: Border.all(color: AppColors.border.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
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
                    clientName,
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
    IconData iconData;
    Color iconColor;
    Color bgColor;

    switch (status) {
      case InvoiceListStatus.paid:
        iconData = Icons.south_west;
        iconColor = AppColors.textPrimary;
        bgColor = AppColors.scaffoldBackground;
        break;
      case InvoiceListStatus.pending:
      case InvoiceListStatus.unpaid:
        iconData = Icons.north_east;
        iconColor = status == InvoiceListStatus.unpaid ? Colors.red : AppColors.textPrimary;
        bgColor = status == InvoiceListStatus.unpaid ? Colors.red.withOpacity(0.05) : AppColors.scaffoldBackground;
        break;
    }

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border.withOpacity(0.3)),
      ),
      child: Icon(iconData, color: iconColor, size: 18),
    );
  }

  Widget _buildStatusBadge() {
    String text;
    Color? bgColor;
    Color textColor;

    switch (status) {
      case InvoiceListStatus.paid:
        text = 'Payé';
        bgColor = null;
        textColor = AppColors.textGrey;
        break;
      case InvoiceListStatus.pending:
        text = 'En attente';
        bgColor = null;
        textColor = AppColors.textPrimary;
        break;
      case InvoiceListStatus.unpaid:
        text = 'Non payé';
        bgColor = const Color(0xFFE63946).withOpacity(0.7);
        textColor = Colors.white;
        break;
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
