import 'package:flutter_test/flutter_test.dart';
import 'package:getnet_payments/enums/payment_type_enum.dart';
import 'package:getnet_payments/getnet_deeplink_payments_platform_interface.dart';
import 'package:getnet_payments/models/transaction.dart';
import 'package:mockito/mockito.dart';
import 'package:getnet_payments/getnet_deeplink_payments.dart';

class MockGetnetDeeplinkPaymentsPlatform extends Mock
    implements GetnetDeeplinkPaymentsPlatform {
  @override
  Future<Transaction?> payment({
    required double amount,
    required PaymentTypeEnum paymentType,
    required String callerId,
    int installment = 1,
  }) async {
    return super.noSuchMethod(
      Invocation.method(#payment, [amount, paymentType, callerId, installment]),
      returnValue: Transaction(result: '0', callerId: '123'),
    );
  }
}

void main() {
  group('GetnetDeeplinkPayments', () {
    late GetnetDeeplinkPayments getnetPayments;
    late MockGetnetDeeplinkPaymentsPlatform mockPlatform;

    setUp(() {
      mockPlatform = MockGetnetDeeplinkPaymentsPlatform();
      GetnetDeeplinkPaymentsPlatform.instance = mockPlatform;
      getnetPayments = GetnetDeeplinkPayments();
    });

    test('should throw assertion error when amount is less than or equal to 0',
        () {
      expect(
        () => getnetPayments.payment(
          amount: 0,
          paymentType: PaymentTypeEnum.credit,
          callerId: '123',
        ),
        throwsAssertionError,
      );
    });

    test('should throw assertion error when callerId is empty', () {
      expect(
        () => getnetPayments.payment(
          amount: 100.0,
          paymentType: PaymentTypeEnum.credit,
          callerId: '',
        ),
        throwsAssertionError,
      );
    });

    test('should call platform implementation with correct arguments',
        () async {
      final mockTransaction = Transaction(
        result: '0',
        callerId: '123',
      );

      when(mockPlatform.payment(
        amount: 100.0,
        paymentType: PaymentTypeEnum.credit,
        callerId: '123',
        installment: 2,
      )).thenAnswer((_) async => mockTransaction);

      final result = await getnetPayments.payment(
        amount: 100.0,
        paymentType: PaymentTypeEnum.credit,
        callerId: '123',
        installment: 2,
      );

      expect(result, isNotNull);
      expect(result?.result, '0');
      expect(result?.callerId, '123');
      verify(mockPlatform.payment(
        amount: 100.0,
        paymentType: PaymentTypeEnum.credit,
        callerId: '123',
        installment: 2,
      )).called(1);
    });
  });
}
