import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_styles.dart';
import 'widgets/client_card.dart';
import 'widgets/clients_search_bar.dart';
import '../../core/routes/app_routes.dart';

class ClientsScreen extends StatelessWidget {
  const ClientsScreen({Key? key}) : super(key: key);

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
                    _buildSectionHeader('TOUS LES CLIENTS (5)'),
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
    return Column(
      children: const [
        ClientCard(
          name: 'Jean Dupont',
          amount: '2 450 €',
          email: 'jean.dupont@techcorp.fr',
          phone: '06 12 34 56 78',
          imageUrl: 'https://i.pravatar.cc/150?img=11',
          status: ClientStatus.online,
        ),
        ClientCard(
          name: 'Marie Leroy',
          amount: '1 120 €',
          email: 'm.leroy@design-studio.com',
          phone: '07 88 45 21 00',
          imageUrl: 'https://i.pravatar.cc/150?img=5',
          status: ClientStatus.online,
        ),
        ClientCard(
          name: 'Entreprise Artisanale SARL',
          amount: '0 €',
          email: 'contact@artisan-pro.fr',
          phone: '01 45 67 89 10',
          imageUrl: 'https://i.pravatar.cc/150?img=12',
          status: ClientStatus.busy,
        ),
        ClientCard(
          name: 'Thomas Bernard',
          amount: '890 €',
          email: 't.bernard@freelance.io',
          phone: '06 55 44 33 22',
          imageUrl: 'https://i.pravatar.cc/150?img=15',
          status: ClientStatus.online,
        ),
        ClientCard(
          name: 'Sophie Martin',
          amount: '4 200 €',
          email: 'sophie.m@solutions-web.fr',
          phone: '06 00 11 22 33',
          imageUrl: 'https://i.pravatar.cc/150?img=1',
          status: ClientStatus.online,
        ),
      ],
    );
  }

}
