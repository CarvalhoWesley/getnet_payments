import 'package:flutter_test/flutter_test.dart';
import 'package:getnet_payments/getnet_payments.dart';
import 'package:getnet_payments/getnet_deeplink_payments_platform_interface.dart';
import 'package:getnet_payments/getnet_deeplink_payments_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockGetnetPaymentsPlatform
    with MockPlatformInterfaceMixin
    implements GetnetDeeplinkPaymentsPlatform {
  @override
  Future<String?> payment() => Future.value('42');
}

void main() {
  final GetnetDeeplinkPaymentsPlatform initialPlatform =
      GetnetDeeplinkPaymentsPlatform.instance;

  test('$MethodChannelGetnetDeeplinkPayments is the default instance', () {
    expect(
        initialPlatform, isInstanceOf<MethodChannelGetnetDeeplinkPayments>());
  });

  test('getPlatformVersion', () async {
    MockGetnetPaymentsPlatform fakePlatform = MockGetnetPaymentsPlatform();
    GetnetDeeplinkPaymentsPlatform.instance = fakePlatform;

    expect(await GetnetPayments.deeplink.payment(), '42');
  });
}
