import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:getnet_payments/getnet_pos_platform_interface.dart';

class MethodChannelGetnetPos extends GetnetPosPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('getnet_payments');

  bool _printInProgress = false;

  @override
  Future<String?> print() async {
    try {
      if (_printInProgress) {
        return null;
      }

      _printInProgress = true;

      final result = await methodChannel.invokeMethod<String?>(
        'print',
        <String, dynamic>{
          "instructions": [
            {
              "type": "text",
              "align": "CENTER",
              "fontFormat": "SMALL",
              "content": "TEXTO SMALL CENTRALIZADO",
            },
            {
              "type": "text",
              "align": "CENTER",
              "fontFormat": "MEDIUM",
              "content": "TEXTO MEDIUM CENTRALIZADO",
            },
            {
              "type": "text",
              "align": "CENTER",
              "fontFormat": "LARGE",
              "content": "TEXTO LARGE CENTRALIZADO"
            },
            {
              "type": "qrcode",
              "align": "CENTER",
              "content": "https://example.com",
              "height": 200
            },
            {"type": "barcode", "align": "RIGHT", "content": "123456789012"},
            {"type": "linewrap", "lines": 2},
          ]
        },
      );
      _printInProgress = false;
      return result;
    } catch (e) {
      _printInProgress = false;
      rethrow;
    }
  }
}
