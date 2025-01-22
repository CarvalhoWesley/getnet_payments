import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:getnet_payments/enums/payment_type_enum.dart';
import 'package:getnet_payments/getnet_deeplink_payments_method_channel.dart';
import 'package:getnet_payments/models/transaction.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized(); // Inicializa o binding

  const MethodChannel channel = MethodChannel('getnet_payments');
  late MethodChannelGetnetDeeplinkPayments methodChannelGetnetPayments;
  late List<MethodCall> log;

  setUp(() {
    methodChannelGetnetPayments = MethodChannelGetnetDeeplinkPayments();
    log = [];

    // Configurando o mock para o MethodChannel
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      log.add(methodCall);
      if (methodCall.method == 'paymentDeeplink') {
        return '{"result": "0", "callerId": "123"}'; // Mock de resposta
      }
      return null;
    });
  });

  tearDown(() {
    // Limpando o mock do MethodChannel
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('should invoke method channel with correct arguments', () async {
    final result = await methodChannelGetnetPayments.payment(
      amount: 100.0,
      paymentType: PaymentTypeEnum.credit,
      callerId: '123',
      installments: 1,
    );

    // Verificando o resultado
    expect(result, isNotNull);
    expect(result, isA<Transaction>());
    expect(result?.result, '0');
    expect(result?.callerId, '123');

    // Verificando as chamadas do MethodChannel
    expect(log, hasLength(1));
    expect(log.first.method, 'paymentDeeplink');
    expect(log.first.arguments, {
      'amount': 100.0,
      'paymentType': PaymentTypeEnum.credit.value,
      'callerId': '123',
      'installment': 1,
    });
  });

  test('should handle null result gracefully', () async {
    // Alterando o mock para retornar null
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      return null;
    });

    final result = await methodChannelGetnetPayments.payment(
      amount: 100.0,
      paymentType: PaymentTypeEnum.credit,
      callerId: '123',
    );

    // Verificando que o resultado é nulo
    expect(result, isNull);
  });

  test('should throw exception when method channel fails', () async {
    // Alterando o mock para lançar uma exceção
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      throw PlatformException(code: 'ERROR', message: 'Something went wrong');
    });

    // Verificando que a exceção é lançada
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
