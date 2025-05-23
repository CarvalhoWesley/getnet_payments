import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:getnet_payments/enums/transaction/payment_type_enum.dart';
import 'package:getnet_payments/models/transaction/transaction.dart';
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
  bool _transactionInProgress = false;

  /// Processes a payment request via the native platform.
  ///
  /// [amount] is the payment amount and must be greater than zero.
  /// [paymentType] specifies the type of payment (credit or debit).
  /// [callerId] is the transaction identifier and cannot be empty.
  /// [installments] specifies the number of installments (between 1 and 12).
  /// [creditType] (optional) specifies the credit type for credit payments (creditMerchant or creditIssuer).
  /// [allowPrintCurrentTransaction] (optional) specifies whether to allow printing the current transaction.
  ///
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
    bool? allowPrintCurrentTransaction,
  }) async {
    try {
      if (_transactionInProgress) {
        return null;
      }

      _transactionInProgress = true;

      final result = await methodChannel.invokeMethod<String>(
        'paymentDeeplink',
        <String, dynamic>{
          'amount': amount,
          'paymentType': paymentType.value,
          'callerId': callerId,
          'installments': installments,
          'creditType': creditType,
          'allowPrintCurrentTransaction': allowPrintCurrentTransaction,
        },
      );

      if (result == null) {
        return null;
      }

      _transactionInProgress = false;

      return Transaction.fromJson(result);
    } catch (e) {
      _transactionInProgress = false;
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
  /// [allowPrintCurrentTransaction] (optional) specifies whether to allow printing the current transaction.
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
    bool? allowPrintCurrentTransaction,
  }) async {
    try {
      if (_transactionInProgress) {
        return null;
      }

      _transactionInProgress = true;

      final result = await methodChannel.invokeMethod<String>(
        'refundDeeplink',
        <String, dynamic>{
          'amount': amount,
          'transactionDate': transactionDate != null
              ? DateFormat('dd/MM/yy').format(transactionDate)
              : null,
          'cvNumber': cvNumber,
          'originTerminal': originTerminal,
          'allowPrintCurrentTransaction': allowPrintCurrentTransaction,
        },
      );

      if (result == null) {
        return null;
      }

      _transactionInProgress = false;

      return Transaction.fromJson(result);
    } catch (e) {
      _transactionInProgress = false;
      rethrow;
    }
  }

  /// Reprints the last transaction receipt via the native platform.
  /// Returns a [String] containing the reprint result, or `null` if the operation fails.
  /// Throws an exception if an error occurs during platform communication.
  /// This method is only available on Android.
  @override
  Future<String?> reprint() async {
    try {
      if (_transactionInProgress) {
        return null;
      }

      _transactionInProgress = true;

      final result =
          await methodChannel.invokeMethod<String>('reprintDeeplink');

      if (result == null) {
        return null;
      }

      _transactionInProgress = false;

      final transaction = Transaction.fromJson(result);

      return transaction.result;
    } catch (e) {
      _transactionInProgress = false;
      rethrow;
    }
  }

  /// Checks the status of a transaction via the native platform.
  /// Returns a [Transaction] containing the transaction status, or `null` if the operation fails.
  /// Throws an exception if an error occurs during platform communication.
  /// The [callerId] parameter is the transaction identifier.
  @override
  Future<Transaction?> checkStatus({required String callerId}) async {
    try {
      if (_transactionInProgress) {
        return null;
      }

      _transactionInProgress = true;

      final result = await methodChannel.invokeMethod<String>(
        'checkStatusDeeplink',
        <String, dynamic>{
          'callerId': callerId,
        },
      );

      if (result == null) {
        return null;
      }

      _transactionInProgress = false;

      return Transaction.fromJson(result);
    } catch (e) {
      _transactionInProgress = false;
      rethrow;
    }
  }
}
