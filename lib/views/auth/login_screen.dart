import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../view_models/auth_viewmodel.dart';
import 'widgets/auth_widgets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/utils/app_utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthViewModel _viewModel = AuthViewModel();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  
                  Container(
                    padding: const EdgeInsets.all(0),
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Image.asset(
                      'assets/images/app/logo.png',
                      fit: BoxFit.contain,
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
                  
                  // const SizedBox(height: 12),
                  
                  // const Text(
                  //   'Gérez vos factures et vos clients en\ntoute simplicité.',
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(
                  //     color: AppColors.textSecondary,
                  //     fontSize: 15,
                  //     height: 1.5,
                  //   ),
                  // ),
                  
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
                  
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        final resetController = TextEditingController();
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Réinitialiser le mot de passe'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Entrez votre email pour recevoir un lien de réinitialisation.'),
                                const SizedBox(height: 16),
                                TextField(
                                  controller: resetController,
                                  decoration: const InputDecoration(
                                    labelText: 'Adresse email',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
                              ElevatedButton(
                                onPressed: () {
                                  // Simuler l'envoi d'email
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Lien de réinitialisation envoyé !')),
                                  );
                                },
                                child: const Text('Envoyer'),
                              ),
                            ],
                          ),
                        );
                      },
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
                  
                  const SizedBox(height: 8),
                  
                  _viewModel.isLoading 
                    ? const CircularProgressIndicator(color: Color(0xFF2EC4B6))
                    : PrimaryAuthButton(
                        text: 'Se connecter',
                        icon: Icons.arrow_forward_rounded,
                        onPressed: () async {
                          final success = await _viewModel.login(
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                          );
                          if (success && mounted) {
                            Navigator.pushReplacementNamed(context, AppRoutes.main);
                          }
                        },
                      ),
                  
                  // const SizedBox(height: 30),
                  
                  // const DividerWithText(text: 'OU CONTINUER AVEC'),
                  
                  // const SizedBox(height: 24),
                  
                  // Row(
                  //   children: [
                  //     SocialAuthButton(text: 'Google', onPressed: () => AppUtils.showComingSoonSnackBar(context, "Connexion Google")),
                  //     const SizedBox(width: 16),
                  //     SocialAuthButton(text: 'Apple', onPressed: () => AppUtils.showComingSoonSnackBar(context, "Connexion Apple")),
                  //   ],
                  // ),
                  
                  const SizedBox(height: 40),
                  
                  const Text(
                    "Vous n'avez pas de compte ?",
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  ),
                  
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.register);
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
    );
  }
}
