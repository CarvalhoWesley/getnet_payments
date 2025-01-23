import 'package:getnet_payments/getnet_pos_method_channel.dart';
import 'package:getnet_payments/models/pos/item_print_model.dart';

abstract class GetnetPosPlatform {
  static GetnetPosPlatform _instance = MethodChannelGetnetPos();

  static GetnetPosPlatform get instance => _instance;

  static set instance(GetnetPosPlatform instance) {
    _instance = instance;
  }

  Future<String?> print(List<ItemPrintModel> items);
}
