import 'dart:convert';

import 'package:getnet_payments/models/automation_slip.dart';

/// The [Transaction] class represents the details of a transaction, including
/// payment and refund data.
///
/// This class is designed to store transaction-related information and
/// provides utilities for serialization and deserialization, as well as
/// creating copies of instances with modified fields.
class Transaction {
  /// The result of the transaction.
  final String? result;

  /// Additional details about the transaction result.
  final String? resultDetails;

  /// The transaction amount as a string.
  final String? amount;

  /// The identifier for the caller of the transaction.
  final String? callerId;

  /// The NSU (Unique Sequential Number) of the transaction.
  final String? nsu;

  /// The NSU of the last successful message related to the transaction.
  final String? nsuLastSuccesfullMessage;

  /// The control number (CV) of the transaction.
  final String? cvNumber;

  /// Whether the receipt for the transaction has already been printed.
  final bool? receiptAlreadyPrinted;

  /// The type of the transaction (e.g., credit, debit).
  final String? type;

  /// The input type for the transaction (e.g., manual entry, card swipe).
  final String? inputType;

  /// The number of installments for the transaction.
  final String? installments;

  /// The GMT timestamp of the transaction.
  final String? gmtDateTime;

  /// The local NSU of the transaction.
  final String? nsuLocal;

  /// The authorization code for the transaction.
  final String? authorizationCode;

  /// The BIN (first digits) of the card used in the transaction.
  final String? cardBin;

  /// The last digits of the card used in the transaction.
  final String? cardLastDigits;

  /// The result of any extra screens shown during the transaction.
  final String? extraScreensResult;

  /// The response from the split payload, if applicable.
  final String? splitPayloadResponse;

  /// The name of the cardholder.
  final String? cardholderName;

  /// The automation slip for the transaction, if applicable.
  final AutomationSlip? automationSlip;

  /// Whether the merchant prefers to print the receipt.
  final bool? printMerchantPreference;

  /// The order ID associated with the transaction.
  final String? orderId;

  /// The response payload for a PIX transaction, if applicable.
  final String? pixPayloadResponse;

  /// The date of the refund transaction.
  final String? refundTransactionDate;

  /// The control number (CV) for the refund transaction.
  final String? refundCvNumber;

  /// The origin terminal for the refund transaction.
  final String? refundOriginTerminal;

  /// Constructor for creating a [Transaction] instance.
  Transaction({
    this.result,
    this.resultDetails,
    this.amount,
    this.callerId,
    this.nsu,
    this.nsuLastSuccesfullMessage,
    this.cvNumber,
    this.receiptAlreadyPrinted,
    this.type,
    this.inputType,
    this.installments,
    this.gmtDateTime,
    this.nsuLocal,
    this.authorizationCode,
    this.cardBin,
    this.cardLastDigits,
    this.extraScreensResult,
    this.splitPayloadResponse,
    this.cardholderName,
    this.automationSlip,
    this.printMerchantPreference,
    this.orderId,
    this.pixPayloadResponse,
    this.refundTransactionDate,
    this.refundCvNumber,
    this.refundOriginTerminal,
  });

  /// Creates a copy of the current instance with updated fields.
  Transaction copyWith({
    String? result,
    String? resultDetails,
    String? amount,
    String? callerId,
    String? nsu,
    String? nsuLastSuccesfullMessage,
    String? cvNumber,
    bool? receiptAlreadyPrinted,
    String? type,
    String? inputType,
    String? installments,
    String? gmtDateTime,
    String? nsuLocal,
    String? authorizationCode,
    String? cardBin,
    String? cardLastDigits,
    String? extraScreensResult,
    String? splitPayloadResponse,
    String? cardholderName,
    AutomationSlip? automationSlip,
    bool? printMerchantPreference,
    String? orderId,
    String? pixPayloadResponse,
    String? refundTransactionDate,
    String? refundCvNumber,
    String? refundOriginTerminal,
  }) {
    return Transaction(
      result: result ?? this.result,
      resultDetails: resultDetails ?? this.resultDetails,
      amount: amount ?? this.amount,
      callerId: callerId ?? this.callerId,
      nsu: nsu ?? this.nsu,
      nsuLastSuccesfullMessage:
          nsuLastSuccesfullMessage ?? this.nsuLastSuccesfullMessage,
      cvNumber: cvNumber ?? this.cvNumber,
      receiptAlreadyPrinted:
          receiptAlreadyPrinted ?? this.receiptAlreadyPrinted,
      type: type ?? this.type,
      inputType: inputType ?? this.inputType,
      installments: installments ?? this.installments,
      gmtDateTime: gmtDateTime ?? this.gmtDateTime,
      nsuLocal: nsuLocal ?? this.nsuLocal,
      authorizationCode: authorizationCode ?? this.authorizationCode,
      cardBin: cardBin ?? this.cardBin,
      cardLastDigits: cardLastDigits ?? this.cardLastDigits,
      extraScreensResult: extraScreensResult ?? this.extraScreensResult,
      splitPayloadResponse: splitPayloadResponse ?? this.splitPayloadResponse,
      cardholderName: cardholderName ?? this.cardholderName,
      automationSlip: automationSlip ?? this.automationSlip,
      printMerchantPreference:
          printMerchantPreference ?? this.printMerchantPreference,
      orderId: orderId ?? this.orderId,
      pixPayloadResponse: pixPayloadResponse ?? this.pixPayloadResponse,
      refundTransactionDate:
          refundTransactionDate ?? this.refundTransactionDate,
      refundCvNumber: refundCvNumber ?? this.refundCvNumber,
      refundOriginTerminal: refundOriginTerminal ?? this.refundOriginTerminal,
    );
  }

