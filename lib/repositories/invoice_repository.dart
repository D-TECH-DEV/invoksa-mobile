import 'package:invoksa/core/constants/api_constants.dart';
import 'package:invoksa/core/services/api_service.dart';
import 'package:invoksa/models/invoice.dart';

class InvoiceRepository {

  final ApiService _apiService = ApiService();

  Future<Invoice> createInvoice(Invoice invoice) async {
    final response = await _apiService.post(ApiConstants.invoices, invoice.toJson());
    return Invoice.fromJson(response);
  }

  Future<List<Invoice>> getInvoice() async {
    final response = await _apiService.get(ApiConstants.invoices);
    if (response == []) {
      return [];
    }

    if(response is List) {
      return response.map((json) => Invoice.fromJson(json)).toList();
    }else if (response is Map) {
      return [Invoice.fromJson(response as Map<String, dynamic>)];
    }
    throw("Erreur de formatage");

  }

  Future<Invoice> getById(int id) async{
    final response = await _apiService.get("${ApiConstants.invoices}/$id");
    return Invoice.fromJson(response);
  }

  Future<Invoice> getInvoiceAi (
      String description, String lang, String devise) async {
    final response = await _apiService.get(
        "${ApiConstants.invoiceAi}?description=$description&lang=$lang&devise=$devise"
    );
    return Invoice.fromJson(response);
  }


}