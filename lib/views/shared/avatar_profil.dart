import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class InitialsAvatar extends StatelessWidget {
  final String fullName;
  final double radius;
  final Color backgroundColor;
  final Color textColor;

  const InitialsAvatar({
    super.key,
    required this.fullName,
    this.radius = 24,
    this.backgroundColor = AppColors.accent,
    this.textColor = Colors.white,
  });

  String _getInitials(String name) {
    // On split le nom par espace
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '';

    // On prend la première lettre de chaque mot (max 2 lettres)
    final initials = parts.length >= 2
        ? '${parts[0][0]}${parts[1][0]}'
        : parts[0][0];

    return initials.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      child: Text(
        _getInitials(fullName),
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: radius * 0.8,
        ),
      ),
    );
  }
}