import 'package:flutter/material.dart';
import 'package:invoksa/main.dart';
import 'package:invoksa/core/services/token_service.dart';
import 'package:invoksa/core/services/storage_service.dart';
import 'package:invoksa/repositories/auth_repository.dart';

class SettingsViewmodel extends ChangeNotifier {
  final TokenService _tokenService = TokenService();
  final StorageService _storageService = StorageService();
  final AuthRepository _authRepository = AuthRepository();

  String _currentLanguage = 'fr';
  String get currentLanguage => _currentLanguage;

  String _currentCurrency = 'XOF';
  String get currentCurrency => _currentCurrency;

  double _currentTaxRate = 0.0;
  double get currentTaxRate => _currentTaxRate;

  bool isLoading = false;
  String? errorMessage;

  Future<void> loadSettings() async {
    _currentLanguage = await _storageService.getLanguage();
    _currentCurrency = await _storageService.getCurrency();
    _currentTaxRate = await _storageService.getTaxRate();
    notifyListeners();
  }

  Future<bool> logout() async {
    try {
      await _tokenService.deleteToken();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      await _authRepository.changePassword(oldPassword, newPassword);

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteAccount() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      await _authRepository.deleteAccount();
      await logout();

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> changeLanguage(BuildContext context, String languageCode) async {
    await _storageService.saveLanguage(languageCode);
    _currentLanguage = languageCode;
    
    if (context.mounted) {
      MyApp.setLocale(context, Locale(languageCode));
    }
    
    notifyListeners();
  }

  Future<void> updateCurrency(String currency) async {
    await _storageService.saveCurrency(currency);
    _currentCurrency = currency;
    notifyListeners();
  }

  Future<void> updateTaxRate(double taxRate) async {
    await _storageService.saveTaxRate(taxRate);
    _currentTaxRate = taxRate;
    notifyListeners();
  }

  Future<Map<String, String?>> getCompanyInfo() async {
    return await _storageService.getCompanyInfo();
  }

  Future<void> updateCompanyInfo({
    required String name,
    required String address,
    required String phone,
    required String email,
    required String legal,
    String? logo,
    String? color,
  }) async {
    isLoading = true;
    notifyListeners();

    await _storageService.saveCompanyInfo(
      name: name,
      address: address,
      phone: phone,
      email: email,
      legal: legal,
      logoPath: logo,
      colorHex: color,
    );

    isLoading = false;
    notifyListeners();
  }
}
