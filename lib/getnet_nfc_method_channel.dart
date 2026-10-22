import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:getnet_payments/enums/nfc/mifare_key_type_enum.dart';
import 'package:getnet_payments/getnet_nfc_platform_interface.dart';

/// The `MethodChannelGetnetNfc` class implements [GetnetNfcPlatform]
/// using the `getnet_payments` method channel.
class MethodChannelGetnetNfc extends GetnetNfcPlatform {
  /// The [MethodChannel] used for communication with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('getnet_payments');

  @override
  Future<String> readCardId() async {
    final id = await methodChannel.invokeMethod<String>('nfcReadCardId');
    return id!;
  }

  @override
  Future<Uint8List> readBlock({
    required int block,
    Uint8List? key,
    MifareKeyTypeEnum keyType = MifareKeyTypeEnum.typeA,
  }) async {
    final data = await methodChannel.invokeMethod<Uint8List>(
      'nfcReadBlock',
      {'block': block, 'key': key, 'keyType': keyType.value},
    );
    return data!;
  }

  @override
  Future<void> writeBlock({
    required int block,
    required Uint8List data,
    Uint8List? key,
    MifareKeyTypeEnum keyType = MifareKeyTypeEnum.typeA,
  }) async {
    await methodChannel.invokeMethod<bool>(
      'nfcWriteBlock',
      {'block': block, 'data': data, 'key': key, 'keyType': keyType.value},
    );
  }

  @override
  Future<String> debugReadBlock({
    required int block,
    Uint8List? key,
    MifareKeyTypeEnum keyType = MifareKeyTypeEnum.typeA,
  }) async {
    final result = await methodChannel.invokeMethod<String>(
      'nfcDebugReadBlock',
      {'block': block, 'key': key, 'keyType': keyType.value},
    );
    return result ?? '';
  }

  @override
  Future<void> abort() async {
    await methodChannel.invokeMethod<bool>('nfcAbort');
  }

  @override
  Future<String> sessionDetectCard() async {
    final uid = await methodChannel.invokeMethod<String>('nfcSessionDetectCard');
    return uid ?? '';
  }

  @override
  Future<Uint8List> sessionReadBlock({
    required int block,
    Uint8List? key,
    MifareKeyTypeEnum keyType = MifareKeyTypeEnum.typeA,
  }) async {
    final data = await methodChannel.invokeMethod<Uint8List>(
      'nfcSessionReadBlock',
      {'block': block, 'key': key, 'keyType': keyType.value},
    );
    return data!;
  }

  @override
  Future<void> sessionWriteBlock({
    required int block,
    required Uint8List data,
    Uint8List? key,
    MifareKeyTypeEnum keyType = MifareKeyTypeEnum.typeA,
  }) async {
    await methodChannel.invokeMethod<bool>(
      'nfcSessionWriteBlock',
      {'block': block, 'data': data, 'key': key, 'keyType': keyType.value},
    );
  }

  @override
  Future<void> sessionPowerOff() async {
    await methodChannel.invokeMethod<bool>('nfcSessionPowerOff');
  }
}
