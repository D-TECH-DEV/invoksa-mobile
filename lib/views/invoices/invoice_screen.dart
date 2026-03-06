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
                    SectionHeader(
                      title: 'Les facture (${_invoiceViewmodel.invoices.length})',
                      actionText: sortFilter,
                      onTap: () {
                        setState(() {
                          showSortFilters = !showSortFilters;
                        });
                      },
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.invoiceCreate);
        },
        backgroundColor: AppColors.primary,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: AppColors.background, size: 28),
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
              onPressed: () {},
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
      return Center(child: const Text("Aucune facture !"),);
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
          amount: '${invoice.total} F',
          status: invoice.status,
          invoice: invoice,
        );

      },
    );
  }
}
