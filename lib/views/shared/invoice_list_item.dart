import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/routes/app_routes.dart';
import '../../models/invoice.dart';

/// Ligne de facture "à plat" (nom du client en avant, N°/date + statut en
/// dessous, montant à droite) — même langage visuel que RecentInvoiceItem
/// sur le dashboard, avec en plus les actions modifier/supprimer.
class InvoiceListItem extends StatelessWidget {
  final Invoice invoice;

  final String invoiceId;
  final String? clientName;
  final String date;
  final String amount;
  final String status;
  final VoidCallback? onChanged;
  final VoidCallback? onDelete;

  const InvoiceListItem({
    super.key,
    required this.invoice,
    required this.invoiceId,
    this.clientName,
    required this.date,
    required this.amount,
    required this.status,
    this.onChanged,
    this.onDelete,
  });

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
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.border.withOpacity(0.6),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    clientName ?? "Client inconnu",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.headingMedium.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.2,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          '$invoiceId • $date',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            fontSize: 13,
                            color: AppColors.slate500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        invoice.statusLabel,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: invoice.statusColor,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              amount,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.headingMedium.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.3,
                color: Colors.black,
              ),
            ),
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
}
