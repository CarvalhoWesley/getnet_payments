import 'package:getnet_payments/getnet_pos_platform_interface.dart';
import 'package:getnet_payments/models/pos/item_print_model.dart';

/// The `GetnetPos` class provides a high-level interface for interacting
/// with the Getnet POS functionality.
///
/// This class delegates platform-specific operations to the appropriate
/// platform interface implementation (`GetnetPosPlatform`).
///
/// Example usage:
/// ```dart
/// final getnetPos = GetnetPos();
/// final items = [
///   ItemPrintModel.text(
///     content: "TEXTO CENTRALIZADO",
///     align: Align.center,
///     fontFormat: FontFormat.medium,
///   ),
///   ItemPrintModel.qrcode(
///     content: "https://example.com",
///     align: Align.center,
///   ),
/// ];
///
/// final result = await getnetPos.print(items);
/// print(result); // Prints: "Printed successfully" or an error message
/// ```
class GetnetPos {
  /// Sends a list of print instructions to the POS device for processing.
  ///
  /// This method takes a list of `ItemPrintModel` objects, which describe
  /// the individual instructions (text, QR code, barcode, etc.) for printing.
  ///
  /// The actual printing process is delegated to the platform-specific
  /// implementation of the `GetnetPosPlatform`.
  ///
  /// If an error occurs during printing, the error is rethrown.
  ///
  /// Example:
  /// ```dart
  /// final items = [
  ///   ItemPrintModel.text(
  ///     content: "TEXTO CENTRALIZADO",
  ///     align: Align.center,
  ///     fontFormat: FontFormat.medium,
  ///   ),
  ///   ItemPrintModel.qrcode(
  ///     content: "https://example.com",
  ///     align: Align.center,
  ///   ),
  /// ];
  ///
  /// final result = await getnetPos.print(items);
  /// print(result); // "Printed successfully"
  /// ```
  ///
  /// [items] - A list of `ItemPrintModel` objects describing the print instructions.
  ///
  /// Returns:
  /// - A `Future<String?>` that resolves to a success message, or null if the operation fails.
  ///
  /// Throws:
  /// - Any error encountered during the printing process.
  Future<String?> print(List<ItemPrintModel> items) async {
    try {
      // Delegate the printing process to the platform
      return GetnetPosPlatform.instance.print(items);
    } catch (e) {
      // Emit the error through the stream
      rethrow;
    }
  }
}
