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
      ) async {

    List<InvoiceItem> invoiceItems = items
        .map((item) => InvoiceItem.fromJson(item))
        .toList();

    Client client = Client.fromJson(clientSelected);

    Invoice newInvoice = Invoice(
      //number: invoice.number,
      client: client,
      //status: invoice.status,
      items: invoiceItems,
    );

    Invoice invoiceCreated =
    await _invoiceRepository.createInvoice(newInvoice);

    return invoiceCreated;
  }
}