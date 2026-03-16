import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/services/storage_service.dart';
import '../../main.dart';

class LanguageSettingsScreen extends StatefulWidget {
  const LanguageSettingsScreen({super.key});

  @override
  State<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  final _storage = StorageService();
  String _selectedLanguage = 'fr';
  bool _isLoading = true;

  final List<Map<String, String>> _languages = [
    {'code': 'fr', 'name': 'Français', 'flag': '🇫🇷'},
    {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
    {'code': 'ar', 'name': 'العربية', 'flag': '🇸🇦'},
  ];

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final lang = await _storage.getLanguage();
    setState(() {
      _selectedLanguage = lang;
      _isLoading = false;
    });
  }

  Future<void> _changeLanguage(String code) async {
    setState(() {
      _selectedLanguage = code;
    });
    await _storage.saveLanguage(code);
    
    // Update the app's locale dynamically
    if (mounted) {
      MyApp.setLocale(context, Locale(code));
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Langue changée en ${_languages.firstWhere((l) => l['code'] == code)['name']}'),
          backgroundColor: AppColors.slate900,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.slate50,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.slate200),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: AppColors.slate900, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: const Text(
          'Langue',
          style: TextStyle(
            color: AppColors.slate900,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Choisissez votre langue préférée pour l\'interface de l\'application.',
                    style: TextStyle(
                      color: AppColors.slate500,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ..._languages.map((lang) => _buildLanguageItem(lang)).toList(),
                ],
              ),
            ),
    );
  }

  Widget _buildLanguageItem(Map<String, String> lang) {
    bool isSelected = _selectedLanguage == lang['code'];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppColors.slate900 : AppColors.slate200,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.slate900.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _changeLanguage(lang['code']!),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              children: [
                Text(
                  lang['flag']!,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    lang['name']!,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? AppColors.slate900 : AppColors.slate700,
                    ),
                  ),
                ),
                if (isSelected)
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.slate900,
                    size: 24,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
