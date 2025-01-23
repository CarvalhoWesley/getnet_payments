import 'package:getnet_payments/enums/pos/align_mode_enum.dart';
import 'package:getnet_payments/enums/pos/font_format_enum.dart';

class ItemPrintModel {
  final String type;
  final AlignModeEnum? align;
  final FontFormatEnum? fontFormat;
  final String? content;
  final int? height;
  final int? lines;

  ItemPrintModel.text({
    required this.content,
    this.align = AlignModeEnum.left,
    this.fontFormat = FontFormatEnum.medium,
  })  : type = "text",
        height = null,
        lines = null;

  ItemPrintModel.qrcode({
    required this.content,
    this.align = AlignModeEnum.center,
    this.height = 200,
  })  : type = "qrcode",
        fontFormat = null,
        lines = null;

  ItemPrintModel.barcode({
    required this.content,
    this.align = AlignModeEnum.center,
  })  : type = "barcode",
        fontFormat = null,
        height = null,
        lines = null;

  ItemPrintModel.image({
    required this.content,
    this.align = AlignModeEnum.center,
    this.height = 200,
  })  : type = "image",
        fontFormat = null,
        lines = null;

  ItemPrintModel.linewrap({this.lines = 1})
      : type = "linewrap",
        align = null,
        fontFormat = null,
        content = null,
        height = null;

  Map<String, dynamic> toMap() {
    return {
      "type": type,
      "align": align?.value, // Pega o value do enum Align
      "fontFormat": fontFormat?.value, // Pega o value do enum FontFormat
      "content": content,
      "height": height,
      "lines": lines,
    };
  }
}
