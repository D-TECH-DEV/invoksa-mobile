import 'invoice.dart';
import 'user.dart';

class Client {
  final int? id;
  final String name;
  final String email;
  final String phone;
  final String? address;
  //final User? user;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Invoice>? invoices;

  Client({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.address,
    //this.user,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.invoices,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory Client.fromJson(Map<String, dynamic> json) => Client(
    id: json['id'],
    name: json['name'] ?? '',
    email: json['email'] ?? '',
    phone: json['phone'] ?? '',
    address: json['address'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'address': address,
    //'user': user?.toJson(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'invoices': invoices?.map((x) => x.toJson()).toList(),
  };
}