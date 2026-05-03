import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:invoksa/core/constants/app_colors.dart';
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
      title: "Gestion Simplifiée",
      description: "Créez et gérez vos factures professionnelles en quelques secondes, où que vous soyez.",
      icon: Icons.description_rounded,
      color: AppColors.primary,
    ),
    OnboardingData(
      title: "IA Intelligente",
      description: "Laissez notre intelligence artificielle extraire les données de vos documents pour une saisie ultra-rapide.",
      icon: Icons.auto_awesome_rounded,
      color: AppColors.accent,
    ),
    OnboardingData(
      title: "Suivi Clientèle",
      description: "Gardez un œil sur vos clients et leurs historiques de paiement pour une comptabilité impeccable.",
      icon: Icons.people_alt_rounded,
      color: const Color(0xFF6366F1),
    ),
  ];

  void _onNext() async {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: 500.ms,
        curve: Curves.easeInOutCubic,
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
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Stack(
        children: [
          // Background decoration
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _pages[_currentPage].color.withOpacity(0.1),
              ),
            ).animate(target: _currentPage.toDouble()).fadeIn().scale(),
          ),

          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              final page = _pages[index];
              return Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: page.color.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: page.color.withOpacity(0.2)),
                      ),
                      child: Icon(
                        page.icon,
                        size: 100,
                        color: page.color,
                      ),
                    ).animate(key: ValueKey(index))
                     .fadeIn(duration: 600.ms)
                     .scale(delay: 200.ms)
                     .shimmer(delay: 800.ms),

                    const SizedBox(height: 60),

                    Text(
                      page.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.1,
                      ),
                    ).animate(key: ValueKey("t$index")).slideY(begin: 0.3, end: 0).fadeIn(),

                    const SizedBox(height: 20),

                    Text(
                      page.description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.7),
                        height: 1.5,
                      ),
                    ).animate(key: ValueKey("d$index")).fadeIn(delay: 300.ms),
                  ],
                ),
              );
            },
          ),

          // Bottom Controls
          Positioned(
            bottom: 60,
            left: 40,
            right: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Indicators
                Row(
                  children: List.generate(
                    _pages.length,
                    (index) => AnimatedContainer(
                      duration: 300.ms,
                      margin: const EdgeInsets.only(right: 8),
                      height: 8,
                      width: _currentPage == index ? 24 : 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index 
                            ? _pages[_currentPage].color 
                            : Colors.white24,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),

                // Button
                ElevatedButton(
                  onPressed: _onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _pages[_currentPage].color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 10,
                    shadowColor: _pages[_currentPage].color.withOpacity(0.5),
                  ),
                  child: Text(
                    _currentPage == _pages.length - 1 ? "COMMENCER" : "SUIVANT",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ).animate(target: _currentPage == _pages.length - 1 ? 1 : 0)
                 .shimmer(delay: 2.seconds, duration: 1.seconds),
              ],
            ),
          ),
          
          // Skip button
          if (_currentPage < _pages.length - 1)
            Positioned(
              top: 50,
              right: 20,
              child: TextButton(
                onPressed: () async {
                  await StorageService().setOnboardingSeen();
                  if (mounted) {
                    Navigator.pushReplacementNamed(context, AppRoutes.login);
                  }
                },
                child: Text(
                  "PASSER",
                  style: TextStyle(color: Colors.white.withOpacity(0.5)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
