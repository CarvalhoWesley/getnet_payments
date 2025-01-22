/// Transaction Result Enum
/// This enum is used to define the transaction result
/// of the transaction
/// '0' = Success
/// '1' = Denied
/// '2' = Cancelled
/// '3' = Failed
/// '4' = Unknown
/// '5' = Pending
enum TransactionResultEnum {
  /// Sucess
  success('0'),

  /// Denied
  denied('1'),

  /// Cancelled
  cancelled('2'),

  /// Failed
  failed('3'),

  /// Unknown
  unknown('4'),

  /// pending
  pending('5');

  /// Values of the enum
  final String value;

  const TransactionResultEnum(this.value);
}
