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

  /// Lê os 16 setores numa única aproximação. Uma autenticação que falha
  /// derruba a sessão do cartão, então ele é detectado de novo antes do próximo setor.
  static Future<String> diagnoseAllSectors() async {
    final key = parseKey(); // valida a chave antes de esperar o cartão
    final keyType = NfcStore.keyType.value;
    final nfc = GetnetPayments.nfc;
    final report = StringBuffer();
    var detected = false;
    try {
      for (var sector = 0; sector < 16; sector++) {
        if (!detected) {
          final uid = await nfc.detectCard();
          if (sector == 0) report.writeln('UID: $uid\n');
          detected = true;
        }
        report.writeln('Setor $sector');
        try {
          for (var block = sector * 4; block < sector * 4 + 4; block++) {
            final data =
                await nfc.sessionReadBlock(block, key: key, keyType: keyType);
            report.writeln('  ${block.toString().padLeft(2)}: ${toHex(data)}');
          }
        } on PlatformException catch (e) {
          report.writeln('  ERRO: [${e.code}] ${e.message ?? ''}');
          await nfc.powerOff();
          detected = false;
        }
      }
    } finally {
      if (detected) await nfc.powerOff();
    }
    return report.toString();
  }
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
