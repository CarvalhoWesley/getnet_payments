import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:getnet_payments/getnet_nfc.dart';
import 'package:getnet_payments/getnet_nfc_method_channel.dart';
import 'package:getnet_payments/getnet_nfc_platform_interface.dart';
import 'package:getnet_payments/enums/nfc/mifare_key_type_enum.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final platform = MethodChannelGetnetNfc();
  final calls = <MethodCall>[];
  final block = Uint8List.fromList([72, 105, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]);

  setUp(() {
    calls.clear();
    GetnetNfcPlatform.instance = platform;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(platform.methodChannel, (call) async {
      calls.add(call);
      switch (call.method) {
        case 'nfcReadCardId':
          return '17401059';
        case 'nfcReadBlock':
          return block;
        case 'nfcDebugReadBlock':
          return 'raw=[4869]';
        default:
          return true;
      }
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(platform.methodChannel, null);
  });

  test('readCardId returns the UID', () async {
    expect(await GetnetNfc().readCardId(), '17401059');
    expect(calls.single.method, 'nfcReadCardId');
  });

  test('readBlockText decodes and strips trailing zeros', () async {
    expect(await GetnetNfc().readBlockText(4), 'Hi');
    expect(calls.single.arguments,
        {'block': 4, 'key': null, 'keyType': MifareKeyTypeEnum.typeA.value});
  });

  test('writeBlockText sends UTF-8 bytes, key and key type', () async {
    final key = Uint8List.fromList(List.filled(6, 0xAA));
    await GetnetNfc()
        .writeBlockText(5, 'Hi', key: key, keyType: MifareKeyTypeEnum.typeB);

    final args = calls.single.arguments as Map;
    expect(calls.single.method, 'nfcWriteBlock');
    expect(args['block'], 5);
    expect(args['data'], Uint8List.fromList([72, 105]));
    expect(args['key'], key);
    expect(args['keyType'], 1);
  });

  test('debugReadBlock and abort call the channel', () async {
    expect(await GetnetNfc().debugReadBlock(1), 'raw=[4869]');
    await GetnetNfc().abort();
    expect(calls.map((c) => c.method), ['nfcDebugReadBlock', 'nfcAbort']);
  });

  test('errors are propagated as PlatformException', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(platform.methodChannel, (call) async {
      throw PlatformException(code: 'NO_CARD');
    });
    expect(GetnetNfc().readCardId(),
        throwsA(isA<PlatformException>().having((e) => e.code, 'code', 'NO_CARD')));
  });
}
