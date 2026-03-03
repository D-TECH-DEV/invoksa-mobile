import 'package:flutter/foundation.dart';
import 'package:invoksa/models/client.dart';
import 'package:invoksa/models/invoice.dart';
import 'package:invoksa/models/invoice_item.dart';
import 'package:invoksa/repositories/client_repository.dart';
import 'package:invoksa/repositories/invoice_repository.dart';
import 'package:invoksa/services/invoice_services.dart';

class InvoiceViewmodel extends ChangeNotifier {
  final InvoiceRepository _invoiceRepository = InvoiceRepository();
  final InvoiceServices _invoiceServices = InvoiceServices();
  final ClientRepository _clientRepository = ClientRepository();
  bool isLoading = false;
  String? errorMessage;

  List<Invoice> invoices = [];
  List<Client> clients = [];
  List<InvoiceItem> invoiceItemsAdd = [];
  Invoice? invoice;

  Future <bool> addInvoice(Map<String, dynamic> client, List<Map<String, dynamic>> invoiceItems) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final newInvoice = await _invoiceServices.createInvoice(client, invoiceItems);
      //invoices.insert(0, newInvoice);
      loadClients();

      isLoading = false;
      errorMessage = null;
      notifyListeners();
      return true;

    } catch (e) {
      errorMessage = e.toString().replaceAll("", "");
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

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

  Future<bool> loadClients() async {
    try {
      isLoading = true;
      notifyListeners();

      clients = await _clientRepository.getMyClients();

      isLoading = false;
      notifyListeners();
      return true;

    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }




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