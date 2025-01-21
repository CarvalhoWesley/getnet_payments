import 'package:getnet_payments/enums/payment_type_enum.dart';
import 'package:getnet_payments/getnet_deeplink_payments_method_channel.dart';
import 'package:getnet_payments/models/transaction.dart';

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
  /// [paymentType] specifies the type of payment (credit or debit).
  /// [callerId] is the transaction identifier and cannot be empty.
  /// [installment] specifies the number of installments (between 1 and 12).
  ///
  /// Returns a [Transaction] object containing transaction details, or
  /// `null` if the transaction fails.
  ///
  /// This method must be implemented by a platform-specific class.
  Future<Transaction?> payment({
    required double amount,
    required PaymentTypeEnum paymentType,
    required String callerId,
    int installment,
  });

  /// Processes a refund for a transaction with the provided parameters.
  ///
  /// [amount] is the refund amount and must be greater than zero.
  /// [transactionDate] (optional) specifies the date of the original transaction.
  /// [cvNumber] (optional) is the control number of the transaction (CV).
  /// [originTerminal] (optional) identifies the origin terminal.
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
  });
}
