import 'package:intl/intl.dart';

/// Formate un montant en Franc CFA avec séparateur de milliers
/// (ex: 100000 -> "100 000 FCFA").
String formatFcfa(num value) {
  return '${NumberFormat('#,##0', 'fr_FR').format(value)} FCFA';
}
