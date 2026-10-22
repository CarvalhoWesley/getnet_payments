import 'dart:typed_data';

import 'package:getnet_payments/enums/nfc/mifare_key_type_enum.dart';
import 'package:getnet_payments/getnet_nfc_method_channel.dart';

/// The `GetnetNfcPlatform` class defines the platform interface for the
/// Getnet NFC (Mifare Classic) functionality.
///
/// The default instance is `MethodChannelGetnetNfc`, but it can be
/// overridden for testing or to provide custom implementations.
abstract class GetnetNfcPlatform {
  static GetnetNfcPlatform _instance = MethodChannelGetnetNfc();

  /// Gets the current platform-specific implementation of `GetnetNfcPlatform`.
  static GetnetNfcPlatform get instance => _instance;

  /// Sets a custom platform-specific implementation of `GetnetNfcPlatform`.
  static set instance(GetnetNfcPlatform instance) {
    _instance = instance;
  }

  /// Waits for a card and returns its UID in uppercase hex.
  Future<String> readCardId();

  /// Waits for a card and reads the 16 bytes of [block].
  Future<Uint8List> readBlock({
    required int block,
    Uint8List? key,
    MifareKeyTypeEnum keyType = MifareKeyTypeEnum.typeA,
  });

  /// Waits for a card and writes up to 16 bytes into [block].
  Future<void> writeBlock({
    required int block,
    required Uint8List data,
    Uint8List? key,
    MifareKeyTypeEnum keyType = MifareKeyTypeEnum.typeA,
  });

  /// Diagnostic: returns everything the SDK returned when reading [block].
  Future<String> debugReadBlock({
    required int block,
    Uint8List? key,
    MifareKeyTypeEnum keyType = MifareKeyTypeEnum.typeA,
  });

  /// Cancels the wait for a card.
  Future<void> abort();

  /// Session: waits for a card, activates it and keeps it open. Returns the UID.
  Future<String> sessionDetectCard();

  /// Session: reads [block] of the card detected by [sessionDetectCard].
  Future<Uint8List> sessionReadBlock({
    required int block,
    Uint8List? key,
    MifareKeyTypeEnum keyType = MifareKeyTypeEnum.typeA,
  });

  /// Session: writes [data] into [block] of the card detected by [sessionDetectCard].
  Future<void> sessionWriteBlock({
    required int block,
    required Uint8List data,
    Uint8List? key,
    MifareKeyTypeEnum keyType = MifareKeyTypeEnum.typeA,
  });

  /// Session: releases the card.
  Future<void> sessionPowerOff();
}
