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

  // Save Currency
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
