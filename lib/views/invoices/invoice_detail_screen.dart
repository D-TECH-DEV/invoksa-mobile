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
  late Invoice _currentInvoice;

  @override
  void initState() {
    _currentInvoice = widget.invoice;
    _invoiceViewmodel.getInvoiceById(_currentInvoice.id!);
    _invoiceViewmodel.addListener(_onViewModelChange);
    super.initState();
  }

  void _onViewModelChange() {
    if (_invoiceViewmodel.invoice != null && mounted) {
      setState(() {
        _currentInvoice = _invoiceViewmodel.invoice!;
      });
    } else {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _invoiceViewmodel.removeListener(_onViewModelChange);
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
          icon: const Icon(
            Icons.chevron_left,
            color: AppColors.textPrimary,
            size: 30,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Facture #${_currentInvoice.number}',
          style: AppTextStyles.headingMedium,
        ),
        actions: [
          if (_currentInvoice.currentStatusName != 'PAID')
            IconButton(
              icon: const Icon(
                Icons.edit_outlined,
                color: AppColors.textPrimary,
              ),
              onPressed: () async {
                final result = await Navigator.pushNamed(
                  context,
                  '/invoiceCreate',
                  arguments: _currentInvoice,
                );

                if (result == true) {
                  // Refresh the invoice detail Viewmodel
                  _invoiceViewmodel.getInvoiceById(_currentInvoice.id!);
                }
              },
            ),
          IconButton(
            icon: const Icon(
              Icons.share_outlined,
              color: AppColors.textPrimary,
            ),
            onPressed: () {
              _invoiceViewmodel.shareInvoice(_currentInvoice.token!);
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.file_download_outlined,
              color: AppColors.textPrimary,
            ),
            onPressed: () async {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Téléchargement en cours...')),
              );
              await _invoiceViewmodel.downloadInvoicePdf(_currentInvoice);
              if (_invoiceViewmodel.errorMessage != null && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Erreur: ${_invoiceViewmodel.errorMessage}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
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
              status: _currentInvoice.status,
              totalAmount: '${_currentInvoice.total} F',
              dueDate: 'Échéance le 26 Octobre 2024',
            ),
            const SizedBox(height: AppSpacing.xl),
            ClientInfoSection(
              name: _currentInvoice.client?.name ?? "Client inconnu",
              company: 'Microsoft',
              email: _currentInvoice.client?.email ?? "Email inconnu",
              phone: _currentInvoice.client?.phone ?? "Téléphone inconnu",
              address: _currentInvoice.client?.address ?? "Non spécifier",
              imageUrl: 'https://i.pravatar.cc/150?img=11',
            ),
            const SizedBox(height: AppSpacing.xl),
            InvoiceItemsTable(
              items: (_currentInvoice.items ?? []).map((item) {
                return InvoiceItemData(
                  description:
                      item.description, // ou item.productName selon ton modèle
                  quantity: item.quantity,
                  price: "${item.price.toStringAsFixed(2)} F",
                );
              }).toList(),
              subtotal: "${_currentInvoice.total.toStringAsFixed(2)} F",
              tax: "0 F",
              total: "${_currentInvoice.total.toStringAsFixed(2)} F",
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Émise le : 12 Octobre 2024',
                  style: AppTextStyles.caption,
                ),
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
              child: _invoiceViewmodel.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: AppColors.accent),
                    )
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: const RoundedRectangleBorder(
                          borderRadius: AppRadius.medium,
                        ),
                        elevation: 0,
                      ),
                      onPressed: _currentInvoice.status.toUpperCase() == 'PAID'
                          ? null
                          : () async {
                              // Proactive UI update
                              setState(() {
                                _currentInvoice = _currentInvoice.copyWith(
                                  status: 'PAID',
                                  statusCode: 200,
                                );
                              });

                              final success = await _invoiceViewmodel
                                  .changeStatusPaid(_currentInvoice);

                              if (success && mounted) {
                                ScaffoldMessenger.of(
                                  context,
                                ).showMaterialBanner(
                                  MaterialBanner(
                                    content: const Text(
                                      'Facture marquée comme payée !',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: AppColors.accent,
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).hideCurrentMaterialBanner();
                                        },
                                        child: const Text(
                                          'OK',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                                // Automatically hide banner after 3 seconds
                                Future.delayed(const Duration(seconds: 3), () {
                                  if (mounted) {
                                    ScaffoldMessenger.of(
                                      context,
                                    ).hideCurrentMaterialBanner();
                                  }
                                });
                              } else if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Erreur: ${_invoiceViewmodel.errorMessage}',
                                    ),
                                    backgroundColor: AppColors.danger,
                                  ),
                                );
                              }
                            },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _currentInvoice.status.toUpperCase() == 'PAID'
                                ? Icons.check_circle
                                : Icons.check_circle_outline,
                            color: Colors.white,
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Text(
                            _currentInvoice.status.toUpperCase() == 'PAID'
                                ? 'Payée'
                                : 'Marquer comme payée',
                            style: AppTextStyles.button,
                          ),
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
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadius.medium,
                  ),
                ),
                onPressed: () {
                  _invoiceViewmodel.shareInvoice(_currentInvoice.token!);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.share_outlined, color: AppColors.primary),
                    SizedBox(width: AppSpacing.md),
                    Text(
                      'Partager la facture',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
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
