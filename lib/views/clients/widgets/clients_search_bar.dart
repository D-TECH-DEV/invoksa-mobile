import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_text_styles.dart';

/// Barre de recherche pour l'écran Clients.
///
/// Le [controller] est géré par le parent (ClientsScreen) pour survivre
/// aux rebuilds déclenchés par ChangeNotifier.
///
/// - [controller] : TextEditingController fourni par le parent.
/// - [onChanged]  : appelé à chaque frappe.
/// - [onClear]    : appelé quand l'utilisateur appuie sur ×.
class ClientsSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;

  const ClientsSearchBar({
    Key? key,
    required this.controller,
    this.hintText = 'Rechercher un client...',
    required this.onChanged,
    this.onClear,
  }) : super(key: key);

  void _handleClear() {
    controller.clear();
    onChanged('');
    onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: AppRadius.large,
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              autofocus: true,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: AppTextStyles.caption.copyWith(fontSize: 15),
                border: InputBorder.none,
              ),
            ),
          ),
          // Bouton × : visible uniquement quand le champ contient du texte
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (_, value, __) {
              if (value.text.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.close,
                    size: 18, color: AppColors.textSecondary),
                onPressed: _handleClear,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              );
            },
          ),
        ],
      ),
    );
  }
}
