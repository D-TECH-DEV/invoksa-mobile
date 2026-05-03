import 'package:flutter/material.dart';
import 'package:invoksa/view_models/settings_viewmodel.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/routes/app_routes.dart';
import 'widgets/settings_item.dart';
import '../../core/utils/app_utils.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsViewmodel _settingsViewmodel = SettingsViewmodel();

  @override
  void initState() {
    super.initState();
    _settingsViewmodel.loadSettings();
  }

  void _showChangePasswordDialog() {
    final oldController = TextEditingController();
    final newController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Changer le mot de passe'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Ancien mot de passe'),
            ),
            TextField(
              controller: newController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Nouveau mot de passe'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () async {
              final success = await _settingsViewmodel.changePassword(
                oldController.text,
                newController.text,
              );
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(success ? 'Mot de passe mis à jour' : _settingsViewmodel.errorMessage ?? 'Erreur')),
                );
              }
            },
            child: const Text('Mettre à jour'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le compte ?'),
        content: const Text('Cette action est irréversible. Toutes vos données seront effacées.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              final success = await _settingsViewmodel.deleteAccount();
              if (success && mounted) {
                Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
              }
            },
            child: const Text('Supprimer définitivement', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _settingsViewmodel,
      builder: (context, _) {
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
                  
                  _buildSectionTitle('MON ENTREPRISE'),
                  SettingsItem(
                    icon: Icons.business_rounded,
                    title: 'Profil de l\'entreprise',
                    subtitle: 'Logo, adresse, couleurs et mentions légales',
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.companySettings);
                    },
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
                    onTap: _showChangePasswordDialog,
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
                  const SizedBox(height: 16),
                  _buildDeleteAccountButton(context),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        );
      }
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
          onTap: () async {
            await _settingsViewmodel.logout();
            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
            }
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

  Widget _buildDeleteAccountButton(BuildContext context) {
    return TextButton(
      onPressed: _showDeleteAccountDialog,
      style: TextButton.styleFrom(
        foregroundColor: Colors.red,
        minimumSize: const Size(double.infinity, 50),
      ),
      child: const Text(
        'Supprimer mon compte',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
