import 'invoice.dart';

class InvoiceItem {
  final int? id;
  final Invoice? invoice;
  final String description;
  final int quantity;
  final double price;
  final double total;

  InvoiceItem({
    this.id,
    this.invoice,
    required this.description,
    required this.quantity,
    required this.price,
    double? total,
  }) : total = total ?? quantity * price;

  factory InvoiceItem.fromJson(Map<String, dynamic> json) => InvoiceItem(
    id: json['id'],
    invoice: json['invoice'] != null ? Invoice.fromJson(json['invoice']) : null,
    description: json['description'],
    quantity: json['quantity'],
    price: (json['price'] as num).toDouble(),
    total: (json['total'] as num?)?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'invoice': invoice?.toJson(),
    'description': description,
    'quantity': quantity,
    'price': price,
    'total': total,
  };
}