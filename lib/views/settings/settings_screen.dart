import 'package:flutter/material.dart';
import 'package:invoksa/view_models/settings_viewmodel.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/routes/app_routes.dart';
import 'widgets/settings_item.dart';
import '../../core/utils/app_utils.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final SettingsViewmodel _settingsViewmodel = SettingsViewmodel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.slate50,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(context),
              const SizedBox(height: 32),
              const Text(
                'Paramètres',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.slate900,
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(height: 32),
              
              _buildSectionTitle('MON COMPTE'),
              SettingsItem(
                icon: Icons.person_rounded,
                title: 'Profil personnel',
                subtitle: 'Modifier vos informations de contact',
                onTap: () => AppUtils.showComingSoonSnackBar(context, "Profil personnel"),
              ),

              const SizedBox(height: 24),
              _buildSectionTitle('PRÉFÉRENCES'),
              SettingsItem(
                icon: Icons.payments_rounded,
                title: 'Devise & Taxes',
                subtitle: 'Configurer vos paramètres par défaut',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.currencyTax);
                },
              ),
              SettingsItem(
                icon: Icons.language_rounded,
                title: "Langue de l'application",
                subtitle: "Gérer la langue d'affichage",
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.language);
                },
              ),
              SettingsItem(
                icon: Icons.notifications_active_rounded,
                title: 'Notifications',
                subtitle: 'Gérer vos alertes et rappels',
                onTap: () => AppUtils.showComingSoonSnackBar(context, "Notifications"),
              ),

              const SizedBox(height: 24),
              _buildSectionTitle('SÉCURITÉ & SUPPORT'),
              SettingsItem(
                icon: Icons.lock_rounded,
                title: 'Mot de passe',
                subtitle: "Changer votre code d'accès",
                onTap: () => AppUtils.showComingSoonSnackBar(context, "Mot de passe"),
              ),
              SettingsItem(
                icon: Icons.help_center_rounded,
                title: "Centre d'aide",
                subtitle: "Besoin d'aide ? Contactez-nous",
                onTap: () => AppUtils.showComingSoonSnackBar(context, "Centre d'aide"),
              ),
              SettingsItem(
                icon: Icons.article_rounded,
                title: 'Terme & Conditions',
                subtitle: "Liser les terme et conditions de l'application",
                onTap: () async {
                  await launchUrl(Uri.parse("https://invoksa.com/terms"));
                },
              ),
              SettingsItem(
                icon: Icons.local_police,
                title: ' Politique de confidentialité',
                subtitle: "Visiter les politique de confidentialités",
                onTap: () async {
                  await launchUrl(Uri.parse("https://invoksa.com/privacy"));
                },
              ),
              SettingsItem(
                icon: Icons.info_rounded,
                title: 'À propos',
                subtitle: 'Version 1.0.0 • Invoksa SaaS',
                onTap: () => AppUtils.showComingSoonSnackBar(context, "À propos"),
              ),

              const SizedBox(height: 32),
              _buildLogoutButton(context),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.slate200),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: AppColors.slate900, size: 22),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: AppColors.slate400,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            _settingsViewmodel.logout();
            Navigator.pushNamed(context, AppRoutes.login);
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.logout_rounded, color: Color(0xFF991B1B), size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Se déconnecter',
                    style: TextStyle(
                      color: Color(0xFF991B1B),
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
