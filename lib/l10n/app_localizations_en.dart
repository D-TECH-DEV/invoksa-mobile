// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Invoksa';

  @override
  String get home => 'Home';

  @override
  String get invoices => 'Invoices';

  @override
  String get clients => 'Clients';

  @override
  String get settings => 'Settings';

  @override
  String get draft => 'Draft';

  @override
  String get pending => 'Pending';

  @override
  String get paid => 'Paid';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String get logout => 'Logout';
}
