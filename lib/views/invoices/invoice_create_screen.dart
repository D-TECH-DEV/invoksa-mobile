import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_radius.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_styles.dart';
import '../../view_models/invoice_viewmodel.dart';
import '../../models/client.dart';

class InvoiceCreateScreen extends StatefulWidget {
  const InvoiceCreateScreen({super.key});

  @override
  State<InvoiceCreateScreen> createState() => _InvoiceCreateScreenState();
}

class _InvoiceCreateScreenState extends State<InvoiceCreateScreen> {
  final InvoiceViewmodel _invoiceViewmodel = InvoiceViewmodel();
  Client? _selectedClient;
  final List<Map<String, dynamic>> _invoiceItems = [];

  @override
  void initState() {
    super.initState();
    _invoiceViewmodel.loadClients();
    _invoiceViewmodel.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _invoiceViewmodel.dispose();
    super.dispose();
  }

  double get subtotal =>
      _invoiceItems.fold(0, (sum, item) => sum + (item['quantity'] * item['price']));
  double get tax => subtotal * 0.2;
  double get total => subtotal + tax;

  bool get canSave => _selectedClient != null && _invoiceItems.isNotEmpty;

  void _addArticle(String desc, int qty, double price) {
    setState(() => _invoiceItems.add({'description': desc, 'quantity': qty, 'price': price, "total": qty * price}));
    
  }

  void _removeArticle(int index) => setState(() => _invoiceItems.removeAt(index));

