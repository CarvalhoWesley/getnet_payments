import 'package:flutter/foundation.dart';
import 'package:getnet_payments/getnet_payments.dart';

/// Estado compartilhado entre as abas do Deeplink.
class DeeplinkStore {
  DeeplinkStore._();

  static final transactions = ValueNotifier<List<Transaction>>([]);

  /// Guarda só transações aprovadas ou pendentes.
  static void add(Transaction t) {
    if (t.result != TransactionResultEnum.success.value &&
        t.result != TransactionResultEnum.pending.value) {
      return;
    }
    transactions.value = [t, ...transactions.value];
  }

  static void remove(Transaction t) {
    transactions.value = transactions.value.where((e) => e != t).toList();
  }

  /// O deeplink devolve o valor em centavos (ex.: "1050" = R$ 10,50).
  static double amountToDouble(String? amount) =>
      (double.tryParse(amount ?? '') ?? 0) / 100;
}
