import 'package:flutter/material.dart';
import 'package:invoksa/views/shared/avatar_profil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/routes/app_routes.dart';

enum ClientStatus { online, offline, busy }

class ClientCard extends StatelessWidget {
  final String name;
  final String amount;
  final String email;
  final String phone;
  final String imageUrl;
  final ClientStatus status;

  const ClientCard({
    super.key,
    required this.name,
    required this.amount,
    required this.email,
    required this.phone,
    required this.imageUrl,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.clientDetail);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: AppRadius.medium,
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildAvatar(),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: AppTextStyles.headingMedium.copyWith(fontSize: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        amount,
                        style: AppTextStyles.body.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  _buildContactInfo(Icons.mail_outline, email),
                  const SizedBox(height: 4),
                  _buildContactInfo(Icons.phone_outlined, phone),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Stack(
      children: [
        /*CircleAvatar(
          radius: 28,
          backgroundColor: AppColors.scaffoldBackground,
          backgroundImage: NetworkImage(imageUrl),
        ),*/
        InitialsAvatar(fullName: name),
        Positioned(
          bottom: 2,
          right: 2,
          child: Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: _getStatusColor(),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.background, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor() {
    switch (status) {
      case ClientStatus.online:
        return AppColors.success;
      case ClientStatus.busy:
        return AppColors.warning;
      case ClientStatus.offline:
        return AppColors.textSecondary;
    }
  }

  Widget _buildContactInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
