import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../view_models/settings_viewmodel.dart';

class CompanySettingsScreen extends StatefulWidget {
  const CompanySettingsScreen({super.key});

  @override
  State<CompanySettingsScreen> createState() => _CompanySettingsScreenState();
}

class _CompanySettingsScreenState extends State<CompanySettingsScreen> {
  final _settingsViewmodel = SettingsViewmodel();
  
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _legalController = TextEditingController();
  final _colorController = TextEditingController();
  final _logoController = TextEditingController();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCompanyInfo();
  }

  Future<void> _loadCompanyInfo() async {
    final info = await _settingsViewmodel.getCompanyInfo();
    setState(() {
      _nameController.text = info['name'] ?? '';
      _addressController.text = info['address'] ?? '';
      _phoneController.text = info['phone'] ?? '';
      _emailController.text = info['email'] ?? '';
      _legalController.text = info['legal'] ?? '';
      _colorController.text = info['color'] ?? '#000000';
      _logoController.text = info['logo'] ?? '';
      _isLoading = false;
    });
  }

  Future<void> _saveCompanyInfo() async {
    await _settingsViewmodel.updateCompanyInfo(
      name: _nameController.text,
      address: _addressController.text,
      phone: _phoneController.text,
      email: _emailController.text,
      legal: _legalController.text,
      logo: _logoController.text,
      color: _colorController.text,
    );
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Informations de l\'entreprise enregistrées'),
          backgroundColor: AppColors.slate900,
        ),
      );
      Navigator.pop(context);
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
          'Profil de l\'entreprise',
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
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ces informations apparaîtront sur vos factures PDF exportées.',
                    style: TextStyle(
                      color: AppColors.slate500,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  _buildLabel('NOM DE L\'ENTREPRISE'),
                  _buildTextField(_nameController, 'Ex: Ma Super Entreprise', Icons.business_rounded),
                  
                  const SizedBox(height: 20),
                  _buildLabel('ADRESSE'),
                  _buildTextField(_addressController, 'Ex: 123 Rue de la Paix, Paris', Icons.location_on_rounded),
                  
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('TÉLÉPHONE'),
                            _buildTextField(_phoneController, 'Ex: +33 1 23 45 67 89', Icons.phone_rounded),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('EMAIL'),
                            _buildTextField(_emailController, 'Ex: contact@entreprise.com', Icons.email_rounded),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  _buildLabel('MENTIONS LÉGALES'),
                  _buildTextField(_legalController, 'Ex: SIRET, Capital social, TVA intracommunautaire...', Icons.article_rounded, maxLines: 3),
                  
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('COULEUR PRIMAIRE (HEX)'),
                            _buildTextField(_colorController, 'Ex: #FF5733', Icons.color_lens_rounded),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        width: 50,
                        height: 50,
                        margin: const EdgeInsets.only(top: 24),
                        decoration: BoxDecoration(
                          color: _parseColor(_colorController.text),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.slate200),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 48),
                  _buildSaveButton(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Color _parseColor(String hex) {
    try {
      if (hex.startsWith('#')) {
        hex = hex.substring(1);
      }
      if (hex.length == 6) {
        hex = 'FF$hex';
      }
      return Color(int.parse(hex, radix: 16));
    } catch (e) {
      return Colors.black;
    }
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: AppColors.slate400,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, {int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.slate200),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        onChanged: (_) {
          if (icon == Icons.color_lens_rounded) setState(() {});
        },
        style: const TextStyle(
          color: AppColors.slate900,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: AppColors.slate300, fontWeight: FontWeight.normal),
          prefixIcon: Icon(icon, color: AppColors.slate400, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saveCompanyInfo,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.slate900,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: const Text(
          'Enregistrer le profil',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
