import 'client.dart';
import 'invoice_item.dart';

class User {
  final int? id;
  final String username;
  final String email;
  final String password;
  final String role;
  final bool emailVerified;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Client>? clients;

  User({
    this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.role,
    this.emailVerified = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.clients,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    username: json['username'],
    email: json['email'],
    password: json['password'] ?? '',
    role: json['role'],
    emailVerified: json['emailVerified'] ?? false,
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    clients: json['clients'] != null
        ? List<Client>.from(json['clients'].map((x) => Client.fromJson(x)))
        : [],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
    'password': password,
    'role': role,
    'emailVerified': emailVerified,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'clients': clients?.map((x) => x.toJson()).toList(),
  };
}