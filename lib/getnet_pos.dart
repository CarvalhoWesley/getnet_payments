import 'dart:async';

import 'package:getnet_payments/getnet_pos_platform_interface.dart';

class GetnetPos {
  Future<String?> print() async {
    try {
      // Delegate the payment process to the platform
      return GetnetPosPlatform.instance.print();
    } catch (e) {
      // Emit the error through the stream
      rethrow;
    }
  }
}
