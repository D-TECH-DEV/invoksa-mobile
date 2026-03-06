import 'package:flutter/material.dart';
import 'package:invoksa/models/invoice.dart';
import 'package:invoksa/view_models/invoice_viewmodel.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_radius.dart';
import 'widgets/invoice_detail_widgets.dart';

class InvoiceDetailScreen extends StatefulWidget {
  final Invoice invoice;

  //const InvoiceDetailScreen({super.key});
  const InvoiceDetailScreen({super.key, required this.invoice});

  @override
  State<InvoiceDetailScreen> createState() => _InvoiceDetailScreenState();
}

class _InvoiceDetailScreenState extends State<InvoiceDetailScreen> {
  final InvoiceViewmodel _invoiceViewmodel = InvoiceViewmodel();
  late final Invoice invoice = widget.invoice;
  @override
  void initState() {
    _invoiceViewmodel.getInvoiceById(invoice.id!);
    _invoiceViewmodel.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


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
        title:  Text(
          'Facture #${invoice.number}',
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
            InvoiceStatusCard(
              status: invoice.status,
              totalAmount: '${invoice.total} F',
              dueDate: 'Échéance le 26 Octobre 2024',
            ),
            const SizedBox(height: AppSpacing.xl),
            ClientInfoSection(
              name: invoice.client?.name ?? "Client inconnu",
              company: 'Microsoft',
              email: invoice.client?.email ?? "Email inconnu",
              phone: invoice.client?.phone ?? "Téléphone inconnu",
              address: invoice.client?.address??"Non spécifier",
              imageUrl: 'https://i.pravatar.cc/150?img=11',
            ),
            const SizedBox(height: AppSpacing.xl),
            InvoiceItemsTable(
              items: (invoice.items ?? []).map((item) {
                return InvoiceItemData(
                  description: item.description,   // ou item.productName selon ton modèle
                  quantity: item.quantity,
                  price: "${item.price.toStringAsFixed(2)} F",
                );
              }).toList(),
              subtotal: "${invoice.total.toStringAsFixed(2)} F",
              tax: "0 F",
              total: "${invoice.total.toStringAsFixed(2)} F",
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
