import 'package:flutter/foundation.dart';
import 'package:invoksa/models/invoice.dart';
import 'package:invoksa/repositories/invoice_repository.dart';

class InvoiceViewmodel extends ChangeNotifier {
  final InvoiceRepository _invoiceRepository = InvoiceRepository();

  bool isLoading = false;
  String? errorMessage;

  List<Invoice> invoices = [];

  Future<bool> getInvoices() async {
      try {

        isLoading = true;
        errorMessage = null;
        notifyListeners();

        invoices = await _invoiceRepository.getInvoice();

        isLoading = false;
        errorMessage = null;
        notifyListeners();
      } catch (e) {
        errorMessage = e.toString().replaceAll("", "");
        isLoading = false;
        notifyListeners();
      }
      return false;


  }
}