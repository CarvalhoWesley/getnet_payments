import 'package:getnet_payments/getnet_deeplink_payments.dart';
import 'package:getnet_payments/getnet_pos.dart';

export 'enums/transaction/payment_type_enum.dart';
export 'enums/transaction/transaction_result_enum.dart';
export 'enums/pos/align_mode_enum.dart';
export 'enums/pos/font_format_enum.dart';
export 'models/transaction/automation_slip.dart';
export 'models/transaction/mandatory_all_receipts_fields.dart';
export 'models/transaction/mandatory_client_fields.dart';
export 'models/transaction/mandatory_ec_fields.dart';
export 'models/transaction/transaction.dart';
export 'models/pos/item_print_model.dart';

/// The [GetnetPayments] class serves as a facade for accessing and
/// managing instances of [GetnetDeeplinkPayments].
///
/// This class provides a static interface for retrieving and optionally
/// replacing the [GetnetDeeplinkPayments] instance, enabling flexibility
/// in testing or extending functionality.
class GetnetPayments {
  static GetnetDeeplinkPayments _deeplink = GetnetDeeplinkPayments();
  static GetnetPos _pos = GetnetPos();

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

  /// Exposes the instance of the `GetnetPos` class.
  ///
  /// This allows access to the print functionality implemented in [GetnetPos].
  ///
  /// Example:
  /// ```dart
  /// final pos = GetnetPayments.pos;
  /// ```
  ///
  static GetnetPos get pos => _pos;

  /// Replaces the instance of `GetnetPos` if needed.
  ///
  /// This method can be used to provide a mock or alternative implementation
  /// for testing or extending functionality.
  ///
  /// Example:
  /// ```dart
  /// GetnetPayments.pos = MockGetnetPos();
  /// ```
  ///
  /// [instance] must be a valid instance of [GetnetPos].
  static set pos(GetnetPos instance) {
    _pos = instance;
  }
}
