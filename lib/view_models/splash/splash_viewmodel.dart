import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:invoksa/core/routes/app_router.dart';
import 'package:invoksa/core/routes/app_routes.dart';
import 'package:invoksa/core/services/token_service.dart';

class SplashViewModel extends ChangeNotifier {
  final TokenService _tokenService = TokenService();

  Future<String> getRoute() async {
    final String? token = await _tokenService.getToken();
    if (token==null) {
      return AppRoutes.login;
    }
    return AppRoutes.main;

  }

  /*String getRoute () {
    return"";
  }

  void navigateToLogin(bool mounted) {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    });
  }*/
}
