import 'package:getnet_payments/getnet_pos_method_channel.dart';

abstract class GetnetPosPlatform {
  static GetnetPosPlatform _instance = MethodChannelGetnetPos();

  static GetnetPosPlatform get instance => _instance;

  static set instance(GetnetPosPlatform instance) {
    _instance = instance;
  }

  Future<String?> print();
}
