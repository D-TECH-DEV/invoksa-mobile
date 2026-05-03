import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:invoksa/models/invoice.dart';
import 'package:invoksa/view_models/invoice_viewmodel.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_radius.dart';
import 'widgets/invoice_detail_widgets.dart';

class InvoiceDetailScreen extends StatefulWidget {
  final Invoice invoice;

  const InvoiceDetailScreen({super.key, required this.invoice});

  @override
  State<InvoiceDetailScreen> createState() => _InvoiceDetailScreenState();
}

class _InvoiceDetailScreenState extends State<InvoiceDetailScreen> {
  final InvoiceViewmodel _invoiceViewmodel = InvoiceViewmodel();
  late Invoice _currentInvoice;

  @override
  void initState() {
    super.initState();
    _currentInvoice = widget.invoice;
    _invoiceViewmodel.getInvoiceById(_currentInvoice.id!);
    _invoiceViewmodel.addListener(_onViewModelChange);
  }

  void _onViewModelChange() {
    if (_invoiceViewmodel.invoice != null && mounted) {
      setState(() {
        _currentInvoice = _invoiceViewmodel.invoice!;
      });
    } else {
      if (mounted) setState(() {});
    }
  }

  @override
  void dispose() {
    _invoiceViewmodel.removeListener(_onViewModelChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Format dates realistically
    final DateFormat formatter = DateFormat('dd MMM yyyy');
    String issuedDateStr = 'Unknown';
    String dueDateStr = 'Unknown';
    
    if (_currentInvoice.createdAt != null) {
      issuedDateStr = formatter.format(_currentInvoice.createdAt!);
      // Assuming 14 days due date for demo
      dueDateStr = formatter.format(_currentInvoice.createdAt!.add(const Duration(days: 14)));
    }

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
        actions: [
          if (_currentInvoice.currentStatusName != 'PAID')
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: AppColors.textPrimary),
              onPressed: () async {
                final result = await Navigator.pushNamed(
                  context,
                  '/invoiceCreate',
                  arguments: _currentInvoice,
                );
                if (result == true) {
                  _invoiceViewmodel.getInvoiceById(_currentInvoice.id!);
                }
              },
            ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.textPrimary),
            onPressed: () {
              _invoiceViewmodel.shareInvoice(_currentInvoice.token!);
            },
          ),
          IconButton(
            icon: const Icon(Icons.file_download_outlined, color: AppColors.textPrimary),
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
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Supprimer la facture ?'),
                  content: const Text('Voulez-vous vraiment supprimer cette facture ?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
                    TextButton(
                      onPressed: () async {
                        final success = await _invoiceViewmodel.deleteInvoice(_currentInvoice.id!);
                        if (success && mounted) {
                          Navigator.pop(context); // Close dialog
                          Navigator.pop(context, true); // Go back to list
                        }
                      },
                      child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        child: Column(
          children: [
            InvoiceHeaderSection(
              invoiceNumber: _currentInvoice.number ?? '0000',
              status: _currentInvoice.currentStatusName,
            ),
            const SizedBox(height: 32),
            InvoicePartiesSection(
              clientName: _currentInvoice.client?.name ?? 'Client inconnu',
              clientAddress: _currentInvoice.client?.address ?? '',
              clientEmail: _currentInvoice.client?.email ?? '',
              clientAvatar: 'https://i.pravatar.cc/150?u=${_currentInvoice.client?.id ?? 0}',
            ),
            const SizedBox(height: 32),
            InvoiceDatesSection(
              issuedDate: issuedDateStr,
              dueDate: dueDateStr,
            ),
            const SizedBox(height: 40),
            InvoiceItemsSection(
              items: (_currentInvoice.items ?? []).map((item) {
                return InvoiceItemData(
                  description: item.description,
                  quantity: item.quantity,
                  price: item.price.toStringAsFixed(2),
                  amount: (item.quantity * item.price).toStringAsFixed(2),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            InvoiceTotalsSection(
              subtotal: _currentInvoice.total.toStringAsFixed(2),
              taxAmount: "0.00",
              discountAmount: "0.00",
              grandTotal: _currentInvoice.total.toStringAsFixed(2),
            ),
            const SizedBox(height: 120), // Bottom buttons space
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xl),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_currentInvoice.currentStatusName == 'DRAFT')
              SizedBox(
                width: double.infinity,
                child: _invoiceViewmodel.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: AppColors.primary),
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: const RoundedRectangleBorder(
                            borderRadius: AppRadius.medium,
                          ),
                          elevation: 0,
                        ),
                        onPressed: () async {
                          final success = await _invoiceViewmodel.markAsPending(_currentInvoice);
                          if (success && mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Facture publiée avec succès !')),
                            );
                          } else if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Erreur: ${_invoiceViewmodel.errorMessage}'),
                                backgroundColor: AppColors.danger,
                              ),
                            );
                          }
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.send_rounded, color: Colors.white),
                            SizedBox(width: AppSpacing.md),
                            Text(
                              'Publier la facture',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
              )
            else
              SizedBox(
                width: double.infinity,
                child: _invoiceViewmodel.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: AppColors.primary),
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.textPrimary, // Changed to black to match premium theme
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: const RoundedRectangleBorder(
                            borderRadius: AppRadius.medium,
                          ),
                          elevation: 0,
                        ),
                        onPressed: _currentInvoice.status.toUpperCase() == 'PAID'
                            ? null
                            : () async {
                                setState(() {
                                  _currentInvoice = _currentInvoice.copyWith(
                                    status: 'PAID',
                                    statusCode: 200,
                                  );
                                });

                                final success = await _invoiceViewmodel.changeStatusPaid(_currentInvoice);

                                if (success && mounted) {
                                  ScaffoldMessenger.of(context).showMaterialBanner(
                                    MaterialBanner(
                                      content: const Text(
                                        'Facture marquée comme payée !',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: AppColors.success,
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                                          },
                                          child: const Text('OK', style: TextStyle(color: Colors.white)),
                                        ),
                                      ],
                                    ),
                                  );
                                  Future.delayed(const Duration(seconds: 3), () {
                                    if (mounted) {
                                      ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                                    }
                                  });
                                } else if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Erreur: ${_invoiceViewmodel.errorMessage}'),
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
                              _currentInvoice.status.toUpperCase() == 'PAID' ? 'Payée' : 'Marquer comme payée',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
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

class InvoiceTotalsSection extends StatelessWidget {
  final String subtotal;
  final String taxAmount;
  final String discountAmount;
  final String grandTotal;

  const InvoiceTotalsSection({
    super.key,
    required this.subtotal,
    required this.taxAmount,
    required this.discountAmount,
    required this.grandTotal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.slate50.withValues(alpha: 0.5),
        border: Border.all(color: AppColors.slate200.withValues(alpha: 0.8)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildRow('Subtotal', '\$$subtotal'),
          const SizedBox(height: 12),
          _buildRow('Tax (0%)', '\$$taxAmount'), // Modify tax accordingly if needed
          if (discountAmount != '0' && discountAmount != '0.00') ...[
            const SizedBox(height: 12),
            _buildRow('Discount', '-\$$discountAmount'),
          ],
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Grand total', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500, fontSize: 14)),
              Text('\$$grandTotal', style: AppTextStyles.headingMedium.copyWith(fontWeight: FontWeight.w600, fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.slate400, fontSize: 14)),
        Text(value, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500, fontSize: 14)),
      ],
    );
  }
}

