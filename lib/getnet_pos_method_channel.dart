import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:getnet_payments/getnet_pos_platform_interface.dart';
import 'package:getnet_payments/models/pos/item_print_model.dart';

/// The `MethodChannelGetnetPos` class provides a platform-specific implementation
/// of the `GetnetPosPlatform` interface using method channels.
///
/// This class communicates with the native platform code via a `MethodChannel`
/// to handle print operations.
///
/// Example usage:
/// ```dart
/// final methodChannelGetnetPos = MethodChannelGetnetPos();
/// final items = [
///   ItemPrintModel.text(
///     content: "TEXTO CENTRALIZADO",
///     align: Align.center,
///     fontFormat: FontFormat.medium,
///   ),
/// ];
///
/// final result = await methodChannelGetnetPos.print(items);
/// print(result); // "Printed successfully"
/// ```
class MethodChannelGetnetPos extends GetnetPosPlatform {
  /// The [MethodChannel] used for communication with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('getnet_payments');

  /// Tracks whether a print operation is currently in progress.
  ///
  /// This prevents multiple concurrent print operations.
  bool _printInProgress = false;

  /// Sends a list of print instructions to the native platform via the method channel.
  ///
  /// The [items] parameter contains a list of `ItemPrintModel` objects representing
  /// the instructions for the POS device.
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
  /// final result = await methodChannelGetnetPos.print(items);
  /// print(result); // "Printed successfully"
  /// ```
  ///
  /// [items] - A list of `ItemPrintModel` objects describing the print instructions.
  ///
  /// Returns:
  /// - A `Future<String?>` that resolves to a success message or null if the operation fails.
  ///
  /// Throws:
  /// - Any error encountered during the printing process.
  @override
  Future<String?> print(List<ItemPrintModel> items) async {
    try {
      if (_printInProgress) {
        return null; // Prevent concurrent print operations
      }

      if (items.isEmpty) {
        return null; // No instructions provided
      }

      _printInProgress = true;

      // Convert the items to a list of maps for platform communication
      final itemsMaps =
          items.map((instruction) => instruction.toMap()).toList();

      // Invoke the native method
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
