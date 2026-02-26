import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';

class AuthTextField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final bool isPassword;

  final TextEditingController? controller;

  const AuthTextField({
    Key? key,
    required this.label,
    required this.hint,
    required this.icon,
    this.isPassword = false,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          obscureText: isPassword,
          style: const TextStyle(color: Color(0xFF0D1B2A)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
            prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 20),
            suffixIcon: isPassword 
              ? const Icon(Icons.visibility_outlined, color: AppColors.textSecondary, size: 20)
              : null,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
}

class PrimaryAuthButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;

  const PrimaryAuthButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(
                color: Color(0xFF0D1B2A),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: AppSpacing.sm),
              Icon(icon, color: const Color(0xFF0D1B2A), size: 18),
            ],
          ],
        ),
      ),
    );
  }
}

class SocialAuthButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const SocialAuthButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: const BorderSide(color: AppColors.border),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.medium,
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFF0D1B2A),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

class DividerWithText extends StatelessWidget {
  final String text;

  const DividerWithText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.border)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.border)),
      ],
    );
  }
}
