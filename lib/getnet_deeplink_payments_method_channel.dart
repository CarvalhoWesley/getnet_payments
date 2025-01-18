import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:getnet_payments/enums/payment_type_enum.dart';
import 'package:getnet_payments/models/transaction.dart';

import 'getnet_deeplink_payments_platform_interface.dart';

class MethodChannelGetnetDeeplinkPayments
    extends GetnetDeeplinkPaymentsPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('getnet_payments');

  bool _paymentInProgress = false;

  @override
  Future<Transaction?> payment({
    required double amount,
    required PaymentTypeEnum paymentType,
    required String callerId,
    int installment = 1,
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
          'installment': installment,
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
