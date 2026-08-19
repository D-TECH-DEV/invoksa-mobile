import 'package:invoksa/core/constants/api_constants.dart';
import 'package:invoksa/core/services/api_service.dart';
import 'package:invoksa/models/invoice.dart';

class InvoiceRepository {

  final ApiService _apiService = ApiService();

  Future<Invoice> createInvoice(Invoice invoice) async {
    final response = await _apiService.post(ApiConstants.invoices, invoice.toJson());
    return Invoice.fromJson(response);
  }

  Future<List<Invoice>> getInvoice({bool useCache = false}) async {
    final response = await _apiService.get(ApiConstants.myInvoices, useCache: useCache);
    if (response == null || (response is List && response.isEmpty)) {
      return [];
    }

    if(response is List) {
      return response.map((json) => Invoice.fromJson(json)).toList();
    }else if (response is Map) {
      return [Invoice.fromJson(response as Map<String, dynamic>)];
    }
    throw Exception("Erreur de formatage");
  }

  Future<Invoice> getById(int id) async{
    final response = await _apiService.get("${ApiConstants.invoices}/$id");
    return Invoice.fromJson(response);
  }

  Future<Invoice> getInvoiceAi (
      String description, String lang, String devise) async {
    final encodedDesc = Uri.encodeComponent(description);
    final encodedLang = Uri.encodeComponent(lang);
    final encodedDevise = Uri.encodeComponent(devise);
    
    final response = await _apiService.get(
        "${ApiConstants.invoiceAi}?description=$encodedDesc&lang=$encodedLang&devise=$encodedDevise"
    );
    return Invoice.fromJson(response);
  }

  Future<Invoice> update(Invoice invoice, int id) async{
    final response = await _apiService.put(
      "${ApiConstants.invoices}/$id",
      invoice.toJson()
    );
    return Invoice.fromJson(response);
  }

  Future<void> delete(int id) async {
    await _apiService.delete("${ApiConstants.invoices}/$id");
  }
}
