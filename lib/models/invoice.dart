import 'client.dart';
import 'invoice_item.dart';
import 'package:intl/intl.dart';

class Invoice {
  final int? id;
  final Client? client;
  //final User? user;
  final double total;
  final String status;
  final String? token;
  int? statusCode;
  final String? number;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<InvoiceItem>? items;
  final int deleted;

  String get currentStatusName {
    if (statusCode == 200 || status.toUpperCase() == "PAID") return "PAID";
    if (statusCode == 500 || status.toUpperCase() == "PENDING") return "PENDING";
    return status;
  }

  Invoice({
    this.id,
    this.client,
    //this.user,
    this.total = 0,
    this.status = "PENDING",
    this.statusCode,
    this.token,
    //DateTime? createdAt,
    //DateTime? updatedAt,
    this.items,
    this.deleted = 0,
     this.number,
    this.createdAt,
    this.updatedAt,
  }) ;

  String get formattedDate =>
      DateFormat('dd/MM/yyyy HH:mm').format(createdAt!);

  factory Invoice.fromJson(Map<String, dynamic> json) => Invoice(
    id: json['id'],
    total: (json['total'] as num?)?.toDouble() ?? 0,
    status: json['status'] is int 
        ? (json['status'] == 200 ? "PAID" : "PENDING")
        : (json['status']?.toString() ?? "PENDING"),
    statusCode: json['status'] is int ? json['status'] : (json['status'] == "PAID" ? 200 : 500),
    number: json["number"] ?? "Non spécifié",
    token: json['token'] ?? "",
    createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
    updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    items: json['items'] != null
        ? List<InvoiceItem>.from(json['items'].map((x) => InvoiceItem.fromJson(x)))
        : [],
    deleted: json['deleted'] ?? 0,
    client: json['client'] != null ? Client.fromJson(json['client']) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'client': client != null ? {'id': client!.id} : null,
    'total': total,
    'status': statusCode ?? (status == "PAID" ? 200 : 500), 
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    'items': (items ?? []).map((x) => x.toJson()).toList(),
    'deleted': deleted,
  };

  Invoice copyWith({
    int? id,
    Client? client,
    double? total,
    String? status,
    int? statusCode,
    String? number,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<InvoiceItem>? items,
    int? deleted,
  }) {
    return Invoice(
      id: id ?? this.id,
      client: client ?? this.client,
      total: total ?? this.total,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      number: number ?? this.number,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      items: items ?? this.items,
      deleted: deleted ?? this.deleted,
    );
  }

  double get calculatedTotal => (items ?? []).fold(0, (total, item) => total + item.total);
}