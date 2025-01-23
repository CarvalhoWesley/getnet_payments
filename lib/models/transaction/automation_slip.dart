// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:getnet_payments/models/transaction/mandatory_all_receipts_fields.dart';
import 'package:getnet_payments/models/transaction/mandatory_client_fields.dart';
import 'package:getnet_payments/models/transaction/mandatory_ec_fields.dart';

class AutomationSlip {
  MandatoryAllReceiptsFields? mandatoryAllReceiptsFields;
  MandatoryClientFields? mandatoryClientFields;
  MandatoryEcFields? mandatoryEcFields;

  AutomationSlip({
    this.mandatoryAllReceiptsFields,
    this.mandatoryClientFields,
    this.mandatoryEcFields,
  });

  AutomationSlip copyWith({
    MandatoryAllReceiptsFields? mandatoryAllReceiptsFields,
    MandatoryClientFields? mandatoryClientFields,
    MandatoryEcFields? mandatoryEcFields,
  }) {
    return AutomationSlip(
      mandatoryAllReceiptsFields:
          mandatoryAllReceiptsFields ?? this.mandatoryAllReceiptsFields,
      mandatoryClientFields:
          mandatoryClientFields ?? this.mandatoryClientFields,
      mandatoryEcFields: mandatoryEcFields ?? this.mandatoryEcFields,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'mandatory_all_receipts_fields': mandatoryAllReceiptsFields?.toMap(),
      'mandatory_client_fields': mandatoryClientFields?.toMap(),
      'mandatory_ec_fields': mandatoryEcFields?.toMap(),
    };
  }

  factory AutomationSlip.fromMap(Map<String, dynamic> map) {
    return AutomationSlip(
      mandatoryAllReceiptsFields: map['mandatory_all_receipts_fields'] != null
          ? MandatoryAllReceiptsFields.fromMap(
              map['mandatory_all_receipts_fields'] as Map<String, dynamic>)
          : null,
      mandatoryClientFields: map['mandatory_client_fields'] != null
          ? MandatoryClientFields.fromMap(
              map['mandatory_client_fields'] as Map<String, dynamic>)
          : null,
      mandatoryEcFields: map['mandatory_ec_fields'] != null
          ? MandatoryEcFields.fromMap(
              map['mandatory_ec_fields'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AutomationSlip.fromJson(String source) =>
      AutomationSlip.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'AutomationSlip(mandatory_all_receipts_fields: $mandatoryAllReceiptsFields, mandatory_client_fields: $mandatoryClientFields, mandatory_ec_fields: $mandatoryEcFields)';

  @override
  bool operator ==(covariant AutomationSlip other) {
    if (identical(this, other)) return true;

    return other.mandatoryAllReceiptsFields == mandatoryAllReceiptsFields &&
        other.mandatoryClientFields == mandatoryClientFields &&
        other.mandatoryEcFields == mandatoryEcFields;
  }

  @override
  int get hashCode =>
      mandatoryAllReceiptsFields.hashCode ^
      mandatoryClientFields.hashCode ^
      mandatoryEcFields.hashCode;
}
