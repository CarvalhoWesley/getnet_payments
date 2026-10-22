import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:getnet_payments/getnet_payments.dart';

/// Itens de exemplo usados nos testes de impressão.
Future<List<ItemPrintModel>> samplePrintItems({bool withImage = true}) async {
  final items = [
    ItemPrintModel.text(
      content: 'TEXTO SMALL CENTRALIZADO',
      align: AlignModeEnum.center,
      fontFormat: FontFormatEnum.small,
    ),
    ItemPrintModel.text(
      content: 'TEXTO MEDIUM CENTRALIZADO',
      align: AlignModeEnum.center,
      fontFormat: FontFormatEnum.medium,
    ),
    ItemPrintModel.text(
      content: 'TEXTO LARGE CENTRALIZADO',
      align: AlignModeEnum.center,
      fontFormat: FontFormatEnum.large,
    ),
    ItemPrintModel.qrcode(
      content: 'https://example.com',
      align: AlignModeEnum.center,
      height: 200,
    ),
    ItemPrintModel.linewrap(lines: 1),
    ItemPrintModel.barcode(
      content: '123456789012',
      align: AlignModeEnum.center,
    ),
  ];
  if (withImage) {
    final logo = await rootBundle.load('assets/images/logo.jpg');
    items.add(ItemPrintModel.image(
      content: base64Encode(
          logo.buffer.asUint8List(logo.offsetInBytes, logo.lengthInBytes)),
      align: AlignModeEnum.center,
    ));
  }
  items.add(ItemPrintModel.linewrap(lines: 2));
  return items;
}
