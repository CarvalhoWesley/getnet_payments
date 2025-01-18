import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getnet_payments/enums/payment_type_enum.dart';
import 'package:getnet_payments/getnet_payments.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController valueController = TextEditingController();
  String? mensagem;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Getnet Payments'),
        ),
        body: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
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
                ),
                Wrap(
                  children: [
                    //CREDITO
                    ElevatedButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        if (valueController.text.isEmpty) return;

                        final valor = double.parse(valueController.text);
                        try {
                          final transaction =
                              await GetnetPayments.deeplink.payment(
                            amount: valor,
                            paymentType: PaymentTypeEnum.credit,
                            callerId: const Uuid().v4(),
                          );
                          if (transaction != null) {
                            setState(() {
                              mensagem =
                                  '${transaction.result} - ${transaction.resultDetails}';
                            });
                          }
                        } catch (e) {
                          log(e.toString());
                          setState(() {
                            mensagem = 'Erro ao realizar pagamento';
                          });
                        }
                      },
                      child: const Text('CRÉDITO'),
                    ),
                  ],
                ),
                Wrap(
                  children: [
                    //DEBITO
                    ElevatedButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        if (valueController.text.isEmpty) return;

                        final valor = double.parse(valueController.text);
                        try {
                          final transaction =
                              await GetnetPayments.deeplink.payment(
                            amount: valor,
                            paymentType: PaymentTypeEnum.debit,
                            callerId: const Uuid().v4(),
                          );
                          if (transaction != null) {
                            setState(() {
                              mensagem =
                                  '${transaction.result} - ${transaction.resultDetails}';
                            });
                          }
                        } catch (e) {
                          log(e.toString());
                          setState(() {
                            mensagem = 'Erro ao realizar pagamento';
                          });
                        }
                      },
                      child: const Text('DÉBITO'),
                    ),
                  ],
                ),
                Wrap(
                  children: [
                    //VOUCHER
                    ElevatedButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        if (valueController.text.isEmpty) return;

                        final valor = double.parse(valueController.text);
                        try {
                          final transaction =
                              await GetnetPayments.deeplink.payment(
                            amount: valor,
                            paymentType: PaymentTypeEnum.voucher,
                            callerId: const Uuid().v4(),
                          );
                          if (transaction != null) {
                            setState(() {
                              mensagem =
                                  '${transaction.result} - ${transaction.resultDetails}';
                            });
                          }
                        } catch (e) {
                          log(e.toString());
                          setState(() {
                            mensagem = 'Erro ao realizar pagamento';
                          });
                        }
                      },
                      child: const Text('VOUCHER'),
                    ),
                  ],
                ),
                Wrap(
                  children: [
                    //PIX
                    ElevatedButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        if (valueController.text.isEmpty) return;

                        final valor = double.parse(valueController.text);
                        try {
                          final transaction =
                              await GetnetPayments.deeplink.payment(
                            amount: valor,
                            paymentType: PaymentTypeEnum.pix,
                            callerId: const Uuid().v4(),
                          );
                          if (transaction != null) {
                            setState(() {
                              mensagem =
                                  '${transaction.result} - ${transaction.resultDetails}';
                            });
                          }
                        } catch (e) {
                          log(e.toString());
                          setState(() {
                            mensagem = 'Erro ao realizar pagamento';
                          });
                        }
                      },
                      child: const Text('PIX'),
                    ),
                  ],
                ),
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
        ),
      ),
    );
  }
}
