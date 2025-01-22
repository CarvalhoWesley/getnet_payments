import 'package:getnet_payments/getnet_deeplink_payments.dart';

/// The [GetnetPayments] class serves as a facade for accessing and
/// managing instances of [GetnetDeeplinkPayments].
///
/// This class provides a static interface for retrieving and optionally
/// replacing the [GetnetDeeplinkPayments] instance, enabling flexibility
/// in testing or extending functionality.
class GetnetPayments {
  static GetnetDeeplinkPayments _deeplink = GetnetDeeplinkPayments();

  /// Exposes the instance of the `GetnetDeeplinkPayments` class.
  ///
  /// This allows access to the payment and refund functionalities
  /// implemented in [GetnetDeeplinkPayments].
  ///
  /// Example:
  /// ```dart
  /// final deeplink = GetnetPayments.deeplink;
  /// ```
  static GetnetDeeplinkPayments get deeplink => _deeplink;

  /// Replaces the instance of `GetnetDeeplinkPayments` if needed.
  ///
  /// This method can be used to provide a mock or alternative implementation
  /// for testing or extending functionality.
  ///
  /// Example:
  /// ```dart
  /// GetnetPayments.deeplink = MockGetnetDeeplinkPayments();
  /// ```
  ///
  /// [instance] must be a valid instance of [GetnetDeeplinkPayments].
  static set deeplink(GetnetDeeplinkPayments instance) {
    _deeplink = instance;
  }
}
