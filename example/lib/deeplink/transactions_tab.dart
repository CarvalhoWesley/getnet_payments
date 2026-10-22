import 'package:flutter/material.dart';
import 'package:getnet_payments/getnet_payments.dart';

import '../core/app_log.dart';
import '../core/ui.dart';
import 'deeplink_store.dart';

class DeeplinkTransactionsTab extends StatefulWidget {
  const DeeplinkTransactionsTab({super.key});

  @override
  State<DeeplinkTransactionsTab> createState() =>
      _DeeplinkTransactionsTabState();
}

class _DeeplinkTransactionsTabState extends State<DeeplinkTransactionsTab>
    with ActionRunner {
  @override
  LogSource get logSource => LogSource.deeplink;

  Future<String?> _status(Transaction t) async {
    final r = await GetnetPayments.deeplink.checkStatus(callerId: t.callerId!);
    return r == null ? 'sem retorno' : '${r.result} - ${r.resultDetails}';
  }

  Future<String?> _refund(Transaction t) async {
    final r = await GetnetPayments.deeplink.refund(
      amount: DeeplinkStore.amountToDouble(t.amount),
      transactionDate: DateTime.now(),
      cvNumber: t.cvNumber,
    );
    if (r == null) return 'sem retorno';
    if (r.result == TransactionResultEnum.success.value) {
      DeeplinkStore.remove(t);
    }
    return '${r.result} - ${r.resultDetails}';
  }

  @override
  Widget build(BuildContext context) {
    return ActionPage(busy: busy, children: [
      ValueListenableBuilder(
        valueListenable: DeeplinkStore.transactions,
        builder: (context, transactions, _) => Section(
          title: 'Transações aprovadas',
          hint: transactions.isEmpty
              ? 'Nenhuma transação nesta sessão. Faça um pagamento na aba Pagamento.'
              : 'Reembolsar abre o app da Getnet para estornar a transação.',
          children: [
            for (final t in transactions)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.receipt),
                title: Text(
                    'R\$ ${DeeplinkStore.amountToDouble(t.amount).toStringAsFixed(2)}'),
                subtitle: Text('CV ${t.cvNumber ?? '-'}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: 'Consultar status',
                      icon: const Icon(Icons.info_outline),
                      onPressed: busy || t.callerId == null
                          ? null
                          : () => run('Status', () => _status(t)),
                    ),
                    IconButton(
                      tooltip: 'Reembolsar',
                      icon: const Icon(Icons.undo),
                      onPressed: busy
                          ? null
                          : () async {
                              if (await confirm(context,
                                  'Reembolsar a transação ${t.cvNumber ?? ''}?')) {
                                run('Reembolso', () => _refund(t));
                              }
                            },
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    ]);
  }
}
