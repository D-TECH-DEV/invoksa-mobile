import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CacheService {
  static final CacheService _instance = CacheService._internal();
  factory CacheService() => _instance;
  CacheService._internal();

  final _storage = const FlutterSecureStorage();

  Future<void> setCache(String key, dynamic data) async {
    final expiry = DateTime.now().add(const Duration(hours: 24));
    final cacheData = {
      'expiry': expiry.toIso8601String(),
      'data': data,
    };
    await _storage.write(key: 'cache_$key', value: jsonEncode(cacheData));
  }

  Future<dynamic> getCache(String key) async {
    final value = await _storage.read(key: 'cache_$key');
    if (value == null) return null;

    final cacheData = jsonDecode(value);
    final expiry = DateTime.parse(cacheData['expiry']);

    if (DateTime.now().isAfter(expiry)) {
      await _storage.delete(key: 'cache_$key');
      return null;
    }

    return cacheData['data'];
  }

  Future<void> clearAllCache() async {
    final all = await _storage.readAll();
    for (var key in all.keys) {
      if (key.startsWith('cache_')) {
        await _storage.delete(key: key);
      }
    }
  }
}
