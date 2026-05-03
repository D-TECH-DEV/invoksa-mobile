import 'package:flutter/material.dart';
import 'package:invoksa/core/routes/app_routes.dart';
import 'package:invoksa/core/services/token_service.dart';
import 'package:invoksa/core/services/storage_service.dart';

class SplashViewModel extends ChangeNotifier {
  final TokenService _tokenService = TokenService();
  final StorageService _storageService = StorageService();

  Future<String> getRoute() async {
    final bool onboardingSeen = await _storageService.isOnboardingSeen();
    if (!onboardingSeen) {
      return AppRoutes.onboarding;
    }

    final token = await _tokenService.getToken();

    if (token == null) {
      return AppRoutes.login;
    }

    return AppRoutes.main;
  }
}
