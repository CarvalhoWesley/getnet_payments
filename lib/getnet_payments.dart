import 'package:getnet_payments/getnet_deeplink_payments.dart';

class GetnetPayments {
  static GetnetDeeplinkPayments _deeplink = GetnetDeeplinkPayments();

  /// Expondo a instância da classe `GetnetDeeplinkPayments`.
  static GetnetDeeplinkPayments get deeplink => _deeplink;

  /// Permite substituir a instância de `GetnetDeeplinkPayments` caso necessário.
  static set deeplink(GetnetDeeplinkPayments instance) {
    _deeplink = instance;
  }
}
