import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_radius.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_styles.dart';

class ClientCreateScreen extends StatelessWidget {
  const ClientCreateScreen({Key? key}) : super(key: key);

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
        title: const Text(
          'Ajouter un Client',
          style: TextStyle(
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
              hint: 'Ex: Jean Dupont ou SARL Innov',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildInputField(
              label: 'Numéro de téléphone',
              hint: '+33 6 00 00 00 00',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildInputField(
              label: 'Adresse Email',
              hint: 'client@exemple.com',
              icon: Icons.mail_outline,
              keyboardType: TextInputType.emailAddress,
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
                const Text(
                  'Informations du client',
                  style: TextStyle(
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.border, style: BorderStyle.none),
      ),
      child: CustomPaint(
        painter: DashPainter(),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: const Text(
            'Note : Vous pourrez modifier ces informations ultérieurement depuis le profil du client.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
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
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.check, color: Color(0xFF0D1B2A)),
                  SizedBox(width: AppSpacing.md),
                  Text(
                    'Enregistrer le Client',
                    style: TextStyle(
                      color: Color(0xFF0D1B2A),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const double dashWidth = 5;
    const double dashSpace = 3;
    final RRect rRect = RRect.fromLTRBR(0, 0, size.width, size.height, const Radius.circular(12));
    final Path path = Path()..addRRect(rRect);

    // Simplification for the dashed border
     canvas.drawPath(path, paint); // For now standard border, dashed is more complex to implement manually
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
