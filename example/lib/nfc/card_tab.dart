import 'package:flutter/material.dart';
import 'package:getnet_payments/getnet_payments.dart';

import '../core/app_log.dart';
import '../core/ui.dart';

class NfcCardTab extends StatefulWidget {
  const NfcCardTab({super.key});

  @override
  State<NfcCardTab> createState() => _NfcCardTabState();
}

class _NfcCardTabState extends State<NfcCardTab>
    with ActionRunner, AutomaticKeepAliveClientMixin {
  @override
  LogSource get logSource => LogSource.nfc;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final enabled = !busy;
    return ActionPage(busy: busy, children: [
      Section(
        title: 'Identificador (UID)',
        hint: 'Leia o mesmo cartão várias vezes: o ID precisa se repetir para '
            'servir de identificador no servidor.',
        children: [
          ActionWrap(children: [
            ActionButton(
              label: 'Ler ID do cartão',
              icon: Icons.contactless,
              primary: true,
              onPressed: enabled
                  ? () => run('Ler ID', () async {
                        final id = await GetnetPayments.nfc.readCardId();
                        if (context.mounted) {
                          showTextDialog(context, 'ID do cartão', id,
                              fontSize: 22);
                        }
                        return id;
                      })
                  : null,
            ),
          ]),
        ],
      ),
      Section(
        title: 'Espera pelo cartão',
        children: [
          ActionWrap(children: [
            // Sempre ativo: interrompe uma espera em andamento
            ActionButton(
              label: 'Cancelar leitura',
              icon: Icons.cancel,
              danger: true,
              onPressed: () => run('Cancelar leitura', () async {
                await GetnetPayments.nfc.abort();
                return null;
              }),
            ),
          ]),
        ],
      ),
    ]);
  }
}
