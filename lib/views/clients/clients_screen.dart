import 'package:flutter/material.dart';
import 'package:invoksa/view_models/client_viewmodel.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_styles.dart';
import '../shared/section_header.dart';
import 'widgets/client_card.dart';
import 'widgets/clients_search_bar.dart';
import '../../core/routes/app_routes.dart';
import '../shared/empty_state_widget.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  final ClientViewModel _clientViewModel = ClientViewModel();
  // Controller créé ici → survive aux rebuilds causés par notifyListeners()
  final TextEditingController _searchController = TextEditingController();

  bool isSearchBarVisible = false;
  String sortFilter = "Plus récent";
  bool showSortFilters = false;

  @override
  void initState() {
    super.initState();
    _clientViewModel.loadClients();
    _clientViewModel.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _clientViewModel.dispose();
    super.dispose();
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
                    isSearchBarVisible
                        ? ClientsSearchBar(
                            controller: _searchController,
                            onChanged: _clientViewModel.searchClients,
                            onClear: _clientViewModel.clearSearch,
                          )
                        : const SizedBox(),
                    isSearchBarVisible ?
                    const SizedBox(height: AppSpacing.xl): const SizedBox(),
                    SectionHeader(
                      title: 'TOUS LES CLIENTS (${_clientViewModel.clients.length})',
                      actionText: sortFilter,
                      onTap: () {
                        setState(() {
                          showSortFilters = !showSortFilters;

                        });
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildClientsList(),
                    const SizedBox(height: 80), // Fab space
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.pushNamed(context, AppRoutes.clientCreate);
          _clientViewModel.loadClients();
        },
        backgroundColor: AppColors.primary,
        elevation: 4,
        //shape: const CircleBorder(),
        icon: const Icon(Icons.add, color: AppColors.background, size: 28), 
        label: Text(
            "Client",
          style: TextStyle(
            color: Colors.white
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
            'Clients',
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
                      _clientViewModel.clearSearch();
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


  Widget _buildClientsList() {
    if (_clientViewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_clientViewModel.errorMessage != null) {
      return Center(child: Text(_clientViewModel.errorMessage!));
    }

    if (_clientViewModel.clients.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.people_alt_rounded,
        title: 'Aucun client trouvé',
        description: 'Commencez par ajouter vos premiers clients pour gérer vos factures plus facilement.',
        actionText: 'Ajouter un client',
        onActionPressed: () async {
          await Navigator.pushNamed(context, AppRoutes.clientCreate);
          _clientViewModel.loadClients();
        },
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _clientViewModel.clients.length,
      itemBuilder: (context, index) {
        final client = _clientViewModel.clients[index];
        return ClientCard(
          name: client.name,
          amount: "1000",
          email: client.email,
          phone: client.phone,
          imageUrl: "https://i.pravatar.cc/150?img=5",
          status: ClientStatus.online,
         client: client,
        );
      },
    );
  }
}
