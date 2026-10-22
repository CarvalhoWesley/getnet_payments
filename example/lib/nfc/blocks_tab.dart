import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getnet_payments/getnet_payments.dart';

import '../core/app_log.dart';
import '../core/ui.dart';
import 'nfc_store.dart';

/// Leitura e gravação genérica de blocos Mifare Classic.
class NfcBlocksTab extends StatefulWidget {
  const NfcBlocksTab({super.key});

  @override
  State<NfcBlocksTab> createState() => _NfcBlocksTabState();
}

class _NfcBlocksTabState extends State<NfcBlocksTab>
    with ActionRunner, AutomaticKeepAliveClientMixin {
  final _block = TextEditingController(text: '16');
  final _text = TextEditingController(text: 'teste');

  @override
  LogSource get logSource => LogSource.nfc;

  @override
  bool get wantKeepAlive => true;

  int get _blockNum {
    final n = int.tryParse(_block.text);
    if (n == null) throw 'Informe o número do bloco';
    return n;
  }

  MifareKeyTypeEnum get _keyType => NfcStore.keyType.value;

  @override
  void dispose() {
    _block.dispose();
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final enabled = !busy;
    final nfc = GetnetPayments.nfc;
    return ActionPage(busy: busy, children: [
      const Section(
        title: 'Chave do setor',
        children: [NfcKeyFields()],
      ),
      Section(
        title: 'Ler / gravar bloco',
        hint: 'Blocos 0-63 (1K) ou 0-255 (4K). Evite 1-12 (cartão de evento). Bloco 0 e trailers '
            '(3, 7, 11...) não aceitam gravação.',
        children: [
          FieldWrap(children: [
            AppField(
                controller: _block,
                label: 'Bloco (0-255)',
                numeric: true,
                width: 120),
            AppField(
                controller: _text, label: 'Texto (máx. 16 bytes)', width: 200),
          ]),
          ActionWrap(children: [
            ActionButton(
              label: 'Ler texto',
              icon: Icons.text_fields,
              primary: true,
              onPressed: enabled
                  ? () => run(
                      'Ler bloco ${_block.text}',
                      () async =>
                          '"${await nfc.readBlockText(_blockNum, key: NfcStore.parseKey(), keyType: _keyType)}"')
                  : null,
            ),
            ActionButton(
              label: 'Ler bytes',
              onPressed: enabled
                  ? () => run(
                      'Ler bloco ${_block.text}',
                      () async => NfcStore.toHex(await nfc.readBlock(_blockNum,
                          key: NfcStore.parseKey(), keyType: _keyType)))
                  : null,
            ),
            ActionButton(
              label: 'Gravar texto',
              icon: Icons.save,
              onPressed: enabled
                  ? () => run('Gravar bloco ${_block.text}', () async {
                        // O plugin relê o bloco na mesma aproximação e falha (WRITE_NOT_CONFIRMED) se não bater
                        await nfc.writeBlockText(_blockNum, _text.text,
                            key: NfcStore.parseKey(), keyType: _keyType);
                        final written = Uint8List.fromList(
                            [...utf8.encode(_text.text), ...List.filled(16, 0)]
                                .take(16)
                                .toList());
                        return 'gravado e conferido: "${_text.text}" | ${NfcStore.toHex(written)}';
                      })
                  : null,
            ),
            ActionButton(
              label: 'Zerar bloco',
              icon: Icons.delete_outline,
              onPressed: enabled
                  ? () async {
                      if (await confirm(
                          context, 'Zerar o bloco ${_block.text}?')) {
                        run('Zerar bloco ${_block.text}', () async {
                          await nfc.writeBlock(_blockNum, Uint8List(16),
                              key: NfcStore.parseKey(), keyType: _keyType);
                          return 'bloco zerado';
                        });
                      }
                    }
                  : null,
            ),
            ActionButton(
              label: 'Diagnóstico do bloco',
              icon: Icons.manage_search,
              onPressed: enabled
                  ? () => run('Diagnóstico bloco ${_block.text}', () async {
                        final report = await nfc.debugReadBlock(_blockNum,
                            key: NfcStore.parseKey(), keyType: _keyType);
                        if (context.mounted) {
                          showTextDialog(
                              context, 'Bloco ${_block.text}', report);
                        }
                        return '\n$report';
                      })
                  : null,
            ),
            // Sempre ativo: interrompe uma espera em andamento
            ActionButton(
              label: 'Cancelar',
              icon: Icons.stop_circle_outlined,
              danger: true,
              onPressed: () => run('Cancelar', () async {
                await nfc.abort();
                return null;
              }),
            ),
          ]),
        ],
      ),
    ]);
  }
}
