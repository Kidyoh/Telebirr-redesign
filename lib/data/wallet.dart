import 'package:flutter/foundation.dart';

/// The signed-in wallet (made-up sample data). The balance is a notifier so
/// Home and Send Money update together after a transfer.
abstract final class Wallet {
  static const ownerName = 'Kidus';
  static const ownerPhoneMasked = '+251 9•• ••• 916';

  static final balance = ValueNotifier<double>(5623.60);

  /// Flat platform fee shown on confirm and on the receipt.
  static const fee = 2.00;
}

/// "5623.6" -> "5,623.60".
String formatEtb(double v, {bool decimals = true}) {
  final fixed = v.toStringAsFixed(decimals ? 2 : 0);
  final parts = fixed.split('.');
  final whole = parts[0].replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+$)'),
    (m) => '${m[1]},',
  );
  return parts.length > 1 ? '$whole.${parts[1]}' : whole;
}