  void _openClientSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return AnimatedBuilder(
          animation: _invoiceViewmodel,
          builder: (context, _) {
            if (_invoiceViewmodel.isLoading) {
              return const SizedBox(
                height: 300,
                child: Center(child: CircularProgressIndicator(color: AppColors.accent)),
              );
            }

            if (_invoiceViewmodel.clients.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Center(child: Text("Aucun client disponible", style: AppTextStyles.caption)),
              );
            }

            return Container(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const Text("Sélectionner un client", style: AppTextStyles.headingMedium),
                  const SizedBox(height: AppSpacing.md),
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: _invoiceViewmodel.clients.length,
                      separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.border),
                      itemBuilder: (context, index) {
                        final client = _invoiceViewmodel.clients[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primary.withOpacity(0.1),
                            child: Text(client.name[0], style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                          ),
                          title: Text(client.name, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                          subtitle: Text(client.email, style: AppTextStyles.caption),
                          onTap: () {
                            setState(() => _selectedClient = client);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _openAddArticleSheet() {
    final descController = TextEditingController();
    final qtyController = TextEditingController(text: "1");
    final priceController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            top: AppSpacing.lg,
            bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const Text("Nouvel Article", style: AppTextStyles.headingMedium),
              const SizedBox(height: AppSpacing.lg),
              _buildInputLabel("Description"),
              _buildInput(descController, "Ex: Design de logo", icon: Icons.description_outlined),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInputLabel("Quantité"),
                        _buildInput(qtyController, "1", isNumber: true, icon: Icons.numbers),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInputLabel("Prix Unitaire (€)"),
                        _buildInput(priceController, "0.00", isNumber: true, icon: Icons.euro_symbol),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: const RoundedRectangleBorder(borderRadius: AppRadius.medium),
                    elevation: 0,
                  ),
                  onPressed: () {
                    if (descController.text.isNotEmpty) {
                      _addArticle(
                        descController.text,
                        int.tryParse(qtyController.text) ?? 1,
                        double.tryParse(priceController.text) ?? 0,
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Ajouter à la facture", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 14)),
    );
  }

  Widget _buildInput(TextEditingController controller, String hint, {bool isNumber = false, IconData? icon}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: AppColors.primary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textSecondary),
        prefixIcon: icon != null ? Icon(icon, color: AppColors.textSecondary, size: 20) : null,
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        contentPadding: const EdgeInsets.all(AppSpacing.md),
        border: OutlineInputBorder(borderRadius: AppRadius.medium, borderSide: const BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(borderRadius: AppRadius.medium, borderSide: const BorderSide(color: AppColors.border)),
        focusedBorder: OutlineInputBorder(borderRadius: AppRadius.medium, borderSide: const BorderSide(color: AppColors.accent, width: 1.5)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: AppColors.primary, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Nouvelle Facture", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 20)),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.border),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //_buildInfoCard(),
            const SizedBox(height: AppSpacing.xl),
            _buildClientSection(),
            const SizedBox(height: AppSpacing.xl),
            _buildArticlesHeader(),
            const SizedBox(height: AppSpacing.md),
            if (_invoiceItems.isEmpty)
              _buildEmptyArticlesPlaceholder()
            else
              ..._invoiceItems.asMap().entries.map((entry) => _buildArticleItem(entry.key, entry.value)),
            const SizedBox(height: AppSpacing.xl),
            if (_invoiceItems.isNotEmpty) _buildSummarySection(),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
      bottomNavigationBar: _buildSaveButton(),
    );
  }

  /*Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F6F9),
        borderRadius: AppRadius.medium,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle),
            child: const Icon(Icons.receipt_long_outlined, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Détails de la facture", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 15)),
                Text("Sélectionnez un client et ajoutez les prestations pour générer votre facture.", style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }*/

  Widget _buildClientSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Client", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 15)),
        const SizedBox(height: AppSpacing.sm),
        GestureDetector(
          onTap: _openClientSelector,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: AppRadius.medium,
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primary.withOpacity(0.05),
                  radius: 22,
                  child: Icon(_selectedClient == null ? Icons.person_add_outlined : Icons.person_outline, color: AppColors.primary),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_selectedClient?.name ?? "Sélectionner un client",
                          style: TextStyle(color: _selectedClient == null ? AppColors.textSecondary : AppColors.primary, fontWeight: FontWeight.bold, fontSize: 15)),
                      if (_selectedClient != null)
                        Text(_selectedClient!.email, style: AppTextStyles.caption),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildArticlesHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Articles / Services", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 15)),
        TextButton.icon(
          onPressed: _openAddArticleSheet,
          icon: const Icon(Icons.add_circle_outline, size: 20, color: AppColors.accent),
          label: const Text("Ajouter", style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildEmptyArticlesPlaceholder() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.border.withOpacity(0.5), style: BorderStyle.solid),
      ),
      child: const Column(
        children: [
          Icon(Icons.inventory_2_outlined, size: 48, color: AppColors.border),
          SizedBox(height: AppSpacing.md),
          Text("Aucun article ajouté", style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildArticleItem(int index, Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['description'], style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 14)),
                const SizedBox(height: 4),
                Text("${item['quantity']} x ${item['price'].toStringAsFixed(2)} €", style: AppTextStyles.caption),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("${(item['quantity'] * item['price']).toStringAsFixed(2)} €", style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
              GestureDetector(
                onTap: () => _removeArticle(index),
                child: const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text("Supprimer", style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w500)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: AppRadius.medium,
      ),
      child: Column(
        children: [
          _buildSummaryRow("Sous-total", "${subtotal.toStringAsFixed(2)} €"),
          const SizedBox(height: AppSpacing.sm),
          _buildSummaryRow("TVA (20%)", "${tax.toStringAsFixed(2)} €"),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Divider(color: AppColors.border),
          ),
          _buildSummaryRow("Total à payer", "${total.toStringAsFixed(2)} €", isTotal: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: isTotal ? AppColors.primary : AppColors.textSecondary, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, fontSize: isTotal ? 16 : 14)),
        Text(value, style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: isTotal ? 18 : 14)),
      ],
    );
  }

  Widget _buildSaveButton() {
    return AnimatedBuilder(
      animation: _invoiceViewmodel,
      builder: (context, child) {
        final bool isLoading = _invoiceViewmodel.isLoading;
        return Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                disabledBackgroundColor: AppColors.accent.withOpacity(0.3),
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: const RoundedRectangleBorder(borderRadius: AppRadius.medium),
                elevation: 0,
              ),
              onPressed: (canSave && !isLoading)
                  ? () async {
                      final success = await _invoiceViewmodel.addInvoice(_selectedClient!.toJson(), _invoiceItems);

                      if (mounted) {
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Facture enregistrée avec succès"),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(_invoiceViewmodel.errorMessage ?? "Erreur lors de l'enregistrement"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    }
                  : null,
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    )
                  : Text(
                      'Enregistrer la Facture',
                      style: TextStyle(
                        color: AppColors.primary.withOpacity(canSave ? 1.0 : 0.5),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}