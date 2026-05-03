// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'إنفوكسا';

  @override
  String get home => 'الرئيسية';

  @override
  String get invoices => 'الفواتير';

  @override
  String get clients => 'العملاء';

  @override
  String get settings => 'الإعدادات';

  @override
  String get draft => 'مسودة';

  @override
  String get pending => 'قيد الانتظار';

  @override
  String get paid => 'مدفوع';

  @override
  String get changeLanguage => 'تغيير اللغة';

  @override
  String get logout => 'تسجيل خروج';
}
