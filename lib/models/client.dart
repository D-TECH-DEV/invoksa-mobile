import 'invoice.dart';

class Client {
  final int? id;
  final String name;
  final String email;
  final String phone;
  final String? address;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Invoice>? invoices;

  Client({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.address,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.invoices,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      name: json['name']?.toString() ?? 'Inconnu',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'address': address,
    //'user': user?.toJson(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    //'invoices': invoices?.map((x) => x.toJson()).toList(),
  };
}