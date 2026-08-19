import 'invoice.dart';

class InvoiceItem {
  final int? id;
  final Invoice? invoice;
  final String description;
  final int quantity;
  final double price;
  final double total;
  final double taxRate;

  InvoiceItem({
    this.id,
    this.invoice,
    required this.description,
    required this.quantity,
    required this.price,
    this.taxRate = 20.0,
    double? total,
  }) : total = total ?? quantity * price;

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    final double parsedPrice = (json['price'] as num?)?.toDouble() ?? 0.0;
    final int parsedQty = (json['quantity'] as num?)?.toInt() ?? 1;
    
    return InvoiceItem(
      id: json['id'] is int 
          ? json['id'] 
          : (json['id'] != null ? num.tryParse(json['id'].toString())?.toInt() : null),
      invoice: json['invoice'] != null ? Invoice.fromJson(json['invoice']) : null,
      description: json['description']?.toString() ?? '',
      quantity: parsedQty,
      price: parsedPrice,
      total: (json['total'] as num?)?.toDouble() ?? (parsedQty * parsedPrice),
      taxRate: (json['taxRate'] as num?)?.toDouble() ?? 20.0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'description': description,
    'quantity': quantity,
    'price': price,
    'total': total,
    'taxRate': taxRate,
  };
}
