class ApiConstants {
  //ApiConstants._();

  // Base URL
  static const String baseUrl = "http://10.72.0.206:8080/api";

  // 10.0.2.2 = localhost Android Emulator
  // En production → https://api.invoksa.com

  // Timeout
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Endpoints
  static const String login = "$baseUrl/auth/login";
  static const String register = "/auth/register";

  static const String clients = "/clients";
  static const String myClients = "/clients/me";

  static const String invoices = "/invoices";
  static const String invoicesClient = "/invoices/client";
  static const String invoiceAi = "/invoices/ai";

  static const String dashboard = "/dashboard";

  // Headers
  static const String contentType = "application/json";
  static const String authorization = "Authorization";
  static const String bearer = "Bearer";
}