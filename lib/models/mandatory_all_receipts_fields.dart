// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MandatoryAllReceiptsFields {
  String? authorizationCode;
  String? brand;
  String? cardLastDigits;
  String? city;
  String? ecDocument;
  String? ecName;
  String? ecNumber;
  String? letterTypeTransaction;
  String? version;
  String? getnetLogo;
  String? dateTime;
  String? nsu;
  String? terminal;

  MandatoryAllReceiptsFields({
    this.authorizationCode,
    this.brand,
    this.cardLastDigits,
    this.city,
    this.ecDocument,
    this.ecName,
    this.ecNumber,
    this.letterTypeTransaction,
    this.version,
    this.getnetLogo,
    this.dateTime,
    this.nsu,
    this.terminal,
  });

  MandatoryAllReceiptsFields copyWith({
    String? authorizationCode,
    String? brand,
    String? cardLastDigits,
    String? city,
    String? ecDocument,
    String? ecName,
    String? ecNumber,
    String? letterTypeTransaction,
    String? version,
    String? getnetLogo,
    String? dateTime,
    String? nsu,
    String? terminal,
  }) {
    return MandatoryAllReceiptsFields(
      authorizationCode: authorizationCode ?? this.authorizationCode,
      brand: brand ?? this.brand,
      cardLastDigits: cardLastDigits ?? this.cardLastDigits,
      city: city ?? this.city,
      ecDocument: ecDocument ?? this.ecDocument,
      ecName: ecName ?? this.ecName,
      ecNumber: ecNumber ?? this.ecNumber,
      letterTypeTransaction:
          letterTypeTransaction ?? this.letterTypeTransaction,
      version: version ?? this.version,
      getnetLogo: getnetLogo ?? this.getnetLogo,
      dateTime: dateTime ?? this.dateTime,
      nsu: nsu ?? this.nsu,
      terminal: terminal ?? this.terminal,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'authorizationCode': authorizationCode,
      'brand': brand,
      'cardLastDigits': cardLastDigits,
      'city': city,
      'ecDocument': ecDocument,
      'ecName': ecName,
      'ecNumber': ecNumber,
      'letterTypeTransaction': letterTypeTransaction,
      'version': version,
      'getnetLogo': getnetLogo,
      'dateTime': dateTime,
      'nsu': nsu,
      'terminal': terminal,
    };
  }

  factory MandatoryAllReceiptsFields.fromMap(Map<String, dynamic> map) {
    return MandatoryAllReceiptsFields(
      authorizationCode: map['authorizationCode'] != null
          ? map['authorizationCode'] as String
          : null,
      brand: map['brand'] != null ? map['brand'] as String : null,
      cardLastDigits: map['cardLastDigits'] != null
          ? map['cardLastDigits'] as String
          : null,
      city: map['city'] != null ? map['city'] as String : null,
      ecDocument:
          map['ecDocument'] != null ? map['ecDocument'] as String : null,
      ecName: map['ecName'] != null ? map['ecName'] as String : null,
      ecNumber: map['ecNumber'] != null ? map['ecNumber'] as String : null,
      letterTypeTransaction: map['letterTypeTransaction'] != null
          ? map['letterTypeTransaction'] as String
          : null,
      version: map['version'] != null ? map['version'] as String : null,
      getnetLogo:
          map['getnetLogo'] != null ? map['getnetLogo'] as String : null,
      dateTime: map['dateTime'] != null ? map['dateTime'] as String : null,
      nsu: map['nsu'] != null ? map['nsu'] as String : null,
      terminal: map['terminal'] != null ? map['terminal'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MandatoryAllReceiptsFields.fromJson(String source) =>
      MandatoryAllReceiptsFields.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MandatoryAllReceiptsFields(authorizationCode: $authorizationCode, brand: $brand, cardLastDigits: $cardLastDigits, city: $city, ecDocument: $ecDocument, ecName: $ecName, ecNumber: $ecNumber, letterTypeTransaction: $letterTypeTransaction, version: $version, getnetLogo: $getnetLogo, dateTime: $dateTime, nsu: $nsu, terminal: $terminal)';
  }

  @override
  bool operator ==(covariant MandatoryAllReceiptsFields other) {
    if (identical(this, other)) return true;

    return other.authorizationCode == authorizationCode &&
        other.brand == brand &&
        other.cardLastDigits == cardLastDigits &&
        other.city == city &&
        other.ecDocument == ecDocument &&
        other.ecName == ecName &&
        other.ecNumber == ecNumber &&
        other.letterTypeTransaction == letterTypeTransaction &&
        other.version == version &&
        other.getnetLogo == getnetLogo &&
        other.dateTime == dateTime &&
        other.nsu == nsu &&
        other.terminal == terminal;
  }

  @override
  int get hashCode {
    return authorizationCode.hashCode ^
        brand.hashCode ^
        cardLastDigits.hashCode ^
        city.hashCode ^
        ecDocument.hashCode ^
        ecName.hashCode ^
        ecNumber.hashCode ^
        letterTypeTransaction.hashCode ^
        version.hashCode ^
        getnetLogo.hashCode ^
        dateTime.hashCode ^
        nsu.hashCode ^
        terminal.hashCode;
  }
}
