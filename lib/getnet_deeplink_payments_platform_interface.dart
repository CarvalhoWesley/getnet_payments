import 'package:getnet_payments/enums/payment_type_enum.dart';
import 'package:getnet_payments/getnet_deeplink_payments_method_channel.dart';
import 'package:getnet_payments/models/transaction.dart';

abstract class GetnetDeeplinkPaymentsPlatform {
  static GetnetDeeplinkPaymentsPlatform _instance =
      MethodChannelGetnetDeeplinkPayments();

  static GetnetDeeplinkPaymentsPlatform get instance => _instance;

  static set instance(GetnetDeeplinkPaymentsPlatform instance) {
    _instance = instance;
  }

  Future<Transaction?> payment({
    required double amount,
    required PaymentTypeEnum paymentType,
    required String callerId,
    int installment,
  });

  Future<Transaction?> refund({
    required double amount,
    DateTime? transactionDate,
    String? cvNumber,
    String? originalTerminal,
  });
}
