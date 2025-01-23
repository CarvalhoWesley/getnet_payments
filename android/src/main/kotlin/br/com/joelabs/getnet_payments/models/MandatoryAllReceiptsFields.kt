package br.com.joelabs.getnet_payments.models

data class MandatoryAllReceiptsFields(
    val authorizationCode: String?,
    val brand: String?,
    val cardLastDigits: String?,
    val city: String?,
    val ecDocument: String?,
    val ecName: String?,
    val ecNumber: String?,
    val letterTypeTransaction: String?,
    val version: String?,
    val getnetLogo: String?,
    val dateTime: String?,
    val nsu: String?,
    val terminal: String?
)