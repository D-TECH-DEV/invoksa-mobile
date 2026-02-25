import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

Widget _buildBottomNavigationBar() {
  return Container(
    decoration: const BoxDecoration(
      border: Border(top: BorderSide(color: AppColors.border)),
    ),
    child: BottomNavigationBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      selectedItemColor: AppColors.textPrimary,
      unselectedItemColor: AppColors.textSecondary,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.grid_view),
          label: 'Accueil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long_outlined),
          label: 'Factures',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_outline),
          label: 'Clients',
        ),
      ],
    ),
  );
}