import 'dart:convert';
import 'dart:typed_data';

import 'package:getnet_payments/enums/nfc/mifare_key_type_enum.dart';
import 'package:getnet_payments/getnet_nfc_platform_interface.dart';

/// The `GetnetNfc` class provides a generic NFC API (Mifare Classic 1K/4K)
/// for Getnet POS devices.
///
/// Each method waits for a card to be tapped and does the whole operation
/// (activate, authenticate, read/write) in that single tap.
///
/// On failure a `PlatformException` is thrown with one of the codes:
/// `NO_SERVICE`, `NO_CARD`, `ABORTED`, `INVALID_BLOCK`, `INVALID_DATA`,
/// `AUTH_ERROR`, `READ_ERROR`, `WRITE_ERROR`, `WRITE_NOT_CONFIRMED`, `NFC_ERROR`.
///
/// Example:
/// ```dart
/// final uid = await GetnetPayments.nfc.readCardId();
/// await GetnetPayments.nfc.writeBlockText(4, 'Hello');
/// final text = await GetnetPayments.nfc.readBlockText(4);
/// ```
class GetnetNfc {
  /// Reads the card UID in uppercase hex (e.g. "17401059").
  Future<String> readCardId() {
    return GetnetNfcPlatform.instance.readCardId();
  }

  /// Reads the 16 bytes of [block] (0..255).
  ///
  /// [key] is the 6-byte sector key (default `FF FF FF FF FF FF`).
  Future<Uint8List> readBlock(
    int block, {
    Uint8List? key,
    MifareKeyTypeEnum keyType = MifareKeyTypeEnum.typeA,
  }) {
    assert(key == null || key.length == 6, 'A chave Mifare deve ter 6 bytes.');
    return GetnetNfcPlatform.instance
        .readBlock(block: block, key: key, keyType: keyType);
  }

  /// Writes up to 16 bytes into [block] (padded with zeros).
  ///
  /// Block 0 and sector trailers are refused. After writing, the block is read
  /// again in the same tap; if it does not match, a `PlatformException` with
  /// code `WRITE_NOT_CONFIRMED` is thrown.
  Future<void> writeBlock(
    int block,
    Uint8List data, {
    Uint8List? key,
    MifareKeyTypeEnum keyType = MifareKeyTypeEnum.typeA,
  }) {
    assert(data.length <= 16, 'O bloco Mifare aceita no máximo 16 bytes.');
    assert(key == null || key.length == 6, 'A chave Mifare deve ter 6 bytes.');
    return GetnetNfcPlatform.instance
        .writeBlock(block: block, data: data, key: key, keyType: keyType);
  }

  /// Reads [block] as UTF-8 text, removing trailing zeros.
  Future<String> readBlockText(
    int block, {
    Uint8List? key,
    MifareKeyTypeEnum keyType = MifareKeyTypeEnum.typeA,
  }) async {
    final data = await readBlock(block, key: key, keyType: keyType);
    var end = data.length;
    while (end > 0 && data[end - 1] == 0) {
      end--;
    }
    return utf8.decode(data.sublist(0, end), allowMalformed: true);
  }

  /// Writes [text] (UTF-8, max 16 bytes) into [block].
  Future<void> writeBlockText(
    int block,
    String text, {
    Uint8List? key,
    MifareKeyTypeEnum keyType = MifareKeyTypeEnum.typeA,
  }) {
    return writeBlock(block, Uint8List.fromList(utf8.encode(text)),
        key: key, keyType: keyType);
  }

  /// Diagnostic: returns a text with everything the SDK returned for [block].
  Future<String> debugReadBlock(
    int block, {
    Uint8List? key,
    MifareKeyTypeEnum keyType = MifareKeyTypeEnum.typeA,
  }) {
    return GetnetNfcPlatform.instance
        .debugReadBlock(block: block, key: key, keyType: keyType);
  }

  /// Cancels the wait for a card.
  Future<void> abort() {
    return GetnetNfcPlatform.instance.abort();
  }

  // ===== Sessão: várias operações numa única aproximação =====

  /// Waits for a card, activates it and keeps it open for [sessionReadBlock]
  /// and [sessionWriteBlock]. Returns the UID. Always finish with [powerOff].
  Future<String> detectCard() {
    return GetnetNfcPlatform.instance.sessionDetectCard();
  }

  /// Reads [block] of the card opened by [detectCard].
  Future<Uint8List> sessionReadBlock(
    int block, {
    Uint8List? key,
    MifareKeyTypeEnum keyType = MifareKeyTypeEnum.typeA,
  }) {
    return GetnetNfcPlatform.instance
        .sessionReadBlock(block: block, key: key, keyType: keyType);
  }

  /// Writes up to 16 bytes into [block] of the card opened by [detectCard].
  Future<void> sessionWriteBlock(
    int block,
    Uint8List data, {
    Uint8List? key,
    MifareKeyTypeEnum keyType = MifareKeyTypeEnum.typeA,
  }) {
    assert(data.length <= 16, 'O bloco Mifare aceita no máximo 16 bytes.');
    return GetnetNfcPlatform.instance
        .sessionWriteBlock(block: block, data: data, key: key, keyType: keyType);
  }

  /// Releases the card opened by [detectCard].
  Future<void> powerOff() {
    return GetnetNfcPlatform.instance.sessionPowerOff();
  }
}
