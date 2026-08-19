import 'package:flutter/material.dart';
import 'package:invoksa/view_models/invoice_viewmodel.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_radius.dart';
import '../shared/section_header.dart';
import 'widgets/invoice_filter_chip.dart';
import '../shared/invoice_list_item.dart';
import '../../core/routes/app_routes.dart';
import '../shared/empty_state_widget.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  final InvoiceViewmodel _invoiceViewmodel = InvoiceViewmodel();

  String selectedFilter = "all";
  bool isSearchBarVisible = false;
  String sortFilter = "Plus récent";
  bool showSortFilters = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    _invoiceViewmodel.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _invoiceViewmodel.getInvoices();
    _invoiceViewmodel.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            const Divider(height: 1, color: AppColors.border),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isSearchBarVisible ?
                    _buildSearchBar() : const SizedBox(),
                    isSearchBarVisible ?
                    const SizedBox(height: AppSpacing.lg) : const SizedBox(),
                    _buildFilters(),
                    const SizedBox(height: AppSpacing.xl),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Les factures (${_invoiceViewmodel.invoices.length})',
                          style: AppTextStyles.headingMedium.copyWith(fontSize: 18),
                        ),
                        GestureDetector(
                          onTap: _showSortBottomSheet,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.accent.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  sortFilter,
                                  style: AppTextStyles.body.copyWith(
                                    color: AppColors.accent,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.sort, color: AppColors.accent, size: 16),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildInvoicesList(),
                    const SizedBox(height: AppSpacing.xl),
                    Center(
                      child: Text(
                        'Fin de la liste des factures',
                        style: AppTextStyles.caption.copyWith(
                          fontStyle: FontStyle.italic,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(height: 80), // Space for FAB
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.invoiceCreate);
        },
        backgroundColor: AppColors.accent,
        elevation: 4,
        //shape: const CircleBorder(),
        icon: const Icon(Icons.add, color: AppColors.background, size: 28),
        label: Text(
          "Facture",
          style: TextStyle(
            color: AppColors.white
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Factures',
            style: AppTextStyles.headingLarge,
          ),
          Row(
          children: [
              IconButton(
              icon: const Icon(Icons.search, color: AppColors.textPrimary),
              onPressed: () {
                setState(() {
                  isSearchBarVisible = !isSearchBarVisible;
                  if (!isSearchBarVisible) {
                    _searchController.clear();
                    _invoiceViewmodel.clearSearch();
                  }
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings, color: AppColors.textPrimary),
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.settings);
              },
            ),
          ],
        )

        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6).withOpacity(0.8),
        borderRadius: AppRadius.large,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppColors.textSecondary, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: _invoiceViewmodel.searchInvoices,
              decoration: InputDecoration(
                hintText: 'Rechercher une facture ou un client...',
                hintStyle: AppTextStyles.caption.copyWith(fontSize: 14),
                border: InputBorder.none,
              ),
            ),
          ),
          // Bouton clear : visible uniquement quand le TextField contient du texte
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _searchController,
            builder: (_, value, __) {
              if (value.text.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.close, size: 18,
                    color: AppColors.textSecondary),
                onPressed: () {
                  _searchController.clear();
                  _invoiceViewmodel.clearSearch();
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          InvoiceFilterChip(
            label: 'Toutes',
            isSelected: selectedFilter == "all",
            onTap: () {
              setState(() {
                selectedFilter = "all";
              });
              _invoiceViewmodel.filterInvoices("all");
            },
          ),
          const SizedBox(width: AppSpacing.sm),
          InvoiceFilterChip(
            label: 'Payées',
            isSelected: selectedFilter == "paid",
            onTap: () {
              setState(() {
                selectedFilter = "paid";
              });
              _invoiceViewmodel.filterInvoices("paid");
            },
          ),
          const SizedBox(width: AppSpacing.sm),
          InvoiceFilterChip(
            label: 'En attente',
            isSelected: selectedFilter == "pending",
            onTap: () {
              setState(() {
                selectedFilter = "pending";
              });
              _invoiceViewmodel.filterInvoices("pending");
            },
          ),
          const SizedBox(width: AppSpacing.sm),
          InvoiceFilterChip(
            label: 'Non payées',
            isSelected: selectedFilter == "unpaid",
            onTap: () {
              setState(() {
                selectedFilter = "unpaid";
              });
              _invoiceViewmodel.filterInvoices("unpaid");
            },
          ),
        ],
      ),
    );
  }


  Widget _buildInvoicesList() {
    if(_invoiceViewmodel.errorMessage != null) {
      return Center(child: Text(_invoiceViewmodel.errorMessage!),);
    }

    if(_invoiceViewmodel.invoices.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.receipt_long_rounded,
        title: 'Aucune facture !',
        description: 'Vous n\'avez pas encore créé de facture pour ce filtre.',
        actionText: 'Créer une facture',
        onActionPressed: () {
          Navigator.pushNamed(context, AppRoutes.invoiceCreate);
        },
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _invoiceViewmodel.invoices.length,
      itemBuilder: (context, index){
        final invoice = _invoiceViewmodel.invoices[index];
        return InvoiceListItem(
          invoiceId: invoice.number ?? "______",
          clientName: invoice.client?.name ?? "Client inconnu",
          date: invoice.formattedDate,
          amount: '${invoice.total} FCFA',
          status: invoice.currentStatusName, // Use currentStatusName to get parsed state
          invoice: invoice,
          onChanged: () {
            _invoiceViewmodel.getInvoices();
          },
          onDelete: () {
            _showDeleteConfirmationDialog(invoice.id!);
          },
        );

      },
    );
  }

  void _showDeleteConfirmationDialog(int invoiceId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer la facture ?'),
        content: const Text('Voulez-vous vraiment supprimer cette facture ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text('Annuler')
          ),
          TextButton(
            onPressed: () async {
              final success = await _invoiceViewmodel.deleteInvoice(invoiceId);
              if (success && mounted) {
                Navigator.pop(context); // Close dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Facture supprimée')),
                );
              }
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Trier par',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              _buildSortOption(
                icon: Icons.calendar_today_outlined,
                title: 'Plus récent',
                option: InvoiceSortOption.newest,
              ),
              _buildSortOption(
                icon: Icons.history,
                title: 'Plus ancien',
                option: InvoiceSortOption.oldest,
              ),
              _buildSortOption(
                icon: Icons.arrow_upward_rounded,
                title: 'Montant élevé',
                option: InvoiceSortOption.amountHigh,
              ),
              _buildSortOption(
                icon: Icons.arrow_downward_rounded,
                title: 'Montant faible',
                option: InvoiceSortOption.amountLow,
              ),
              _buildSortOption(
                icon: Icons.person_outline,
                title: 'Nom du client',
                option: InvoiceSortOption.clientName,
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSortOption({
    required IconData icon,
    required String title,
    required InvoiceSortOption option,
  }) {
    bool isSelected = false;
    switch (option) {
      case InvoiceSortOption.newest: isSelected = sortFilter == "Plus récent"; break;
      case InvoiceSortOption.oldest: isSelected = sortFilter == "Plus ancien"; break;
      case InvoiceSortOption.amountHigh: isSelected = sortFilter == "Montant élevé"; break;
      case InvoiceSortOption.amountLow: isSelected = sortFilter == "Montant faible"; break;
      case InvoiceSortOption.clientName: isSelected = sortFilter == "Nom client"; break;
    }

    return ListTile(
      onTap: () {
        setState(() {
          _invoiceViewmodel.sortInvoices(option);
          switch (option) {
            case InvoiceSortOption.newest: sortFilter = "Plus récent"; break;
            case InvoiceSortOption.oldest: sortFilter = "Plus ancien"; break;
            case InvoiceSortOption.amountHigh: sortFilter = "Montant élevé"; break;
            case InvoiceSortOption.amountLow: sortFilter = "Montant faible"; break;
            case InvoiceSortOption.clientName: sortFilter = "Nom client"; break;
          }
        });
        Navigator.pop(context);
      },
      leading: Icon(
        icon,
        color: isSelected ? AppColors.accent : AppColors.textSecondary,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? AppColors.accent : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          fontSize: 15,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: AppColors.accent, size: 20)
          : null,
    );
  }
}
