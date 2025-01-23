package br.com.joelabs.getnet_payments.models

import com.google.gson.annotations.SerializedName

data class AutomationSlip(
    @SerializedName("mandatory_all_receipts_fields")
    val mandatoryAllReceiptsFields: MandatoryAllReceiptsFields?,

    @SerializedName("mandatory_client_fields")
    val mandatoryClientFields: MandatoryClientFields?,

    @SerializedName("mandatory_ec_fields")
    val mandatoryEcFields: MandatoryEcFields?
)