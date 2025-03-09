import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getnet_payments/getnet_payments.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PaymentApp(),
    );
  }
}

class PaymentApp extends StatefulWidget {
  const PaymentApp({super.key});

  @override
  State<PaymentApp> createState() => _PaymentAppState();
}

class _PaymentAppState extends State<PaymentApp>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController valueController = TextEditingController(text: '12.50');
  String? mensagem;
  String? mensagemTransacoes;
  final List<Transaction> _successfulTransactions = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _addTransaction(Transaction transaction) {
    if (transaction.result != '0' && transaction.result != '5') return;
    setState(() {
      _successfulTransactions.insert(0, transaction);
    });
  }

  double _convertAmount(Transaction transaction) {
    final amount = transaction.amount ?? '0000';
    final amountDouble = double.parse(
        '${amount.substring(0, amount.length - 2)}.${amount.substring(amount.length - 2)}');
    return amountDouble;
  }

  Future<void> _processPrint() async {
    FocusScope.of(context).unfocus();

    final logo = await rootBundle.load('assets/images/logo.jpg');
    String base64 = base64Encode(logo.buffer.asUint8List());

    final items = [
      ItemPrintModel.text(
        content: "TEXTO SMALL CENTRALIZADO",
        align: AlignModeEnum.center,
        fontFormat: FontFormatEnum.small,
      ),
      ItemPrintModel.text(
        content: "TEXTO MEDIUM CENTRALIZADO",
        align: AlignModeEnum.center,
        fontFormat: FontFormatEnum.medium,
      ),
      ItemPrintModel.text(
        content: "TEXTO LARGE CENTRALIZADO",
        align: AlignModeEnum.center,
        fontFormat: FontFormatEnum.large,
      ),
      ItemPrintModel.qrcode(
        content: "https://example.com",
        align: AlignModeEnum.center,
        height: 200,
      ),
      ItemPrintModel.linewrap(lines: 1),
      ItemPrintModel.barcode(
        content: "123456789012",
        align: AlignModeEnum.center,
      ),
      ItemPrintModel.image(
        content: base64,
        align: AlignModeEnum.center,
      ),
      ItemPrintModel.linewrap(lines: 2),
    ];
    GetnetPayments.pos.print(items);
  }

  Future<void> _processPayment(
    PaymentTypeEnum type, {
    int installments = 1,
    String? creditType,
  }) async {
    FocusScope.of(context).unfocus();
    if (valueController.text.isEmpty) return;

    final valor = double.parse(valueController.text);
    try {
      final callerId = const Uuid().v4();
      final transaction = await GetnetPayments.deeplink.payment(
        amount: valor,
        paymentType: type,
        callerId: callerId,
        installments: installments,
        creditType: creditType,
      );
      if (transaction != null) {
        setState(() {
          mensagem = '${transaction.result} - ${transaction.resultDetails}';
        });
        _addTransaction(
            transaction.copyWith(callerId: transaction.callerId ?? callerId));
      }
    } catch (e) {
      log(e.toString());
      setState(() {
        mensagem = 'Erro ao realizar pagamento';
      });
    }
  }

  Future<void> _processReprintLastTransaction() async {
    FocusScope.of(context).unfocus();

    try {
      final result = await GetnetPayments.deeplink.reprint();
      if (result != null) {
        setState(() {
          mensagem = result;
        });
      }
    } catch (e) {
      log(e.toString());
      setState(() {
        mensagem = 'Erro ao realizar pagamento';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Getnet Payments'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pagamento'),
            Tab(text: 'Transações'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Pagamento Tab
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: valueController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  decoration: const InputDecoration(
                    hintText: 'Valor',
                    contentPadding: EdgeInsets.all(10.0),
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: () => _processPayment(PaymentTypeEnum.credit),
                      child: const Text('CRÉDITO'),
                    ),
                    ElevatedButton(
                      onPressed: () => _processPayment(
                        PaymentTypeEnum.credit,
                        installments: 12,
                        creditType: 'creditMerchant',
                      ),
                      child: const Text('CRÉDITO 12X'),
                    ),
                    ElevatedButton(
                      onPressed: () => _processPayment(PaymentTypeEnum.debit),
                      child: const Text('DÉBITO'),
                    ),
                    ElevatedButton(
                      onPressed: () => _processPayment(PaymentTypeEnum.voucher),
                      child: const Text('VOUCHER'),
                    ),
                    ElevatedButton(
                      onPressed: () => _processPayment(PaymentTypeEnum.pix),
                      child: const Text('PIX'),
                    ),
                    ElevatedButton(
                      onPressed: () => _processReprintLastTransaction(),
                      child: const Text('REIMPRIMIR ÚLTIMO CUPOM'),
                    ),
                    ElevatedButton(
                      onPressed: () => _processPrint(),
                      child: const Text('TESTAR IMPRESSORA'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (mensagem != null)
                  Column(
                    children: [
                      const Divider(),
                      const Text('Resultado:'),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(mensagem!),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          // Transações Tab
          SizedBox(
            child: Column(
              children: [
                if (mensagemTransacoes != null)
                  Column(
                    children: [
                      const Text('Resultado Reembolso:'),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(mensagemTransacoes!),
                      ),
                    ],
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _successfulTransactions.length,
                    itemBuilder: (context, index) {
                      final transaction = _successfulTransactions[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: ListTile(
                          title: Text(
                              'CV: ${transaction.cvNumber ?? 'Sem informação'}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Valor: ${_convertAmount(transaction).toStringAsFixed(2)}'),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  FilledButton(
                                    onPressed: () async {
                                      final refund = await GetnetPayments
                                          .deeplink
                                          .checkStatus(
                                        callerId: transaction.callerId!,
                                      );

                                      if (refund != null) {
                                        setState(() {
                                          mensagemTransacoes =
                                              '${refund.result} - ${refund.resultDetails}';
                                        });
                                      }
                                    },
                                    child: const Text('Status'),
                                  ),
                                  FilledButton(
                                    onPressed: () async {
                                      final refund =
                                          await GetnetPayments.deeplink.refund(
                                        amount: _convertAmount(transaction),
                                        transactionDate: DateTime.now(),
                                        cvNumber: transaction.cvNumber,
                                      );

                                      if (refund != null) {
                                        setState(() {
                                          mensagemTransacoes =
                                              '${refund.result} - ${refund.resultDetails}';
                                        });

                                        if (refund.result ==
                                            TransactionResultEnum
                                                .success.value) {
                                          _successfulTransactions
                                              .removeAt(index);
                                        }
                                      }
                                    },
                                    child: const Text('Reembolsar'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
