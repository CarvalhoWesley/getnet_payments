import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getnet_payments/getnet_payments.dart';

/// Chave Mifare compartilhada entre as abas NFC.
class NfcStore {
  NfcStore._();

  static final key = TextEditingController();
  static final keyType = ValueNotifier(MifareKeyTypeEnum.typeA);

  /// Chave digitada em hex; vazio usa a padrão (FF FF FF FF FF FF).
  static Uint8List? parseKey() {
    final hex = key.text.replaceAll(' ', '');
    if (hex.isEmpty) return null;
    if (hex.length != 12) throw 'A chave deve ter 6 bytes (12 caracteres hex)';
    return Uint8List.fromList(List.generate(
        6, (i) => int.parse(hex.substring(i * 2, i * 2 + 2), radix: 16)));
  }

  static String toHex(Uint8List data) => data
      .map((b) => b.toRadixString(16).padLeft(2, '0').toUpperCase())
      .join(' ');
}

/// Campos da chave do setor (hex + tipo A/B).
class NfcKeyFields extends StatelessWidget {
  const NfcKeyFields({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SizedBox(
            width: 200,
            child: TextField(
              controller: NfcStore.key,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9a-fA-F ]')),
              ],
              decoration: const InputDecoration(
                labelText: 'Chave hex (vazio = padrão)',
                isDense: true,
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: NfcStore.keyType,
            builder: (context, keyType, _) =>
                SegmentedButton<MifareKeyTypeEnum>(
              segments: const [
                ButtonSegment(
                    value: MifareKeyTypeEnum.typeA, label: Text('Chave A')),
                ButtonSegment(
                    value: MifareKeyTypeEnum.typeB, label: Text('Chave B')),
              ],
              selected: {keyType},
              onSelectionChanged: (v) => NfcStore.keyType.value = v.first,
            ),
          ),
        ],
      ),
    );
  }
}
