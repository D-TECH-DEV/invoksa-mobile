import 'package:flutter/material.dart';
import 'package:invoksa/models/client.dart';
import '../../models/invoice.dart';
import '../../views/splash/splash_screen.dart';
import '../../views/auth/login_screen.dart';
import '../../views/auth/register_screen.dart';
import '../../views/main_layout.dart';
import '../../views/clients/client_detail_screen.dart';
import '../../views/clients/client_create_screen.dart';
import '../../views/invoices/invoice_detail_screen.dart';
import '../../views/invoices/invoice_create_screen.dart';
import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
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
        return MaterialPageRoute(builder: (_) => ClientCreateScreen());
      case AppRoutes.invoiceDetail:
        final invoice = settings.arguments as Invoice;
        return MaterialPageRoute(
          builder: (_) => InvoiceDetailScreen(invoice: invoice),
        );
      case AppRoutes.invoiceCreate:
        return MaterialPageRoute(builder: (_) => const InvoiceCreateScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
