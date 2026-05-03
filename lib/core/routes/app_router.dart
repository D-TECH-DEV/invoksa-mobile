import 'package:flutter/material.dart';
import 'package:invoksa/models/client.dart';
import '../../models/invoice.dart';
import '../../views/splash/splash_screen.dart';
import '../../views/onboarding/onboarding_screen.dart';
import '../../views/auth/login_screen.dart';
import '../../views/auth/register_screen.dart';
import '../../views/main_layout.dart';
import '../../views/clients/client_detail_screen.dart';
import '../../views/clients/client_create_screen.dart';
import '../../views/invoices/invoice_detail_screen.dart';
import '../../views/invoices/invoice_create_screen.dart';
import '../../views/settings/settings_screen.dart';
import '../../views/settings/company_settings_screen.dart';
import '../../views/settings/currency_tax_settings_screen.dart';
import '../../views/settings/language_settings_screen.dart';
import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case AppRoutes.main:
        return MaterialPageRoute(builder: (_) => const MainLayout());
      case AppRoutes.clientDetail:
        final client = settings.arguments as Client;
        return MaterialPageRoute(
            builder: (_) => ClientDetailScreen(client: client)
        );
      case AppRoutes.clientCreate:
        final client = settings.arguments as Client?;
        return MaterialPageRoute(builder: (_) => ClientCreateScreen(client: client));
      case AppRoutes.invoiceDetail:
        final invoice = settings.arguments as Invoice;
        return MaterialPageRoute(
          builder: (_) => InvoiceDetailScreen(invoice: invoice),
        );
      case AppRoutes.invoiceCreate:
        final invoice = settings.arguments as Invoice?;
        return MaterialPageRoute(builder: (_) => InvoiceCreateScreen(invoice: invoice));
      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) =>  const SettingsScreen());
      case AppRoutes.companySettings:
        return MaterialPageRoute(builder: (_) => const CompanySettingsScreen());
      case AppRoutes.currencyTax:
        return MaterialPageRoute(builder: (_) => const CurrencyTaxSettingsScreen());
      case AppRoutes.language:
        return MaterialPageRoute(builder: (_) => const LanguageSettingsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
