import 'dart:async';

import 'package:getnet_payments/enums/payment_type_enum.dart';
import 'package:getnet_payments/getnet_deeplink_payments_platform_interface.dart';
import 'package:getnet_payments/models/transaction.dart';

/// The [GetnetDeeplinkPayments] class provides methods to perform
/// payments and refunds using the Getnet platform via deeplinks.
///
/// This class validates input parameters and delegates operations
/// to the platform interface [GetnetDeeplinkPaymentsPlatform].
class GetnetDeeplinkPayments {
  /// Processes a payment with the provided parameters.
  ///
  /// [amount] is the payment amount and must be greater than zero.
  /// [paymentType] specifies the type of payment (credit or debit).
  /// [callerId] is the transaction identifier and cannot be empty.
  /// [installment] specifies the number of installments (between 1 and 12).
  /// For debit payments, this value must always be 1.
  ///
  /// Returns a [Transaction] object containing transaction details, or
  /// `null` if the transaction fails.
  ///
  /// Throws an exception if:
  /// - [amount] is less than or equal to 0.
  /// - [installment] is less than 1 or greater than 12.
  /// - [callerId] is empty.
  /// - The number of installments is not 1 for debit payment types.
  Future<Transaction?> payment({
    required double amount,
    required PaymentTypeEnum paymentType,
    required String callerId,
    int installment = 1,
  }) async {
    assert(amount > 0, 'The payment amount must be greater than zero');
    assert(installment > 0 && installment <= 12,
        'The number of installments must be between 1 and 12');
    assert(callerId.isNotEmpty, 'The client identifier cannot be empty');
    if (paymentType == PaymentTypeEnum.debit) {
      assert(installment == 1, 'Installments must equal 1 for debit payments');
    }

    try {
      // Delegate the payment process to the platform
      return GetnetDeeplinkPaymentsPlatform.instance.payment(
        amount: amount,
        paymentType: paymentType,
        callerId: callerId,
        installment: installment,
      );
    } catch (e) {
      // Emit the error through the stream
      rethrow;
    }
  }

  /// Processes a refund for a transaction based on the provided parameters.
  ///
  /// [amount] is the refund amount and must be greater than zero.
  /// [transactionDate] (optional) specifies the date of the original transaction.
  /// [cvNumber] (optional) is the control number of the transaction (CV).
  /// [originTerminal] (optional) identifies the origin terminal.
  ///
  /// Returns a [Transaction] object containing refund details, or
  /// `null` if the operation fails.
  ///
  /// Throws an exception if:
  /// - [amount] is less than or equal to 0.
  Future<Transaction?> refund({
    required double amount,
    DateTime? transactionDate,
    String? cvNumber,
    String? originTerminal,
  }) async {
    assert(amount > 0, 'The refund amount must be greater than zero');

    try {
      // Delegate the refund process to the platform
      return GetnetDeeplinkPaymentsPlatform.instance.refund(
        amount: amount,
        transactionDate: transactionDate,
        cvNumber: cvNumber,
        originTerminal: originTerminal,
      );
    } catch (e) {
      // Emit the error through the stream
      rethrow;
    }
  }
}
