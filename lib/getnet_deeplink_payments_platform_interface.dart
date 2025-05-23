import 'package:getnet_payments/enums/transaction/payment_type_enum.dart';
import 'package:getnet_payments/getnet_deeplink_payments_method_channel.dart';
import 'package:getnet_payments/models/transaction/transaction.dart';

/// The [GetnetDeeplinkPaymentsPlatform] abstract class defines the contract
/// for platform-specific implementations of Getnet deeplink payments.
///
/// This class acts as an interface, delegating calls to a specific platform
/// implementation. By default, the [MethodChannelGetnetDeeplinkPayments]
/// implementation is used.
///
/// Developers can override the platform implementation by setting
/// [GetnetDeeplinkPaymentsPlatform.instance] to a custom implementation.
abstract class GetnetDeeplinkPaymentsPlatform {
  /// The current instance of [GetnetDeeplinkPaymentsPlatform].
  ///
  /// By default, this is set to [MethodChannelGetnetDeeplinkPayments].
  static GetnetDeeplinkPaymentsPlatform _instance =
      MethodChannelGetnetDeeplinkPayments();

  /// Gets the current platform-specific implementation instance.
  static GetnetDeeplinkPaymentsPlatform get instance => _instance;

  /// Sets the platform-specific implementation instance.
  ///
  /// This allows for custom implementations, such as mocks for testing.
  ///
  /// Example:
  /// ```dart
  /// GetnetDeeplinkPaymentsPlatform.instance = MockGetnetDeeplinkPaymentsPlatform();
  /// ```
  static set instance(GetnetDeeplinkPaymentsPlatform instance) {
    _instance = instance;
  }

  /// Processes a payment with the provided parameters.
  ///
  /// [amount] is the payment amount and must be greater than zero.
  /// [paymentType] specifies the type of payment (credit, debit, voucher or pix).
  /// [callerId] is the transaction identifier and cannot be empty.
  /// [installments] specifies the number of installments.
  /// [creditType] (optional) specifies the credit type for credit payments (creditMerchant or creditIssuer).
  /// [allowPrintCurrentTransaction] (optional) specifies whether to allow printing the current transaction.
  /// Returns a [Transaction] object containing transaction details, or
  /// `null` if the transaction fails.
  ///
  /// This method must be implemented by a platform-specific class.
  Future<Transaction?> payment({
    required double amount,
    required PaymentTypeEnum paymentType,
    required String callerId,
    int installments,
    String? creditType,
    bool? allowPrintCurrentTransaction,
  });

  /// Processes a refund for a transaction with the provided parameters.
  ///
  /// [amount] is the refund amount and must be greater than zero.
  /// [transactionDate] (optional) specifies the date of the original transaction.
  /// [cvNumber] (optional) is the control number of the transaction (CV).
  /// [originTerminal] (optional) identifies the origin terminal.
  /// [allowPrintCurrentTransaction] (optional) specifies whether to allow printing the current transaction.
  ///
  /// Returns a [Transaction] object containing refund details, or
  /// `null` if the operation fails.
  ///
  /// This method must be implemented by a platform-specific class.
  Future<Transaction?> refund({
    required double amount,
    DateTime? transactionDate,
    String? cvNumber,
    String? originTerminal,
    bool? allowPrintCurrentTransaction,
  });

  /// Reprints a last transaction receipt.
  /// Returns a [String] containing the reprint result, or `null` if the operation fails.
  Future<String?> reprint();

  /// Checks the status of a transaction via the native platform.
  /// Returns a [Transaction] containing the transaction status, or `null` if the operation fails.
  /// Throws an exception if an error occurs during platform communication.
  /// The [callerId] parameter is the transaction identifier.
  Future<Transaction?> checkStatus({required String callerId});
}
