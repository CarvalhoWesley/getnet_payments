import 'package:flutter/material.dart';
import 'package:getnet_payments/getnet_payments.dart';

import '../core/app_log.dart';
import '../core/ui.dart';

/// Cartão de evento (cashless) com os métodos prontos do GetnetNfcCashless.
class NfcEventTab extends StatefulWidget {
  const NfcEventTab({super.key});

  @override
  State<NfcEventTab> createState() => _NfcEventTabState();
}

class _NfcEventTabState extends State<NfcEventTab>
    with ActionRunner, AutomaticKeepAliveClientMixin {
  final _eventId = TextEditingController(text: 'EVT001');
  final _value = TextEditingController(text: '50.00');
  final _name = TextEditingController(text: 'Fulano');
  final _cpf = TextEditingController(text: '12345678900');
  final _tag = TextEditingController(text: '0001');
  final _cellPhone = TextEditingController(text: '11999999999');

  NfcCashlessCard? _card;

  @override
  LogSource get logSource => LogSource.nfc;

  @override
  bool get wantKeepAlive => true;

  double get _amount => parseAmount(_value.text);

  /// Executa a operação e mostra o cartão atualizado.
  void _runCard(String name, Future<NfcCashlessCard> Function() action) {
    run(name, () async {
      final card = await action();
      if (mounted) setState(() => _card = card);
      return 'saldo R\$ ${card.value.toStringAsFixed(2)} | UID ${card.uuid}';
    });
  }

  @override
  void dispose() {
    for (final c in [_eventId, _value, _name, _cpf, _tag, _cellPhone]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final enabled = !busy;
    return ActionPage(busy: busy, children: [
      if (_card != null) _CardSummary(card: _card!),
      Section(
        title: 'Evento e valor',
        hint:
            'Usados em todas as operações. Cartões de outro evento são recusados.',
        children: [
          FieldWrap(children: [
            AppField(controller: _eventId, label: 'ID do evento'),
            AppField(controller: _value, label: 'Valor (R\$)', numeric: true),
          ]),
          ActionWrap(children: [
            ActionButton(
              label: 'Ler',
              icon: Icons.contactless,
              primary: true,
              onPressed: enabled
                  ? () => _runCard(
                      'Ler cartão',
                      () =>
                          GetnetNfcCashless.readCard(eventId: _eventId.text))
                  : null,
            ),
            ActionButton(
              label: 'Recarregar',
              icon: Icons.add_card,
              onPressed: enabled
                  ? () => _runCard(
                      'Recarga',
                      () => GetnetNfcCashless.recharge(
                          value: _amount, eventId: _eventId.text))
                  : null,
            ),
            ActionButton(
              label: 'Debitar',
              icon: Icons.remove_circle_outline,
              onPressed: enabled
                  ? () => _runCard(
                      'Débito',
                      () => GetnetNfcCashless.debit(
                          value: _amount, eventId: _eventId.text))
                  : null,
            ),
            ActionButton(
              label: 'Estornar',
              icon: Icons.undo,
              onPressed: enabled
                  ? () => _runCard(
                      'Estorno',
                      () => GetnetNfcCashless.refund(
                          value: _amount, eventId: _eventId.text))
                  : null,
            ),
          ]),
        ],
      ),
      Section(
        title: 'Abrir cartão',
        hint: 'Grava o portador e o saldo inicial (campo Valor acima). '
            'Cada campo aceita até 16 bytes.',
        children: [
          FieldWrap(children: [
            AppField(controller: _name, label: 'Nome'),
            AppField(controller: _cpf, label: 'CPF', numeric: true),
            AppField(controller: _tag, label: 'Número da tag'),
            AppField(controller: _cellPhone, label: 'Celular', numeric: true),
          ]),
          ActionWrap(children: [
            ActionButton(
              label: 'Abrir (gravar)',
              icon: Icons.save,
              primary: true,
              onPressed: enabled
                  ? () => _runCard(
                      'Abrir cartão',
                      () => GetnetNfcCashless.openCard(
                            value: _amount,
                            eventId: _eventId.text,
                            name: _name.text,
                            cpf: _cpf.text,
                            tag: _tag.text,
                            cellPhone: _cellPhone.text,
                          ))
                  : null,
            ),
          ]),
        ],
      ),
      Section(
        title: 'Formatar',
        hint: 'Evento: zera só os blocos do cartão de evento. Cartão inteiro: '
            'zera os 47 blocos de dados. Nos dois, o cartão volta a ficar fechado.',
        children: [
          ActionWrap(children: [
            ActionButton(
              label: 'Formatar evento',
              icon: Icons.delete_outline,
              danger: true,
              onPressed: enabled
                  ? () async {
                      if (await confirm(context,
                          'Formatar zera os blocos do cartão de evento (1, 2, 4, 5, 6, 8, 9 e 12). Continuar?')) {
                        run('Formatar evento', () async {
                          await GetnetNfcCashless.format();
                          if (mounted) setState(() => _card = null);
                          return null;
                        });
                      }
                    }
                  : null,
            ),
            ActionButton(
              label: 'Formatar cartão inteiro',
              icon: Icons.delete_forever,
              danger: true,
              onPressed: enabled
                  ? () async {
                      if (await confirm(
                          context,
                          'Formatar zera TODOS os 47 blocos de dados do cartão (evento e setores 4 a 15). '
                          'Bloco 0 e chaves não são alterados. Continuar?')) {
                        run('Formatar cartão inteiro', () async {
                          final cleared = await GetnetNfcCashless.formatAll();
                          if (mounted) setState(() => _card = null);
                          return '$cleared blocos zerados';
                        });
                      }
                    }
                  : null,
            ),
          ]),
        ],
      ),
    ]);
  }
}

class _CardSummary extends StatelessWidget {
  final NfcCashlessCard card;

  const _CardSummary({required this.card});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.primaryContainer,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Saldo', style: theme.textTheme.labelLarge),
                const Spacer(),
                Chip(
                  label: Text(card.opened ? 'Aberto' : 'Fechado'),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            Text('R\$ ${card.value.toStringAsFixed(2)}',
                style: theme.textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text('Total carregado: R\$ ${card.openValue.toStringAsFixed(2)}'),
            Text('Evento: ${card.eventId.isEmpty ? '-' : card.eventId}'),
            Text('Portador: ${card.name} · CPF ${card.cpf}'),
            Text('Tag ${card.tag} · Cel ${card.cellPhone}'),
            Text('UID ${card.uuid}', style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
