import 'package:flutter/material.dart';
import 'package:getnet_payments/getnet_payments.dart';
import 'package:uuid/uuid.dart';

import '../core/app_log.dart';
import '../core/ui.dart';
import 'deeplink_store.dart';

class DeeplinkPaymentTab extends StatefulWidget {
  const DeeplinkPaymentTab({super.key});

  @override
  State<DeeplinkPaymentTab> createState() => _DeeplinkPaymentTabState();
}

class _DeeplinkPaymentTabState extends State<DeeplinkPaymentTab>
    with ActionRunner, AutomaticKeepAliveClientMixin {
  final _value = TextEditingController(text: '12.50');
  bool _printReceipt = true;

  @override
  LogSource get logSource => LogSource.deeplink;

  @override
  bool get wantKeepAlive => true;

  Future<String?> _pay(
    PaymentTypeEnum type, {
    int installments = 1,
    String? creditType,
  }) async {
    final callerId = const Uuid().v4();
    final t = await GetnetPayments.deeplink.payment(
      amount: parseAmount(_value.text),
      paymentType: type,
      callerId: callerId,
      installments: installments,
      creditType: creditType,
      allowPrintCurrentTransaction: !_printReceipt,
    );
    if (t == null) return 'sem retorno do app da Getnet';
    DeeplinkStore.add(t.copyWith(callerId: t.callerId ?? callerId));
    return '${t.result} - ${t.resultDetails} | CV ${t.cvNumber ?? '-'}';
  }

  @override
  void dispose() {
    _value.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final enabled = !busy;
    return ActionPage(busy: busy, children: [
      Section(
        title: 'Nova transação',
        hint: 'Abre o app de pagamento da Getnet. Ao terminar, o resultado '
            'volta para este app e aparece em Transações e na aba Logs.',
        children: [
          FieldWrap(children: [
            AppField(controller: _value, label: 'Valor (R\$)', numeric: true),
          ]),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Imprimir cupom'),
            value: _printReceipt,
            onChanged: busy ? null : (v) => setState(() => _printReceipt = v),
          ),
          const SizedBox(height: 8),
          ActionWrap(children: [
            ActionButton(
              label: 'Crédito',
              icon: Icons.credit_card,
              primary: true,
              onPressed: enabled
                  ? () => run('Crédito', () => _pay(PaymentTypeEnum.credit))
                  : null,
            ),
            ActionButton(
              label: 'Crédito 12x',
              icon: Icons.credit_card,
              onPressed: enabled
                  ? () => run(
                      'Crédito 12x',
                      () => _pay(PaymentTypeEnum.credit,
                          installments: 12, creditType: 'creditMerchant'))
                  : null,
            ),
            ActionButton(
              label: 'Débito',
              icon: Icons.payment,
              onPressed: enabled
                  ? () => run('Débito', () => _pay(PaymentTypeEnum.debit))
                  : null,
            ),
            ActionButton(
              label: 'Voucher',
              icon: Icons.card_giftcard,
              onPressed: enabled
                  ? () => run('Voucher', () => _pay(PaymentTypeEnum.voucher))
                  : null,
            ),
            ActionButton(
              label: 'PIX',
              icon: Icons.qr_code,
              onPressed: enabled
                  ? () => run('PIX', () => _pay(PaymentTypeEnum.pix))
                  : null,
            ),
          ]),
        ],
      ),
    ]);
  }
}
