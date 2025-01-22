// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MandatoryClientFields {
  String? clientBody;
  String? receiptTypeClient;

  MandatoryClientFields({
    this.clientBody,
    this.receiptTypeClient,
  });

  MandatoryClientFields copyWith({
    String? clientBody,
    String? receiptTypeClient,
  }) {
    return MandatoryClientFields(
      clientBody: clientBody ?? this.clientBody,
      receiptTypeClient: receiptTypeClient ?? this.receiptTypeClient,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'clientBody': clientBody,
      'receiptTypeClient': receiptTypeClient,
    };
  }

  factory MandatoryClientFields.fromMap(Map<String, dynamic> map) {
    return MandatoryClientFields(
      clientBody:
          map['clientBody'] != null ? map['clientBody'] as String : null,
      receiptTypeClient: map['receiptTypeClient'] != null
          ? map['receiptTypeClient'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MandatoryClientFields.fromJson(String source) =>
      MandatoryClientFields.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'MandatoryClientFields(clientBody: $clientBody, receiptTypeClient: $receiptTypeClient)';

  @override
  bool operator ==(covariant MandatoryClientFields other) {
    if (identical(this, other)) return true;

    return other.clientBody == clientBody &&
        other.receiptTypeClient == receiptTypeClient;
  }

  @override
  int get hashCode => clientBody.hashCode ^ receiptTypeClient.hashCode;
}
