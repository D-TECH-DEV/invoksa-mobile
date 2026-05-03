// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Invoksa';

  @override
  String get home => 'Accueil';

  @override
  String get invoices => 'Factures';

  @override
  String get clients => 'Clients';

  @override
  String get settings => 'Paramètres';

  @override
  String get draft => 'Brouillon';

  @override
  String get pending => 'En attente';

  @override
  String get paid => 'Payé';

  @override
  String get changeLanguage => 'Changer de langue';

  @override
  String get logout => 'Déconnexion';
}
