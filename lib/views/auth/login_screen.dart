import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import 'widgets/auth_widgets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            children: [
              const SizedBox(height: 60),
              
              /// Logo Container
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.bolt_rounded,
                  size: 40,
                  color: Color(0xFF0D1B2A),
                ),
              ),
              
              const SizedBox(height: 30),
              
              const Text(
                'Bon retour !',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D1B2A),
                ),
              ),
              
              const SizedBox(height: 12),
              
              const Text(
                'Gérez vos factures et vos clients en\ntoute simplicité.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
              
              const SizedBox(height: 40),
              
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
              
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Mot de passe oublié ?',
                    style: TextStyle(
                      color: Color(0xFF2EC4B6),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: AppSpacing.lg),
              
              PrimaryAuthButton(
                text: 'Se connecter',
                icon: Icons.arrow_forward_rounded,
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.main);
                },
              ),
              
              const SizedBox(height: 30),
              
              const DividerWithText(text: 'OU CONTINUER AVEC'),
              
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
                "Vous n'avez pas de compte ?",
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
              
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.register);
                },
                child: const Text(
                  'Créer un compte gratuitement',
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
