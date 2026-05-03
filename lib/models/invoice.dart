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
  final DateTime? dueDate;
  final String? currency;
  final List<InvoiceItem>? items;
  final int deleted;

  String get currentStatusName {
    if (statusCode == 200 || status.toUpperCase() == "PAID") return "PAID";
    if (statusCode == 100 || status.toUpperCase() == "DRAFT") return "DRAFT";
    if (statusCode == 500 || status.toUpperCase() == "PENDING") return "PENDING";
    return status;
  }

  String get statusLabel {
    switch (currentStatusName) {
      case "PAID":
        return "Payé";
      case "DRAFT":
        return "Brouillon";
      case "PENDING":
        return "En attente";
      default:
        return "Inconnu";
    }
  }

  Color get statusColor {
    switch (currentStatusName) {
      case "PAID":
        return Colors.green;
      case "DRAFT":
        return Colors.grey;
      case "PENDING":
        return Colors.orange;
      default:
        return Colors.red;
    }
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
    this.dueDate,
    this.currency,
  }) ;

  String get formattedDate =>
      DateFormat('dd/MM/yyyy HH:mm').format(createdAt!);

  factory Invoice.fromJson(Map<String, dynamic> json) {
    final statusVal = json['status'];
    String statusStr = "PENDING";
    int? statusCode;

    if (statusVal is int) {
      statusCode = statusVal;
      statusStr = (statusVal == 200 ? "PAID" : (statusVal == 100 ? "DRAFT" : "PENDING"));
    } else {
      statusStr = statusVal?.toString() ?? "PENDING";
      statusCode = (statusStr == "PAID" ? 200 : (statusStr == "DRAFT" ? 100 : 500));
    }

    return Invoice(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      status: statusStr,
      statusCode: statusCode,
      number: json["number"]?.toString() ?? "Non spécifié",
      token: json['token']?.toString() ?? "",
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt'].toString()) : null,
      items: json['items'] != null && json['items'] is List
          ? List<InvoiceItem>.from((json['items'] as List).map((x) => InvoiceItem.fromJson(x as Map<String, dynamic>)))
          : [],
      deleted: json['deleted'] is int ? json['deleted'] : (int.tryParse(json['deleted']?.toString() ?? '0') ?? 0),
      client: json['client'] != null ? Client.fromJson(json['client'] as Map<String, dynamic>) : null,
      dueDate: json['dueDate'] != null ? DateTime.tryParse(json['dueDate'].toString()) : null,
      currency: json['currency']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'client': client != null ? {'id': client!.id} : null,
    'total': total,
    'status': statusCode ?? (status == "PAID" ? 200 : (status == "DRAFT" ? 100 : 500)),
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    'items': (items ?? []).map((x) => x.toJson()).toList(),
    'deleted': deleted,
    'dueDate': dueDate?.toIso8601String(),
    'currency': currency,
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
    DateTime? dueDate,
    String? currency,
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
      dueDate: dueDate ?? this.dueDate,
      currency: currency ?? this.currency,
      items: items ?? this.items,
      deleted: deleted ?? this.deleted,
    );
  }

  double get calculatedTotal => (items ?? []).fold(0, (total, item) => total + item.total);
}