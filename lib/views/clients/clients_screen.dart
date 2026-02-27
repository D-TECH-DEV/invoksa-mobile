import 'package:flutter/material.dart';
import 'package:invoksa/view_models/clients/client_viewmodel.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_styles.dart';
import 'widgets/client_card.dart';
import 'widgets/clients_search_bar.dart';
import '../../core/routes/app_routes.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  final ClientViewModel _clientViewModel = ClientViewModel();

  @override
  void initState(){
    _clientViewModel.getMyClient();
    _clientViewModel.addListener(() {
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
                    const ClientsSearchBar(),
                    const SizedBox(height: AppSpacing.xl),
                    _buildSectionHeader('TOUS LES CLIENTS (${_clientViewModel.clients.length})'),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.clientCreate);
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
            'Clients',
            style: AppTextStyles.headingLarge,
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.search, color: AppColors.textPrimary),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.more_vert, color: AppColors.textPrimary),
                onPressed: () {},
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.accent.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'Récent',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.accent,
            ),
          ),
        ),
      ],
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
      return const Center(child: Text("Aucun client trouvé."));
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
        );
      },
    );
  }
}
