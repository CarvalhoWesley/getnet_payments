/// Enum to define the Mifare key type used to authenticate a sector.
/// [MifareKeyTypeEnum.typeA] = 0
/// [MifareKeyTypeEnum.typeB] = 1
enum MifareKeyTypeEnum {
  /// Key A
  typeA(0),

  /// Key B
  typeB(1);

  /// Values of the enum
  final int value;

  const MifareKeyTypeEnum(this.value);
}
