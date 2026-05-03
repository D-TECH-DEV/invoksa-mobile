import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  final _storage = const FlutterSecureStorage();

  // Keys
  static const String _keyCurrency = 'currency';
  static const String _keyTaxRate = 'tax_rate';
  static const String _keyLanguage = 'language';
  static const String _keyOnboardingSeen = 'onboarding_seen';
  static const String _keyCompanyName = 'company_name';
  static const String _keyCompanyAddress = 'company_address';
  static const String _keyCompanyPhone = 'company_phone';
  static const String _keyCompanyEmail = 'company_email';
  static const String _keyCompanyLegal = 'company_legal';
  static const String _keyCompanyLogo = 'company_logo';
  static const String _keyCompanyColor = 'company_color';

  // Company Info
  Future<void> saveCompanyInfo({
    required String name,
    required String address,
    required String phone,
    required String email,
    required String legal,
    String? logoPath,
    String? colorHex,
  }) async {
    await _storage.write(key: _keyCompanyName, value: name);
    await _storage.write(key: _keyCompanyAddress, value: address);
    await _storage.write(key: _keyCompanyPhone, value: phone);
    await _storage.write(key: _keyCompanyEmail, value: email);
    await _storage.write(key: _keyCompanyLegal, value: legal);
    if (logoPath != null) await _storage.write(key: _keyCompanyLogo, value: logoPath);
    if (colorHex != null) await _storage.write(key: _keyCompanyColor, value: colorHex);
  }

  Future<Map<String, String?>> getCompanyInfo() async {
    return {
      'name': await _storage.read(key: _keyCompanyName),
      'address': await _storage.read(key: _keyCompanyAddress),
      'phone': await _storage.read(key: _keyCompanyPhone),
      'email': await _storage.read(key: _keyCompanyEmail),
      'legal': await _storage.read(key: _keyCompanyLegal),
      'logo': await _storage.read(key: _keyCompanyLogo),
      'color': await _storage.read(key: _keyCompanyColor),
    };
  }

  // Onboarding
  Future<void> setOnboardingSeen() async {
    await _storage.write(key: _keyOnboardingSeen, value: 'true');
  }

  Future<bool> isOnboardingSeen() async {
    final seen = await _storage.read(key: _keyOnboardingSeen);
    return seen == 'true';
  }
  Future<void> saveCurrency(String currency) async {
    await _storage.write(key: _keyCurrency, value: currency);
  }

  // Get Currency
  Future<String> getCurrency() async {
    return await _storage.read(key: _keyCurrency) ?? 'XOF';
  }

  // Save Tax Rate
  Future<void> saveTaxRate(double taxRate) async {
    await _storage.write(key: _keyTaxRate, value: taxRate.toString());
  }

  // Get Tax Rate
  Future<double> getTaxRate() async {
    final taxStr = await _storage.read(key: _keyTaxRate);
    return double.tryParse(taxStr ?? '0') ?? 0.0;
  }

  // Save Language
  Future<void> saveLanguage(String languageCode) async {
    await _storage.write(key: _keyLanguage, value: languageCode);
  }

  // Get Language
  Future<String> getLanguage() async {
    return await _storage.read(key: _keyLanguage) ?? 'fr';
  }
}
