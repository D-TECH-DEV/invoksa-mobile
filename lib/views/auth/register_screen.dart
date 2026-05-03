import 'package:flutter/material.dart';
import 'package:invoksa/view_models/auth_viewmodel.dart';
import 'widgets/auth_widgets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/utils/app_utils.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthViewModel _viewModel = AuthViewModel();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
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

                  if (_viewModel.errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _viewModel.errorMessage!,
                              style: const TextStyle(color: Colors.red, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  
                  AuthTextField(
                    label: 'Nom complet',
                    hint: 'Jean Dupont',
                    icon: Icons.person_outline,
                    controller: _nameController,
                  ),
                  
                  const SizedBox(height: AppSpacing.lg),

                  AuthTextField(
                    label: 'Adresse Email',
                    hint: 'nom@exemple.com',
                    icon: Icons.mail_outline,
                    controller: _emailController,
                  ),
                  
                  const SizedBox(height: AppSpacing.lg),
                  
                  AuthTextField(
                    label: 'Mot de passe',
                    hint: '••••••••',
                    icon: Icons.lock_outline,
                    isPassword: true,
                    controller: _passwordController,
                  ),
                  
                  const SizedBox(height: 30),
                  
                  _viewModel.isLoading
                    ? const CircularProgressIndicator(color: Color(0xFF2EC4B6))
                    : PrimaryAuthButton(
                        text: "S'inscrire",
                        onPressed: () async {
                          final success = await _viewModel.register(
                            _nameController.text.trim(),
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                          );
                          if (success && mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Compte créé avec succès ! Connectez-vous.")),
                            );
                            Navigator.pop(context);
                          }
                        },
                      ),
                  
                  const SizedBox(height: 30),
                  
                  const DividerWithText(text: 'OU S\'INSCRIRE AVEC'),
                  
                  const SizedBox(height: 24),
                  
                  Row(
                    children: [
                      SocialAuthButton(text: 'Google', onPressed: () => AppUtils.showComingSoonSnackBar(context, "Inscription Google")),
                      const SizedBox(width: 16),
                      SocialAuthButton(text: 'Apple', onPressed: () => AppUtils.showComingSoonSnackBar(context, "Inscription Apple")),
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
    );
  }
}
