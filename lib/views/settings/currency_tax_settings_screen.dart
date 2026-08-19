import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/services/storage_service.dart';

class CurrencyTaxSettingsScreen extends StatefulWidget {
  const CurrencyTaxSettingsScreen({super.key});

  @override
  State<CurrencyTaxSettingsScreen> createState() => _CurrencyTaxSettingsScreenState();
}

class _CurrencyTaxSettingsScreenState extends State<CurrencyTaxSettingsScreen> {
  final _storage = StorageService();
  final _taxController = TextEditingController();
  String _selectedCurrency = 'XOF';
  bool _isLoading = true;

  final List<String> _currencies = ['XOF', 'EUR', 'USD', 'CAD', 'GBP'];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final currency = await _storage.getCurrency();
    final taxRate = await _storage.getTaxRate();
    
    setState(() {
      _selectedCurrency = currency;
      _taxController.text = taxRate.toString();
      _isLoading = false;
    });
  }

  Future<void> _saveSettings() async {
    final taxRate = double.tryParse(_taxController.text) ?? 0.0;
    await _storage.saveCurrency(_selectedCurrency);
    await _storage.saveTaxRate(taxRate);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Paramètres enregistrés avec succès'),
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
          'Devise & Taxes',
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
                    'Configurez votre devise par défaut et vos taux de taxe pour les factures.',
                    style: TextStyle(
                      color: AppColors.slate500,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  _buildLabel('DEVISE DE L\'APPLI'),
                  _buildDropdownField(),
                  
                  const SizedBox(height: 24),
                  
                  _buildLabel('TAUX DE TAXE PAR DÉFAUT (%)'),
                  _buildTextField(_taxController, 'Ex: 18.0', Icons.percent_rounded),
                  
                  const SizedBox(height: 48),
                  
                  _buildSaveButton(),
                ],
              ),
            ),
    );
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

  Widget _buildDropdownField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.slate200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCurrency,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.slate400),
          items: _currencies.map((String currency) {
            return DropdownMenuItem<String>(
              value: currency,
              child: Text(
                currency == 'XOF' ? 'XOF (Franc CFA)' : currency,
                style: const TextStyle(
                  color: AppColors.slate900,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedCurrency = newValue;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.slate200),
      ),
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
        onPressed: _saveSettings,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.slate900,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: const Text(
          'Enregistrer les paramètres',
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
