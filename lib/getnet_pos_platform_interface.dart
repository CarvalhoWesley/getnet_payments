import 'package:getnet_payments/getnet_pos_method_channel.dart';
import 'package:getnet_payments/models/pos/item_print_model.dart';

/// The `GetnetPosPlatform` class defines the platform interface for interacting
/// with the Getnet POS functionality.
///
/// This is an abstract class that serves as the base for platform-specific
/// implementations, such as `MethodChannelGetnetPos`.
///
/// The default instance is set to `MethodChannelGetnetPos`, but it can be
/// overridden for testing or to provide custom implementations.
///
/// Example usage:
/// ```dart
/// // Use the default instance
/// final result = await GetnetPosPlatform.instance.print(items);
///
/// // Override with a mock implementation for testing
/// GetnetPosPlatform.instance = MockGetnetPosPlatform();
/// ```
abstract class GetnetPosPlatform {
  /// The current platform-specific implementation of `GetnetPosPlatform`.
  ///
  /// By default, this is set to an instance of `MethodChannelGetnetPos`.
  static GetnetPosPlatform _instance = MethodChannelGetnetPos();

  /// Gets the current platform-specific implementation of `GetnetPosPlatform`.
  static GetnetPosPlatform get instance => _instance;

  /// Sets a custom platform-specific implementation of `GetnetPosPlatform`.
  ///
  /// This is useful for testing or for providing alternative implementations.
  static set instance(GetnetPosPlatform instance) {
    _instance = instance;
  }

  /// Sends a list of print instructions to the platform-specific implementation.
  ///
  /// This method must be implemented by platform-specific classes, such as
  /// `MethodChannelGetnetPos`, to handle the actual interaction with the POS device.
  ///
  /// [items] - A list of `ItemPrintModel` objects describing the print instructions.
  ///
  /// Returns:
  /// - A `Future<String?>` that resolves to a success message, or null if the operation fails.
  ///
  /// Example:
  /// ```dart
  /// final items = [
  ///   ItemPrintModel.text(
  ///     content: "TEXTO CENTRALIZADO",
  ///     align: Align.center,
  ///     fontFormat: FontFormat.medium,
  ///   ),
  /// ];
  ///
  /// final result = await GetnetPosPlatform.instance.print(items);
  /// print(result); // "Printed successfully"
  /// ```
  ///
  /// Throws:
  /// - Any error encountered during the printing process.
  Future<String?> print(List<ItemPrintModel> items);
}
