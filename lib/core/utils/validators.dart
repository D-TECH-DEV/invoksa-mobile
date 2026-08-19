class AppValidators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static final RegExp _phoneRegExp = RegExp(
    r'^\+?[0-9]{8,15}$',
  );

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "L'email est requis";
    }
    if (!_emailRegExp.hasMatch(value)) {
      return "Format d'email invalide";
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return "Le numéro de téléphone est requis";
    }
    // Les champs de saisie suggèrent un format avec espaces (ex: "+225 00 00 00 00 00") ;
    // on ignore espaces/tirets/parenthèses avant de vérifier les chiffres.
    final normalized = value.replaceAll(RegExp(r'[\s\-().]'), '');
    if (!_phoneRegExp.hasMatch(normalized)) {
      return "Format de téléphone invalide (8-15 chiffres)";
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Le mot de passe est requis";
    }
    if (value.length < 8) {
      return "Le mot de passe doit contenir au moins 8 caractères";
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return "Le mot de passe doit contenir au moins une majuscule";
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return "Le mot de passe doit contenir au moins un chiffre";
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Le nom est requis";
    }
    if (value.trim().length < 2) {
      return "Le nom est trop court";
    }
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return "$fieldName est requis";
    }
    return null;
  }
}
