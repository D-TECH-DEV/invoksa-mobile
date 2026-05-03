import 'package:flutter/material.dart';
import '../../core/services/storage_service.dart';

class CompanyViewModel extends ChangeNotifier {
  final StorageService _storageService = StorageService();

  bool isLoading = false;
  String? errorMessage;

  String name = '';
  String address = '';
  String phone = '';
  String email = '';
  String legal = '';
  String? logo;
  String? color;

  Future<void> loadCompanyInfo() async {
    isLoading = true;
    notifyListeners();

    final info = await _storageService.getCompanyInfo();
    name = info['name'] ?? '';
    address = info['address'] ?? '';
    phone = info['phone'] ?? '';
    email = info['email'] ?? '';
    legal = info['legal'] ?? '';
    logo = info['logo'];
    color = info['color'];

    isLoading = false;
    notifyListeners();
  }

  Future<bool> saveCompanyInfo({
    required String name,
    required String address,
    required String phone,
    required String email,
    required String legal,
    String? logoPath,
    String? colorHex,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      await _storageService.saveCompanyInfo(
        name: name,
        address: address,
        phone: phone,
        email: email,
        legal: legal,
        logoPath: logoPath,
        colorHex: colorHex,
      );

      this.name = name;
      this.address = address;
      this.phone = phone;
      this.email = email;
      this.legal = legal;
      this.logo = logoPath;
      this.color = colorHex;

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
}
