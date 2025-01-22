import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:getnet_payments/enums/payment_type_enum.dart';
import 'package:getnet_payments/models/transaction.dart';
import 'package:intl/intl.dart';

import 'getnet_deeplink_payments_platform_interface.dart';

/// The [MethodChannelGetnetDeeplinkPayments] class is the default implementation
/// of [GetnetDeeplinkPaymentsPlatform], using method channels to communicate
/// with native platform code for handling Getnet payments and refunds.
///
/// This implementation manages state to ensure only one operation is
/// processed at a time and handles communication with the native platform
/// via the `MethodChannel`.
class MethodChannelGetnetDeeplinkPayments
    extends GetnetDeeplinkPaymentsPlatform {
  /// The [MethodChannel] used to interact with native platform code.
  ///
  /// This channel communicates with the platform using the channel name `getnet_payments`.
  @visibleForTesting
  final methodChannel = const MethodChannel('getnet_payments');

  /// Tracks whether a payment or refund operation is currently in progress.
  bool _paymentInProgress = false;

  /// Processes a payment request via the native platform.
  ///
  /// [amount] is the payment amount and must be greater than zero.
  /// [paymentType] specifies the type of payment (credit or debit).
  /// [callerId] is the transaction identifier and cannot be empty.
  /// [installments] specifies the number of installments (between 1 and 12).
  /// [creditType] (optional) specifies the credit type for credit payments (creditMerchant or creditIssuer).
  /// Returns a [Transaction] object containing the transaction details, or
  /// `null` if a transaction is already in progress or if the result is `null`.
  ///
  /// Throws an exception if an error occurs during platform communication.
  @override
  Future<Transaction?> payment({
    required double amount,
    required PaymentTypeEnum paymentType,
    required String callerId,
    int installments = 1,
    String? creditType,
  }) async {
    try {
      if (_paymentInProgress) {
        return null;
      }

      _paymentInProgress = true;

      final result = await methodChannel.invokeMethod<String>(
        'paymentDeeplink',
        <String, dynamic>{
          'amount': amount,
          'paymentType': paymentType.value,
          'callerId': callerId,
          'installments': installments,
          'creditType': creditType,
        },
      );

      if (result == null) {
        return null;
      }

      _paymentInProgress = false;

      return Transaction.fromJson(result);
    } catch (e) {
      _paymentInProgress = false;
      rethrow;
    }
  }

  /// Processes a refund request via the native platform.
  ///
  /// [amount] is the refund amount and must be greater than zero.
  /// [transactionDate] (optional) specifies the date of the original transaction,
  /// formatted as `dd/MM/yy`.
  /// [cvNumber] (optional) is the control number of the transaction (CV).
  /// [originTerminal] (optional) identifies the origin terminal.
  ///
  /// Returns a [Transaction] object containing the refund details, or
  /// `null` if a transaction is already in progress or if the result is `null`.
  ///
  /// Throws an exception if an error occurs during platform communication.
  @override
  Future<Transaction?> refund({
    required double amount,
    DateTime? transactionDate,
    String? cvNumber,
    String? originTerminal,
  }) async {
    try {
      if (_paymentInProgress) {
        return null;
      }

      _paymentInProgress = true;

      final result = await methodChannel.invokeMethod<String>(
        'refundDeeplink',
        <String, dynamic>{
          'amount': amount,
          'transactionDate': transactionDate != null
              ? DateFormat('dd/MM/yy').format(transactionDate)
              : null,
          'cvNumber': cvNumber,
          'originTerminal': originTerminal,
        },
      );

      if (result == null) {
        return null;
      }

      _paymentInProgress = false;

      return Transaction.fromJson(result);
    } catch (e) {
      _paymentInProgress = false;
      rethrow;
    }
  }
}
