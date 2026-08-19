import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:invoksa/core/constants/app_colors.dart';
import 'package:invoksa/core/constants/app_spacing.dart';
import 'package:invoksa/core/routes/app_routes.dart';
import 'package:invoksa/core/services/storage_service.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: "Bienvenue sur Invoksa",
      subtitle: "Simplifiez votre gestion financière",
      description: "La solution tout-en-un pour créer, suivre et gérer vos factures professionnelles avec une élégance inégalée.",
      icon: Icons.auto_awesome_motion_rounded,
      color: AppColors.primary,
    ),
    OnboardingData(
      title: "L'Intelligence Artificielle",
      subtitle: "À votre service",
      description: "Gagnez du temps précieux ! Notre IA intelligente extrait automatiquement les données de vos descriptions pour générer des factures précises en un clin d'œil.",
      icon: Icons.psychology_rounded,
      color: AppColors.accent,
    ),
    OnboardingData(
      title: "Suivi & Croissance",
      subtitle: "Gardez toujours le contrôle",
      description: "Visualisez vos revenus en temps réel, gérez votre base clients et ne ratez plus jamais un paiement grâce à nos tableaux de bord intuitifs.",
      icon: Icons.insights_rounded,
      color: const Color(0xFF0D868A),
    ),
  ];

  void _onNext() async {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: 600.ms,
        curve: Curves.fastOutSlowIn,
      );
    } else {
      await StorageService().setOnboardingSeen();
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_currentPage];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Dynamic Background Blobs
          AnimatedContainer(
            duration: 800.ms,
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.8, -0.6),
                radius: 1.2,
                colors: [
                  page.color.withOpacity(0.15),
                  Colors.white,
                ],
              ),
            ),
          ),
          
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: page.color.withOpacity(0.05),
              ),
            ).animate(target: _currentPage.toDouble()).fadeIn().scale(begin: const Offset(0.8, 0.8)),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildHeader(),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) => setState(() => _currentPage = index),
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      final p = _pages[index];
                      return _buildPageContent(p, index);
                    },
                  ),
                ),
                _buildBottomControls(page),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Invoksa",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: AppColors.primary,
              letterSpacing: -0.5,
            ),
          ),
          if (_currentPage < _pages.length - 1)
            TextButton(
              onPressed: () async {
                await StorageService().setOnboardingSeen();
                if (mounted) {
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                }
              },
              child: const Text(
                "Passer",
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPageContent(OnboardingData p, int index) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration Box
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: p.color.withOpacity(0.1),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              p.icon,
              size: 100,
              color: p.color,
            ),
          ).animate(key: ValueKey("icon$index"))
           .fadeIn(duration: 600.ms)
           .scale(delay: 200.ms, curve: Curves.easeOutBack),

          const SizedBox(height: 50),

          // Titles & Subtitles
          Text(
            p.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              letterSpacing: -1,
            ),
          ).animate(key: ValueKey("t$index")).slideY(begin: 0.2, end: 0).fadeIn(),

          const SizedBox(height: 8),

          Text(
            p.subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: p.color,
            ),
          ).animate(key: ValueKey("st$index")).fadeIn(delay: 200.ms),

          const SizedBox(height: 20),

          Text(
            p.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary.withOpacity(0.8),
              height: 1.6,
            ),
          ).animate(key: ValueKey("d$index")).fadeIn(delay: 400.ms),
        ],
      ),
    );
  }

  Widget _buildBottomControls(OnboardingData page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        children: [
          // Indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _pages.length,
              (index) => AnimatedContainer(
                duration: 300.ms,
                margin: const EdgeInsets.only(right: 8),
                height: 6,
                width: _currentPage == index ? 24 : 6,
                decoration: BoxDecoration(
                  color: _currentPage == index ? page.color : page.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 40),

          // Action Button
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: _onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: page.color,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _currentPage == _pages.length - 1 ? "COMMENCER MAINTENANT" : "CONTINUER",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.arrow_forward_rounded, size: 20),
                ],
              ),
            ),
          ).animate(target: _currentPage == _pages.length - 1 ? 1 : 0)
           .shimmer(delay: 2.seconds, duration: 1.seconds, color: Colors.white24),
        ],
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingData({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
  });
}
