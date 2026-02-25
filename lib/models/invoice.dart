import 'client.dart';
import 'invoice_item.dart';
import 'user.dart';

class Invoice {
  final int? id;
  final Client? client;
  final User? user;
  final double total;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<InvoiceItem>? items;
  final int deleted;

  Invoice({
    this.id,
    this.client,
    this.user,
    this.total = 0,
    this.status = "PENDING",
    DateTime? createdAt,
    DateTime? updatedAt,
    this.items,
    this.deleted = 0,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory Invoice.fromJson(Map<String, dynamic> json) => Invoice(
    id: json['id'],
    client: json['client'] != null ? Client.fromJson(json['client']) : null,
    user: json['user'] != null ? User.fromJson(json['user']) : null,
    total: (json['total'] as num?)?.toDouble() ?? 0,
    status: json['status'] ?? "PENDING",
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    items: json['items'] != null
        ? List<InvoiceItem>.from(json['items'].map((x) => InvoiceItem.fromJson(x)))
        : [],
    deleted: json['deleted'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'client': client?.toJson(),
    'user': user?.toJson(),
    'total': total,
    'status': status,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'items': items?.map((x) => x.toJson()).toList(),
    'deleted': deleted,
  };

  double get calculatedTotal => (items ?? []).fold(0, (sum, item) => sum + item.total);
}