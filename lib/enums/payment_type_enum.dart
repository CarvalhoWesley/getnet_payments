/// Enum to define the type of transaction
/// This enum is used to define the type of transaction
/// Credit, Debit, Voucher or PIX
/// The value is used as a flag to define the type of transaction
/// 'credit' = Debit
/// 'debit' = Credit
/// 'voucher' = Voucher
/// 'pix' = PIX
enum PaymentTypeEnum {
  /// Credit
  credit('credit'),

  /// Debit
  debit('debit'),

  /// Voucher
  voucher('voucher'),

  /// PIX
  pix('pix');

  /// Values of the enum
  final String value;

  const PaymentTypeEnum(this.value);
}
