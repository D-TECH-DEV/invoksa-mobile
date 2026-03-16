import 'package:invoksa/models/client.dart';
import 'package:invoksa/models/invoice.dart';
import 'package:invoksa/models/invoice_item.dart';
import 'package:invoksa/repositories/invoice_repository.dart';

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
}