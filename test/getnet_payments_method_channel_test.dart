import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:getnet_payments/enums/payment_type_enum.dart';
import 'package:getnet_payments/getnet_deeplink_payments_method_channel.dart';

void main() {
  const MethodChannel channel = MethodChannel('getnet_deeplink_payments');
  late MethodChannelGetnetDeeplinkPayments methodChannelGetnetPayments;
  late List<MethodCall> log;

  setUp(() {
    methodChannelGetnetPayments = MethodChannelGetnetDeeplinkPayments();
    log = [];
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      log.add(methodCall);
      if (methodCall.method == 'payment') {
        return '{"result": "0", "callerId": "123"}';
      }
      return null;
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('should invoke method channel with correct arguments', () async {
    final result = await methodChannelGetnetPayments.payment(
      amount: 100.0,
      paymentType: PaymentTypeEnum.credit,
      callerId: '123',
      installment: 2,
    );

    expect(result, isNotNull);
    expect(result?.result, '0');
    expect(result?.callerId, '123');

    expect(log, hasLength(1));
    expect(log.first.method, 'payment');
    expect(log.first.arguments, {
      'amount': '000000100.00',
      'paymentType': PaymentTypeEnum.credit.index,
      'callerId': '123',
      'installment': 2,
    });
  });

  test('should handle null result gracefully', () async {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return null;
    });

    final result = await methodChannelGetnetPayments.payment(
      amount: 100.0,
      paymentType: PaymentTypeEnum.credit,
      callerId: '123',
    );

    expect(result, isNull);
  });

  test('should throw exception when method channel fails', () async {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      throw PlatformException(code: 'ERROR', message: 'Something went wrong');
    });

    expect(
      () => methodChannelGetnetPayments.payment(
        amount: 100.0,
        paymentType: PaymentTypeEnum.credit,
        callerId: '123',
      ),
      throwsA(isA<PlatformException>()),
    );
  });
}
