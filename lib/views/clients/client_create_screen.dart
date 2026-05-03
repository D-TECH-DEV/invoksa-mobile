import 'package:flutter/material.dart';
import 'package:invoksa/models/client.dart';
import 'package:invoksa/view_models/client_viewmodel.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_radius.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_styles.dart';

class ClientCreateScreen extends StatefulWidget {
  final Client? client; // If null, it's "Create" mode, otherwise "Edit" mode.
  const ClientCreateScreen({super.key, this.client});

  @override
  State<ClientCreateScreen> createState() => _ClientCreateScreenState();
}

class _ClientCreateScreenState extends State<ClientCreateScreen> {
  final ClientViewModel _clientViewModel = ClientViewModel();
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  bool get isEditMode => widget.client != null;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.client?.name ?? '');
    emailController = TextEditingController(text: widget.client?.email ?? '');
    phoneController = TextEditingController(text: widget.client?.phone ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    _clientViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Color(0xFF0D1B2A), size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEditMode ? 'Modifier le Client' : 'Ajouter un Client',
          style: const TextStyle(
            color: Color(0xFF0D1B2A),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.border),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(),
            const SizedBox(height: AppSpacing.xl),
            _buildInputField(
              label: 'Nom complet ou Entreprise',
              hint: 'Ex: Kouadio Emmanuel ou SARL Innov',
              icon: Icons.person_outline,
              controller: nameController,
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildInputField(
              label: 'Numéro de téléphone',
              hint: '+225 00 00 00 00 00',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              controller: phoneController
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildInputField(
              label: 'Adresse Email',
              hint: 'client@exemple.com',
              icon: Icons.mail_outline,
              keyboardType: TextInputType.emailAddress,
              controller: emailController
            ),
            const SizedBox(height: AppSpacing.xl),
            _buildNoteSection(),
          ],
        ),
      ),
      bottomNavigationBar: _buildSaveButton(context),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F6F9),
        borderRadius: AppRadius.medium,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1B2A).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.info_outline, color: Color(0xFF0D1B2A), size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditMode ? 'Mettre à jour les informations' : 'Informations du client',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D1B2A),
                    fontSize: 15,
                  ),
                ),
                Text(
                  'Ces détails seront utilisés pour générer vos factures professionnelles.',
                  style: AppTextStyles.caption.copyWith(fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF0D1B2A),
            fontSize: 15,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: Color(0xFF0D1B2A)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.textSecondary),
            prefixIcon: Icon(icon, color: AppColors.textSecondary),
            contentPadding: const EdgeInsets.all(AppSpacing.md),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            border: OutlineInputBorder(
              borderRadius: AppRadius.medium,
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.medium,
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.medium,
              borderSide: const BorderSide(color: Color(0xFF2EC4B6), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoteSection() {
    return AnimatedBuilder(
      animation: _clientViewModel,
      builder: (context, _) {
        final hasError = _clientViewModel.errorMessage != null;
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: hasError ? Colors.red.withOpacity(0.05) : Colors.white,
            borderRadius: AppRadius.medium,
          ),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              border: Border.all(color: hasError ? Colors.red : AppColors.border.withOpacity(0.5)),
              borderRadius: AppRadius.medium,
            ),
            child: Text(
              hasError ? _clientViewModel.errorMessage! : 'Note : Vous pourrez modifier ces informations ultérieurement depuis le profil du client.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: hasError ? Colors.red : AppColors.textSecondary,
                fontStyle: hasError ? FontStyle.normal : FontStyle.italic,
                fontWeight: hasError ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return AnimatedBuilder(
      animation: _clientViewModel,
      builder: (context, _) {
        return Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2EC4B6),
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadius.medium,
                ),
                elevation: 0,
              ),
              onPressed: _clientViewModel.isLoading
                  ? null
                  : () async {
                bool success;
                if (isEditMode) {
                  success = await _clientViewModel.updateClient(
                    widget.client!.id!,
                    nameController.text.trim(),
                    emailController.text.trim(),
                    phoneController.text.trim(),
                  );
                } else {
                  success = await _clientViewModel.addClient(
                    nameController.text.trim(),
                    emailController.text.trim(),
                    phoneController.text.trim()
                  );
                }

                if (success && mounted) {
                  Navigator.pop(context, true); // Return true to indicate change
                }
              },
              child: _clientViewModel.isLoading
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFF0D1B2A),
                ),
              )
                  : Text(
                isEditMode ? 'Mettre à jour le Client' : 'Enregistrer le Client',
                style: const TextStyle(
                  color: Color(0xFF0D1B2A),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
