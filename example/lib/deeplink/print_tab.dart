import 'package:flutter/material.dart';
import 'package:getnet_payments/getnet_payments.dart';

import '../core/app_log.dart';
import '../core/print_samples.dart';
import '../core/ui.dart';

class DeeplinkPrintTab extends StatefulWidget {
  const DeeplinkPrintTab({super.key});

  @override
  State<DeeplinkPrintTab> createState() => _DeeplinkPrintTabState();
}

class _DeeplinkPrintTabState extends State<DeeplinkPrintTab> with ActionRunner {
  @override
  LogSource get logSource => LogSource.pos;

  @override
  Widget build(BuildContext context) {
    final enabled = !busy;
    return ActionPage(busy: busy, children: [
      Section(
        title: 'Impressora do POS',
        hint: 'Imprime direto na impressora do terminal (PosDigital).',
        children: [
          ActionWrap(children: [
            ActionButton(
              label: 'Imprimir texto',
              icon: Icons.text_snippet,
              primary: true,
              onPressed: enabled
                  ? () => run(
                      'Imprimir texto',
                      () async => GetnetPayments.pos
                          .print(await samplePrintItems(withImage: false)))
                  : null,
            ),
            ActionButton(
              label: 'Imprimir texto + imagem',
              icon: Icons.image,
              onPressed: enabled
                  ? () => run(
                      'Imprimir texto + imagem',
                      () async =>
                          GetnetPayments.pos.print(await samplePrintItems()))
                  : null,
            ),
          ]),
        ],
      ),
      Section(
        title: 'Reimpressão',
        hint: 'Pede ao app da Getnet o último comprovante.',
        children: [
          ActionWrap(children: [
            ActionButton(
              label: 'Reimprimir último cupom',
              icon: Icons.print,
              onPressed: enabled
                  ? () => run('Reimprimir último cupom',
                      () => GetnetPayments.deeplink.reprint())
                  : null,
            ),
          ]),
        ],
      ),
    ]);
  }
}
