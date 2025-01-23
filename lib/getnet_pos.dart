import 'dart:async';

import 'package:getnet_payments/getnet_pos_platform_interface.dart';
import 'package:getnet_payments/models/pos/item_print_model.dart';

class GetnetPos {
  Future<String?> print(List<ItemPrintModel> items) async {
    try {
      // Delegate the payment process to the platform
      return GetnetPosPlatform.instance.print(items);
    } catch (e) {
      // Emit the error through the stream
      rethrow;
    }
  }
}
