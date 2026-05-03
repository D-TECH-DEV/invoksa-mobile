import 'package:invoksa/models/client.dart';
import 'package:invoksa/models/invoice.dart';
import 'package:invoksa/models/invoice_item.dart';
import 'package:invoksa/repositories/invoice_repository.dart';
import 'package:invoksa/core/services/api_service.dart';
import 'dart:typed_data';

class InvoiceServices {
  final InvoiceRepository _invoiceRepository = InvoiceRepository();

  Future<Invoice> createInvoice(
      //Invoice invoice,
      Map<String, dynamic> clientSelected,
      List<Map<String, dynamic>> items,
      int statusCode,
      ) async {

    List<InvoiceItem> invoiceItems = items
        .map((item) => InvoiceItem.fromJson(item))
        .toList();

    Client client = Client.fromJson(clientSelected);

    Invoice newInvoice = Invoice(
      //number: invoice.number,
      client: client,
      statusCode: statusCode,
      items: invoiceItems,
    );

    Invoice invoiceCreated =
    await _invoiceRepository.createInvoice(newInvoice);

    return invoiceCreated;
  }

  Future<Invoice> updateInvoice(
    int id,
    Map<String, dynamic> clientSelected,
    List<Map<String, dynamic>> items,
    int statusCode,
  ) async {
    List<InvoiceItem> invoiceItems = items
        .map((item) => InvoiceItem.fromJson(item))
        .toList();

    Client client = Client.fromJson(clientSelected);

    Invoice invoiceToUpdate = Invoice(
      id: id,
      client: client,
      items: invoiceItems,
      statusCode: statusCode, // use provided code
    );

    return await _invoiceRepository.update(invoiceToUpdate, id);
  }

  Future<Invoice> sendInvoiceAi(String description) async {
    String lang = "fr";
    String devise = "F CFA";
    Invoice invoice = await _invoiceRepository.getInvoiceAi(description, lang, devise);
    return invoice;
  }

  Future<Invoice> markePaid (Invoice invoice) async{
    invoice.statusCode = 200;
    Invoice invoiceUpdated =
    await _invoiceRepository.update(invoice, invoice.id!);
    return invoiceUpdated;
  }

  Future<Uint8List> getInvoicePdf(int id, {String? color, String? name, String? tel, String? email, String? address, String? legalMentions}) async {
    final ApiService apiService = ApiService();
    String query = "?";
    if (color != null && color.isNotEmpty) query += "color=${Uri.encodeComponent(color)}&";
    if (name != null && name.isNotEmpty) query += "name=${Uri.encodeComponent(name)}&";
    if (tel != null && tel.isNotEmpty) query += "tel=${Uri.encodeComponent(tel)}&";
    if (email != null && email.isNotEmpty) query += "email=${Uri.encodeComponent(email)}&";
    if (address != null && address.isNotEmpty) query += "address=${Uri.encodeComponent(address)}&";
    if (legalMentions != null && legalMentions.isNotEmpty) query += "legalMentions=${Uri.encodeComponent(legalMentions)}&";
    
    if (query == "?") query = "";
    else query = query.substring(0, query.length - 1);

    return await apiService.getBytes("/invoices/$id/pdf$query");
  }
}