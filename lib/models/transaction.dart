import 'dart:convert';

class Transaction {
  final String? result;
  final String? resultDetails;
  final String? amount;
  final String? callerId;
  final String? nsu;
  final String? nsuLastSuccesfullMessage;
  final String? cvNumber;
  final bool? receiptAlreadyPrinted;
  final String? type;
  final String? inputType;
  final String? installments;
  final String? gmtDateTime;
  final String? nsuLocal;
  final String? authorizationCode;
  final String? cardBin;
  final String? cardLastDigits;
  final String? extraScreensResult;
  final String? splitPayloadResponse;
  final String? cardholderName;
  final String? automationSlip;
  final bool? printMerchantPreference;
  final String? orderId;
  final String? pixPayloadResponse;
  final String? refundTransactionDate;
  final String? refundCvNumber;
  final String? refundOriginTerminal;

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
    String? automationSlip,
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
      'automationSlip': automationSlip,
      'printMerchantPreference': printMerchantPreference,
      'orderId': orderId,
      'pixPayloadResponse': pixPayloadResponse,
      'refundTransactionDate': refundTransactionDate,
      'refundCvNumber': refundCvNumber,
      'refundOriginTerminal': refundOriginTerminal,
    };
  }

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
          ? map['automationSlip'] as String
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

  String toJson() => json.encode(toMap());

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
