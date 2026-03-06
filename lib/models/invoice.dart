import 'client.dart';
import 'invoice_item.dart';
import 'package:intl/intl.dart';

class Invoice {
  final int? id;
  final Client? client;
  //final User? user;
  final double total;
  final String status;
  final int? statusCode;
  final String? number;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<InvoiceItem>? items;
  final int deleted;

  Invoice({
    this.id,
    this.client,
    //this.user,
    this.total = 0,
    this.status = "PENDING",
    this.statusCode,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.items,
    this.deleted = 0,
     this.number,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  String get formattedDate =>
      DateFormat('dd/MM/yyyy HH:mm').format(createdAt);

  factory Invoice.fromJson(Map<String, dynamic> json) => Invoice(
    id: json['id'],
    //client: json['client'] != null ? Client.fromJson(json['client']) : null,
    //user: json['user'] != null ? User.fromJson(json['user']) : null,
    total: (json['total'] as num?)?.toDouble() ?? 0,
    status: json['status'],
    number: json["number"] ?? "Non spécifier",
    //createdAt: DateTime.parse(json['createdAt']),
    //updatedAt: DateTime.parse(json['updatedAt']),
    items: json['items'] != null
        ? List<InvoiceItem>.from(json['items'].map((x) => InvoiceItem.fromJson(x)))
        : [],
    deleted: json['deleted'] ?? 0,
    client: json['client'] != null ? Client.fromJson(json['client']) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'client': client?.toJson(),
    "clientId": client?.id,
    //'user': user?.toJon(),
    'total': total,
    'status': statusCode,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'items': items?.map((x) => x.toJson()).toList(),
    'deleted': deleted,
  };

  double get calculatedTotal => (items ?? []).fold(0, (total, item) => total + item.total);
}