  /// Converts the instance to a [Map].
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'result': result,
      'resultDetails': resultDetails,
      'amount': amount,
      'callerId': callerId,
      'nsu': nsu,
      'nsuLastSuccesfullMessage': nsuLastSuccesfullMessage,
      'cvNumber': cvNumber,
      'receiptAlreadyPrinted': receiptAlreadyPrinted,
      'type': type,
      'inputType': inputType,
      'installments': installments,
      'gmtDateTime': gmtDateTime,
      'nsuLocal': nsuLocal,
      'authorizationCode': authorizationCode,
      'cardBin': cardBin,
      'cardLastDigits': cardLastDigits,
      'extraScreensResult': extraScreensResult,
      'splitPayloadResponse': splitPayloadResponse,
      'cardholderName': cardholderName,
      'automationSlip': automationSlip?.toMap(),
      'printMerchantPreference': printMerchantPreference,
      'orderId': orderId,
      'pixPayloadResponse': pixPayloadResponse,
      'refundTransactionDate': refundTransactionDate,
      'refundCvNumber': refundCvNumber,
      'refundOriginTerminal': refundOriginTerminal,
    };
  }

  /// Creates an instance of [Transaction] from a [Map].
  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      result: map['result'] != null ? map['result'] as String : null,
      resultDetails:
          map['resultDetails'] != null ? map['resultDetails'] as String : null,
      amount: map['amount'] != null ? map['amount'] as String : null,
      callerId: map['callerId'] != null ? map['callerId'] as String : null,
      nsu: map['nsu'] != null ? map['nsu'] as String : null,
      nsuLastSuccesfullMessage: map['nsuLastSuccesfullMessage'] != null
          ? map['nsuLastSuccesfullMessage'] as String
          : null,
      cvNumber: map['cvNumber'] != null ? map['cvNumber'] as String : null,
      receiptAlreadyPrinted: map['receiptAlreadyPrinted'] != null
          ? map['receiptAlreadyPrinted'] as bool
          : null,
      type: map['type'] != null ? map['type'] as String : null,
      inputType: map['inputType'] != null ? map['inputType'] as String : null,
      installments:
          map['installments'] != null ? map['installments'] as String : null,
      gmtDateTime:
          map['gmtDateTime'] != null ? map['gmtDateTime'] as String : null,
      nsuLocal: map['nsuLocal'] != null ? map['nsuLocal'] as String : null,
      authorizationCode: map['authorizationCode'] != null
          ? map['authorizationCode'] as String
          : null,
      cardBin: map['cardBin'] != null ? map['cardBin'] as String : null,
      cardLastDigits: map['cardLastDigits'] != null
          ? map['cardLastDigits'] as String
          : null,
      extraScreensResult: map['extraScreensResult'] != null
          ? map['extraScreensResult'] as String
          : null,
      splitPayloadResponse: map['splitPayloadResponse'] != null
          ? map['splitPayloadResponse'] as String
          : null,
      cardholderName: map['cardholderName'] != null
          ? map['cardholderName'] as String
          : null,
      automationSlip: map['automationSlip'] != null
          ? map['automationSlip'] is String
              ? AutomationSlip.fromJson(map['automationSlip'] as String)
              : AutomationSlip.fromMap(
                  map['automationSlip'] as Map<String, dynamic>)
          : null,
      printMerchantPreference: map['printMerchantPreference'] != null
          ? map['printMerchantPreference'] as bool
          : null,
      orderId: map['orderId'] != null ? map['orderId'] as String : null,
      pixPayloadResponse: map['pixPayloadResponse'] != null
          ? map['pixPayloadResponse'] as String
          : null,
      refundTransactionDate: map['refundTransactionDate'] != null
          ? map['refundTransactionDate'] as String
          : null,
      refundCvNumber: map['refundCvNumber'] != null
          ? map['refundCvNumber'] as String
          : null,
      refundOriginTerminal: map['refundOriginTerminal'] != null
          ? map['refundOriginTerminal'] as String
          : null,
    );
  }

  /// Serializes the instance to JSON.
  String toJson() => json.encode(toMap());

  /// Deserializes a [Transaction] instance from JSON.
  factory Transaction.fromJson(String source) =>
      Transaction.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Transaction(result: $result, resultDetails: $resultDetails, amount: $amount, callerId: $callerId, nsu: $nsu, nsuLastSuccesfullMessage: $nsuLastSuccesfullMessage, cvNumber: $cvNumber, receiptAlreadyPrinted: $receiptAlreadyPrinted, type: $type, inputType: $inputType, installments: $installments, gmtDateTime: $gmtDateTime, nsuLocal: $nsuLocal, authorizationCode: $authorizationCode, cardBin: $cardBin, cardLastDigits: $cardLastDigits, extraScreensResult: $extraScreensResult, splitPayloadResponse: $splitPayloadResponse, cardholderName: $cardholderName, automationSlip: $automationSlip, printMerchantPreference: $printMerchantPreference, orderId: $orderId, pixPayloadResponse: $pixPayloadResponse, refundTransactionDate: $refundTransactionDate, refundCvNumber: $refundCvNumber, refundOriginTerminal: $refundOriginTerminal)';
  }

  @override
  bool operator ==(covariant Transaction other) {
    if (identical(this, other)) return true;

    return other.result == result &&
        other.resultDetails == resultDetails &&
        other.amount == amount &&
        other.callerId == callerId &&
        other.nsu == nsu &&
        other.nsuLastSuccesfullMessage == nsuLastSuccesfullMessage &&
        other.cvNumber == cvNumber &&
        other.receiptAlreadyPrinted == receiptAlreadyPrinted &&
        other.type == type &&
        other.inputType == inputType &&
        other.installments == installments &&
        other.gmtDateTime == gmtDateTime &&
        other.nsuLocal == nsuLocal &&
        other.authorizationCode == authorizationCode &&
        other.cardBin == cardBin &&
        other.cardLastDigits == cardLastDigits &&
        other.extraScreensResult == extraScreensResult &&
        other.splitPayloadResponse == splitPayloadResponse &&
        other.cardholderName == cardholderName &&
        other.automationSlip == automationSlip &&
        other.printMerchantPreference == printMerchantPreference &&
        other.orderId == orderId &&
        other.pixPayloadResponse == pixPayloadResponse &&
        other.refundTransactionDate == refundTransactionDate &&
        other.refundCvNumber == refundCvNumber &&
        other.refundOriginTerminal == refundOriginTerminal;
  }

  @override
  int get hashCode {
    return result.hashCode ^
        resultDetails.hashCode ^
        amount.hashCode ^
        callerId.hashCode ^
        nsu.hashCode ^
        nsuLastSuccesfullMessage.hashCode ^
        cvNumber.hashCode ^
        receiptAlreadyPrinted.hashCode ^
        type.hashCode ^
        inputType.hashCode ^
        installments.hashCode ^
        gmtDateTime.hashCode ^
        nsuLocal.hashCode ^
        authorizationCode.hashCode ^
        cardBin.hashCode ^
        cardLastDigits.hashCode ^
        extraScreensResult.hashCode ^
        splitPayloadResponse.hashCode ^
        cardholderName.hashCode ^
        automationSlip.hashCode ^
        printMerchantPreference.hashCode ^
        orderId.hashCode ^
        pixPayloadResponse.hashCode ^
        refundTransactionDate.hashCode ^
        refundCvNumber.hashCode ^
        refundOriginTerminal.hashCode;
  }
}
