import 'dart:async';

import 'package:getnet_payments/enums/payment_type_enum.dart';
import 'package:getnet_payments/getnet_deeplink_payments_platform_interface.dart';
import 'package:getnet_payments/models/transaction.dart';

class GetnetDeeplinkPayments {
  Future<Transaction?> payment({
    required double amount,
    required PaymentTypeEnum paymentType,
    required String callerId,
    int installment = 1,
  }) async {
    assert(amount > 0, 'O valor da compra deve ser maior que zero');
    assert(installment > 0 && installment <= 12,
        'O número de parcelas deve ser maior que zero e menor ou igual a 12');
    assert(
        callerId.isNotEmpty, 'O identificador do cliente não pode ser vazio');
    if (paymentType == PaymentTypeEnum.debit) {
      assert(installment == 1, 'O número de parcelas deve ser maior que 1');
    }

    try {
      // Chamar a plataforma para iniciar o pagamento
      return GetnetDeeplinkPaymentsPlatform.instance.payment(
        amount: amount,
        paymentType: paymentType,
        callerId: callerId,
        installment: installment,
      );
    } catch (e) {
      // Emitir erro pelo stream
      rethrow;
    }
  }

  Future<Transaction?> refund({
    required double amount,
    DateTime? transactionDate,
    String? cvNumber,
    String? originalTerminal,
  }) async {
    assert(amount > 0, 'O valor da compra deve ser maior que zero');

    try {
      // Chamar a plataforma para iniciar o pagamento
      return GetnetDeeplinkPaymentsPlatform.instance.refund(
        amount: amount,
        transactionDate: transactionDate,
        cvNumber: cvNumber,
        originalTerminal: originalTerminal,
      );
    } catch (e) {
      // Emitir erro pelo stream
      rethrow;
    }
  }
}
