import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:getnet_payments/getnet_pos_platform_interface.dart';
import 'package:getnet_payments/models/pos/item_print_model.dart';

class MethodChannelGetnetPos extends GetnetPosPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('getnet_payments');

  bool _printInProgress = false;

  @override
  Future<String?> print(List<ItemPrintModel> items) async {
    try {
      if (_printInProgress) {
        return null;
      }

      if (items.isEmpty) {
        return null;
      }

      _printInProgress = true;

      final itemsMaps =
          items.map((instruction) => instruction.toMap()).toList();

      final result =
          await methodChannel.invokeMethod<String?>('print', itemsMaps);

      _printInProgress = false;
      return result;
    } catch (e) {
      _printInProgress = false;
      rethrow;
    }
  }
}
