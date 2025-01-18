import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getnet_payments/enums/payment_type_enum.dart';
import 'package:getnet_payments/getnet_payments.dart';
import 'package:getnet_payments/models/transaction.dart';
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
  TextEditingController valueController = TextEditingController();
  String? mensagem;
  String? mensagemReembolso;
  final List<Transaction> _successfulTransactions = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _addTransaction(Transaction transaction) {
    if (transaction.result != '0') return;
    setState(() {
      _successfulTransactions.add(transaction);
    });
  }

  Future<void> _processPayment(PaymentTypeEnum type, String typeName) async {
    FocusScope.of(context).unfocus();
    if (valueController.text.isEmpty) return;

    final valor = double.parse(valueController.text);
    try {
      final transaction = await GetnetPayments.deeplink.payment(
        amount: valor,
        paymentType: type,
        callerId: const Uuid().v4(),
      );
      if (transaction != null) {
        setState(() {
          mensagem = '${transaction.result} - ${transaction.resultDetails}';
        });
        _addTransaction(transaction);
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
                      onPressed: () =>
                          _processPayment(PaymentTypeEnum.credit, 'Crédito'),
                      child: const Text('CRÉDITO'),
                    ),
                    ElevatedButton(
                      onPressed: () =>
                          _processPayment(PaymentTypeEnum.debit, 'Débito'),
                      child: const Text('DÉBITO'),
                    ),
                    ElevatedButton(
                      onPressed: () =>
                          _processPayment(PaymentTypeEnum.voucher, 'Voucher'),
                      child: const Text('VOUCHER'),
                    ),
                    ElevatedButton(
                      onPressed: () =>
                          _processPayment(PaymentTypeEnum.pix, 'PIX'),
                      child: const Text('PIX'),
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
                if (mensagemReembolso != null)
                  Column(
                    children: [
                      const Text('Resultado Reembolso:'),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(mensagemReembolso!),
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
                              '${transaction.type} - ${transaction.result}'),
                          subtitle: Text(
                              '${transaction.resultDetails}\nData: ${transaction.gmtDateTime}'),
                          trailing: ElevatedButton(
                            onPressed: () async {
                              final refund =
                                  await GetnetPayments.deeplink.refund(
                                amount: _convertAmount(transaction),
                                transactionDate: DateTime.now(),
                                cvNumber: transaction.cvNumber,
                                originalTerminal: '10005105',
                              );

                              if (refund != null) {
                                setState(() {
                                  mensagemReembolso =
                                      '${refund.result} - ${refund.resultDetails}';
                                });
                              }
                            },
                            child: const Text('Reembolsar'),
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

  double _convertAmount(Transaction transaction) {
    final amountString = double.parse(transaction.amount!).toString();
    final amountDouble =
        double.parse(amountString.substring(0, amountString.length - 4));
    return amountDouble;
  }
}
