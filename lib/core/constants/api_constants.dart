import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get baseUrl => dotenv.get('API_BASE_URL', fallback: "https://invoksa-api.you-soft.tech/api");

  // Timeout
  static const Duration connectTimeout = Duration(seconds: 60);
  static const Duration receiveTimeout = Duration(seconds: 60);

  // Endpoints
  static String get login => "$baseUrl/auth/login";
  static String get register => "$baseUrl/auth/register";

  static String get clients => "/clients";
  static String get myClients => "/clients/me";

  static String get invoices => "/invoices";
  static String get myInvoices => "/invoices/me";
  static String get invoicesClient => "/invoices/client";
  static String get invoiceAi => "/invoices/ai";

  static String get dashboard => "/dashboard";

  // Headers
  static const String contentType = "application/json";
  static const String authorization = "Authorization";
  static const String bearer = "Bearer";
}
