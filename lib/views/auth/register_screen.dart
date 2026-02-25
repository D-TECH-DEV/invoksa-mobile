import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import 'widgets/auth_widgets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Color(0xFF0D1B2A), size: 30),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            children: [
              const SizedBox(height: 10),
              
              const Text(
                'Créer un compte',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D1B2A),
                ),
              ),
              
              const SizedBox(height: 12),
              
              const Text(
                'Rejoignez Invoksa et commencez à gérer\nvos finances avec style.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
              
              const SizedBox(height: 40),
              
              const AuthTextField(
                label: 'Nom complet',
                hint: 'Jean Dupont',
                icon: Icons.person_outline,
              ),
              
              const SizedBox(height: AppSpacing.lg),
              
              const AuthTextField(
                label: 'Adresse Email',
                hint: 'nom@exemple.com',
                icon: Icons.mail_outline,
              ),
              
              const SizedBox(height: AppSpacing.lg),
              
              const AuthTextField(
                label: 'Mot de passe',
                hint: '••••••••',
                icon: Icons.lock_outline,
                isPassword: true,
              ),
              
              const SizedBox(height: 30),
              
              PrimaryAuthButton(
                text: "S'inscrire",
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.main,
                    (route) => false,
                  );
                },
              ),
              
              const SizedBox(height: 30),
              
              const DividerWithText(text: 'OU S\'INSCRIRE AVEC'),
              
              const SizedBox(height: 24),
              
              Row(
                children: [
                  SocialAuthButton(text: 'Google', onPressed: () {}),
                  const SizedBox(width: 16),
                  SocialAuthButton(text: 'Apple', onPressed: () {}),
                ],
              ),
              
              const SizedBox(height: 40),
              
              const Text(
                "Vous avez déjà un compte ?",
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
              
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Se connecter',
                  style: TextStyle(
                    color: Color(0xFF2EC4B6),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
