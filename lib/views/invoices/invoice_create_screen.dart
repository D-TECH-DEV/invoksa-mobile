import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_radius.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/routes/app_routes.dart';
import '../../view_models/invoice_viewmodel.dart';
import '../../models/client.dart';

import '../../models/client.dart';
import '../../models/invoice.dart';
import '../../models/invoice_item.dart';

class InvoiceCreateScreen extends StatefulWidget {
  final Invoice? invoice;

  const InvoiceCreateScreen({super.key, this.invoice});

  @override
  State<InvoiceCreateScreen> createState() => _InvoiceCreateScreenState();
}

class _InvoiceCreateScreenState extends State<InvoiceCreateScreen> {
  final InvoiceViewmodel _invoiceViewmodel = InvoiceViewmodel();
  Client? _selectedClient;
  String? errorMessageAi;
  final List<Map<String, dynamic>> _invoiceItems = [];

  // AI Chat State
  final TextEditingController _aiController = TextEditingController();
  bool _isListening = false;
  final List<Map<String, dynamic>> _chatMessages = [
    {
      "role": "ai",
      "text":
          "Bonjour ! Je suis votre assistant IA. Vous pouvez me dire par exemple : 'Ajoute un logo à 500€'.",
    },
  ];

  @override
  void initState() {
    super.initState();
    _invoiceViewmodel.loadClients();
    _invoiceViewmodel.addListener(() => setState(() {}));

    if (widget.invoice != null) {
      _selectedClient = widget.invoice!.client;
      if (widget.invoice!.items != null) {
        for (var item in widget.invoice!.items!) {
          _invoiceItems.add({
            'description': item.description,
            'quantity': item.quantity,
            'price': item.price,
            'total': item.total,
            'id': item.id,
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _invoiceViewmodel.dispose();
    _aiController.dispose();
    super.dispose();
  }

  double get subtotal => _invoiceItems.fold(
    0,
    (total, item) => total + (item['quantity'] * item['price']),
  );
  double get tax => subtotal * 0.2; // Assuming 20%
  double get total => subtotal + tax;

  bool get canSave => _selectedClient != null && _invoiceItems.isNotEmpty;

  void _addArticle(String desc, int qty, double price) {
    setState(
      () => _invoiceItems.add({
        'description': desc,
        'quantity': qty,
        'price': price,
        "total": qty * price,
      }),
    );
  }

  void _updateArticle(int index, String desc, int qty, double price) {
    setState(() {
      _invoiceItems[index] = {
        'description': desc,
        'quantity': qty,
        'price': price,
        "total": qty * price,
      };
    });
  }

  void _removeArticle(int index) =>
      setState(() => _invoiceItems.removeAt(index));

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
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.accent),
                ),
              );
            }

            if (_invoiceViewmodel.clients.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Center(
                  child: Text(
                    "Aucun client disponible",
                    style: AppTextStyles.caption,
                  ),
                ),
              );
            }

