import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  void _navigateToLogin() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              Color(0xFF071A26),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// 🔝 Centre principal
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// Carte aevec icône
                    Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.bolt_rounded,
                          color: AppColors.background,
                          size: 50,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    /// Titre
                    const Text(
                      "Invoksa",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.background,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 20),
                    /// Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: AppColors.accent,
                        ),
                        color: AppColors.accent.withOpacity(0.1),
                      ),
                      child: const Text(
                        "Facturation Intelligente",
                        style: TextStyle(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              /// 🔽 Bas de page
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Column(
                  children: [
                    /// Indicateur (3 points)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _dot(true),
                        _dot(false),
                        _dot(false),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "CHARGEMENT DE VOTRE ESPACE",
                      style: TextStyle(
                        color: AppColors.secondary,
                        letterSpacing: 2,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dot(bool active) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: active ? const Color(0xFF2DD4BF) : Colors.white24,
        shape: BoxShape.circle,
      ),
    );
  }
}