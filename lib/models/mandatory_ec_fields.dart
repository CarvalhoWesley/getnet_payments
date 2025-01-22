// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MandatoryEcFields {
  String? aid;
  String? arqc;
  String? ecBody;
  String? nsuLocal;
  String? receiptTypeEc;
  
  MandatoryEcFields({
    this.aid,
    this.arqc,
    this.ecBody,
    this.nsuLocal,
    this.receiptTypeEc,
  });

  MandatoryEcFields copyWith({
    String? aid,
    String? arqc,
    String? ecBody,
    String? nsuLocal,
    String? receiptTypeEc,
  }) {
    return MandatoryEcFields(
      aid: aid ?? this.aid,
      arqc: arqc ?? this.arqc,
      ecBody: ecBody ?? this.ecBody,
      nsuLocal: nsuLocal ?? this.nsuLocal,
      receiptTypeEc: receiptTypeEc ?? this.receiptTypeEc,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'aid': aid,
      'arqc': arqc,
      'ecBody': ecBody,
      'nsuLocal': nsuLocal,
      'receiptTypeEc': receiptTypeEc,
    };
  }

  factory MandatoryEcFields.fromMap(Map<String, dynamic> map) {
    return MandatoryEcFields(
      aid: map['aid'] != null ? map['aid'] as String : null,
      arqc: map['arqc'] != null ? map['arqc'] as String : null,
      ecBody: map['ecBody'] != null ? map['ecBody'] as String : null,
      nsuLocal: map['nsuLocal'] != null ? map['nsuLocal'] as String : null,
      receiptTypeEc:
          map['receiptTypeEc'] != null ? map['receiptTypeEc'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MandatoryEcFields.fromJson(String source) =>
      MandatoryEcFields.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MandatoryEcFields(aid: $aid, arqc: $arqc, ecBody: $ecBody, nsuLocal: $nsuLocal, receiptTypeEc: $receiptTypeEc)';
  }

  @override
  bool operator ==(covariant MandatoryEcFields other) {
    if (identical(this, other)) return true;

    return other.aid == aid &&
        other.arqc == arqc &&
        other.ecBody == ecBody &&
        other.nsuLocal == nsuLocal &&
        other.receiptTypeEc == receiptTypeEc;
  }

  @override
  int get hashCode {
    return aid.hashCode ^
        arqc.hashCode ^
        ecBody.hashCode ^
        nsuLocal.hashCode ^
        receiptTypeEc.hashCode;
  }
}
