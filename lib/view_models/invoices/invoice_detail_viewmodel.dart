
import 'package:flutter/material.dart';
import 'package:invoksa/models/invoice.dart';
import 'package:invoksa/repositories/invoice_repository.dart';

class InvoiceDetailViewModel extends ChangeNotifier {
  final InvoiceRepository _invoiceRepository = InvoiceRepository();
  Invoice? invoice;

  bool isLoading = false;
  String? errorMessage;

  Future<bool> getInvoiceById(int id)  async{
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      invoice = await _invoiceRepository.getById(id);

      isLoading = false;
      errorMessage = null;
      notifyListeners();
      return true;
    } catch(e) {
      isLoading = false;
      errorMessage = e.toString().replaceAll("Error", "");
      notifyListeners();
      return false;
    }

  }
}