            return SafeArea(
              child: Container(
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
                    const Text(
                      "Sélectionner un client",
                      style: AppTextStyles.headingMedium,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: _invoiceViewmodel.clients.length,
                        separatorBuilder: (_, __) =>
                            const Divider(height: 1, color: AppColors.border),
                        itemBuilder: (context, index) {
                          final client = _invoiceViewmodel.clients[index];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                              vertical: AppSpacing.xs,
                            ),
                            leading: CircleAvatar(
                              backgroundColor: AppColors.primary.withOpacity(
                                0.1,
                              ),
                              child: Text(
                                client.name[0].toUpperCase(),
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              client.name,
                              style: AppTextStyles.body.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              client.email,
                              style: AppTextStyles.caption,
                            ),
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
              ),
            );
          },
        );
      },
    );
  }

  void _openAddOrEditArticleSheet({int? index, Map<String, dynamic>? item}) {
    final descController = TextEditingController(
      text: item?['description'] ?? '',
    );
    final qtyController = TextEditingController(
      text: item?['quantity']?.toString() ?? "1",
    );
    final priceController = TextEditingController(
      text: item?['price']?.toString() ?? "",
    );

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
              Text(
                item == null ? "Nouvel Article" : "Modifier Article",
                style: AppTextStyles.headingMedium,
              ),
              const SizedBox(height: AppSpacing.lg),
              _buildInputLabel("Description"),
              _buildInput(
                descController,
                "Ex: Design d'interface",
                icon: Icons.description_outlined,
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInputLabel("Quantité"),
                        _buildInput(
                          qtyController,
                          "1",
                          isNumber: true,
                          icon: Icons.numbers,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInputLabel("Prix Unitaire (€)"),
                        _buildInput(
                          priceController,
                          "0.00",
                          isNumber: true,
                          icon: Icons.euro_symbol,
                        ),
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
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadius.medium,
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    if (descController.text.isNotEmpty) {
                      if (index != null) {
                        _updateArticle(
                          index,
                          descController.text,
                          int.tryParse(qtyController.text) ?? 1,
                          double.tryParse(priceController.text) ?? 0,
                        );
                      } else {
                        _addArticle(
                          descController.text,
                          int.tryParse(qtyController.text) ?? 1,
                          double.tryParse(priceController.text) ?? 0,
                        );
                      }
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    item == null
                        ? "Ajouter à la facture"
                        : "Modifier l'article",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openAIHelperSheet() {
    final TextEditingController aiDescriptionController =
        TextEditingController();
    bool isLoading = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: AppSpacing.lg,
                right: AppSpacing.lg,
                top: AppSpacing.lg,
                bottom:
                    MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
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

                  const SizedBox(height: 24),

                  const Row(
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Générer avec IA",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // TEXTAREA STYLE SAAS
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F6F9),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: TextField(
                      controller: aiDescriptionController,
                      maxLines: 4,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.primary,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText:
                            "Décrivez les articles, quantités et prix\n(ex: '3 logos à 150€ et 1 site web à 1200€')...",
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Made with IA
                  Row(
                    children: [
                      const Text(
                        "Made with",
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.auto_awesome,
                        size: 14,
                        color: AppColors.primary.withOpacity(0.8),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        "Invoksa AI",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      onPressed: isLoading
                          ? null
                          : () async {
                              final text = aiDescriptionController.text.trim();
                              if (text.isEmpty) return;

                              setModalState(() => isLoading = true);

                              bool success = await _invoiceViewmodel
                                  .loadInvoiceAi(text);

                              if (context.mounted) {
                                setModalState(() => isLoading = false);

                                if (success &&
                                    _invoiceViewmodel.invoiceAi != null &&
                                    _invoiceViewmodel.invoiceAi!.items !=
                                        null) {
                                  final itemsFromAi =
                                      _invoiceViewmodel.invoiceAi!.items!;
                                  for (var item in itemsFromAi) {
                                    _invoiceItems.add({
                                      'description': item.description,
                                      'quantity': item.quantity,
                                      'price': item.price,
                                      'total':
                                          item.total ??
                                          (item.quantity * item.price),
                                    });
                                  }
                                  setState(() {}); // refresh main view
                                  Navigator.pop(context); // close bottom sheet

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "${itemsFromAi.length} article(s) ajouté(s) avec succès !",
                                      ),
                                      backgroundColor: Colors.green,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Désolé, impossible d'extraire les articles.",
                                      ),
                                      backgroundColor: Colors.red,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                }
                              }
                            },
                      child: isLoading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              "Générer les articles",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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

  @override
  Widget build(BuildContext context) {
    bool hasUnsavedChanges =
        _selectedClient != null || _invoiceItems.isNotEmpty;

    return PopScope(
      canPop: !hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        if (hasUnsavedChanges) {
          final shouldPop = await _showExitConfirmationDialog();
          if (shouldPop && context.mounted) {
            Navigator.pop(context);
          }
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.primary,
                size: 20,
              ),
              onPressed: () async {
                if (hasUnsavedChanges) {
                  final shouldPop = await _showExitConfirmationDialog();
                  if (shouldPop && context.mounted) {
                    Navigator.pop(context);
                  }
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ),
          title: Text(
            widget.invoice == null
                ? "Créer une Facture"
                : "Modifier la Facture",
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
              fontSize: 17,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildClientSection(),
                const SizedBox(height: AppSpacing.xl),
                _buildArticlesSection(),
                const SizedBox(height: AppSpacing.xl),
                if (_invoiceItems.isNotEmpty) _buildSummarySection(),
                const SizedBox(height: 100), // padding for FAB and bottom bar
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _openAIHelperSheet,
          backgroundColor: AppColors.accent,
          icon: const Icon(Icons.auto_awesome, color: Colors.white),
          label: const Text("IA", style: TextStyle(color: Colors.white)),
        ),
        bottomNavigationBar: _buildSaveButton(),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildInput(
    TextEditingController controller,
    String hint, {
    bool isNumber = false,
    IconData? icon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      style: const TextStyle(color: AppColors.primary, fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: AppColors.textSecondary.withOpacity(0.6),
          fontSize: 14,
        ),
        prefixIcon: icon != null
            ? Icon(icon, color: AppColors.textSecondary, size: 20)
            : null,
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.medium,
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.medium,
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.medium,
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }

  Future<bool> _showExitConfirmationDialog() async {
    final bool? shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Quitter sans sauvegarder ?",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          "Vous avez des modifications non enregistrées. Êtes-vous sûr de vouloir quitter cette page ? Toutes vos données seront perdues.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              "Annuler",
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Quitter",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
    return shouldPop ?? false;
  }

  Widget _buildClientSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Destinataire",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
              fontSize: 13,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          GestureDetector(
            onTap: _openClientSelector,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primary.withOpacity(0.08),
                    radius: 20,
                    child: Icon(
                      _selectedClient == null
                          ? Icons.person_add_rounded
                          : Icons.person_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedClient?.name ?? "Sélectionnez un client",
                          style: TextStyle(
                            color: _selectedClient == null
                                ? AppColors.textSecondary
                                : AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        if (_selectedClient != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              _selectedClient!.email,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textSecondary,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticlesSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Détails",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  letterSpacing: 0.5,
                ),
              ),
              GestureDetector(
                onTap: () => _openAddOrEditArticleSheet(),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.add, size: 16, color: AppColors.primary),
                      SizedBox(width: 4),
                      Text(
                        "Ajouter",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (_invoiceItems.isEmpty)
            _buildEmptyArticlesPlaceholder()
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _invoiceItems.length,
              separatorBuilder: (context, index) =>
                  const Divider(height: 24, color: AppColors.border),
              itemBuilder: (context, index) =>
                  _buildArticleItem(index, _invoiceItems[index]),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyArticlesPlaceholder() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, style: BorderStyle.solid),
      ),
      child: Column(
        children: [
          Icon(
            Icons.receipt_long_rounded,
            size: 40,
            color: AppColors.textSecondary.withOpacity(0.3),
          ),
          const SizedBox(height: 12),
          const Text(
            "Aucun article",
            style: TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Ajoutez des produits ou services",
            style: TextStyle(
              color: AppColors.textSecondary.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleItem(int index, Map<String, dynamic> item) {
    return InkWell(
      onTap: () => _openAddOrEditArticleSheet(index: index, item: item),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 2),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "${item['quantity']}x",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['description'],
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "PU : ${item['price'].toStringAsFixed(2)} €",
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${(item['quantity'] * item['price']).toStringAsFixed(2)} €",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _removeArticle(index),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.redAccent,
                    size: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummarySection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSummaryRow("Sous-total", "${subtotal.toStringAsFixed(2)} €"),
          const SizedBox(height: AppSpacing.sm),
          _buildSummaryRow("TVA (20%)", "${tax.toStringAsFixed(2)} €"),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: AppColors.border, height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total TTC",
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                "${total.toStringAsFixed(2)} €",
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return AnimatedBuilder(
      animation: _invoiceViewmodel,
      builder: (context, child) {
        final bool isLoading = _invoiceViewmodel.isLoading;
        return Container(
          padding: EdgeInsets.only(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            top: AppSpacing.lg,
            bottom: MediaQuery.of(context).padding.bottom == 0
                ? AppSpacing.lg
                : MediaQuery.of(context).padding.bottom + 8,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.primary.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              onPressed: !canSave || isLoading
                  ? null
                  : () async {
                      if (widget.invoice != null) {
                        // UPDATE INVOICE
                        // Currently InvoiceViewmodel does not have an updateInvoice method,
                        // so we show a snackbar saying it's not supported yet or use a placeholder.
                        // Assuming backend/viewmodel needs to be updated to support 'updateInvoice'.
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "La modification de facture n'est pas encore supportée par le serveur.",
                            ),
                          ),
                        );
                        Navigator.pop(context, true);
                      } else {
                        final success = await _invoiceViewmodel.addInvoice(
                          _selectedClient!.toJson(),
                          _invoiceItems,
                        );

                        if (success && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Facture créée avec succès"),
                            ),
                          );
                          Navigator.pop(
                            context,
                            true,
                          ); // Return true to indicate success
                        } else if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                _invoiceViewmodel.errorMessage ??
                                    "Erreur lors de la création",
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } // end if-else widget.invoice
                    }, // end async onPressed
              child: isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      widget.invoice == null
                          ? "Enregistrer la facture"
                          : "Enregistrer les modifications",
                      style: const TextStyle(
                        color: Colors.white,
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
