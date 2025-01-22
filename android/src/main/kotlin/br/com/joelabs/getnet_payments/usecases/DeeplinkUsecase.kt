package br.com.joelabs.getnet_payments

import android.app.Activity
import android.content.Intent
import android.net.Uri
import io.flutter.plugin.common.MethodChannel
import com.google.gson.Gson
import io.flutter.plugin.common.MethodCall

class DeeplinkUsecase(private val activity: Activity?) {

    companion object {
        public const val REQUEST_CODE_PAYMENT = 1001
    }

    private var pendingResult: MethodChannel.Result? = null

    fun doPayment(call: MethodCall, result: MethodChannel.Result) {
        val paymentType = call.argument<String>("paymentType")
        val creditType = call.argument<String>("creditType")
        val installments = call.argument<Int>("installments")
        val amount = call.argument<Double>("amount")
        val callerId = call.argument<String>("callerId")

        if (amount == null || amount <= 0) {
            result.error("INVALID_ARGUMENTS", "Invalid amount provided", null)
            return
        }

        // Converte o double para string no formato de 12 dígitos
        val amountFormatted = String.format("%012d", (amount * 100).toLong())

        if (paymentType.isNullOrEmpty() || amountFormatted.isNullOrEmpty() || callerId.isNullOrEmpty()) {
            result.error("INVALID_ARGUMENTS", "Required arguments are missing", null)
            return
        }

        // Construir a URI do deeplink
        val uriBuilder = Uri.Builder()
            .scheme("getnet")
            .authority("pagamento")
            .appendPath("v3")
            .appendPath("payment")
            .appendQueryParameter("paymentType", paymentType)
            .appendQueryParameter("amount", amountFormatted)
            .appendQueryParameter("callerId", callerId)

        if (installments != null && installments > 0) {
            uriBuilder.appendQueryParameter("installments", installments.toString())

            if(installments > 1 && !creditType.isNullOrEmpty()){
                uriBuilder.appendQueryParameter("creditType", creditType)
            }
        }

        val deeplinkUri = uriBuilder.build()
        val intent = Intent(Intent.ACTION_VIEW, deeplinkUri)
        pendingResult = result

        try {
            activity?.startActivityForResult(intent, REQUEST_CODE_PAYMENT)
        } catch (e: Exception) {
            result.error("DEEPLINK_ERROR", "Failed to open deeplink: ${e.localizedMessage}", null)
        }
    }

    fun doRefund(call: MethodCall, result: MethodChannel.Result) {
        val amount = call.argument<Double>("amount")
        val transactionDate = call.argument<String>("transactionDate")
        val cvNumber = call.argument<String>("cvNumber")
        val originTerminal = call.argument<String>("originTerminal")

        if (amount == null || amount <= 0) {
            result.error("INVALID_ARGUMENTS", "Invalid amount provided", null)
            return
        }

        // Converte o double para string no formato de 12 dígitos
        val amountFormatted = String.format("%012d", (amount * 100).toLong())

        if (amountFormatted.isNullOrEmpty()) {
            result.error("INVALID_ARGUMENTS", "Required arguments are missing", null)
            return
        }

        // Construir a URI do deeplink
        val uriBuilder = Uri.Builder()
            .scheme("getnet")
            .authority("pagamento")
            .appendPath("v1")
            .appendPath("refund")
            .appendQueryParameter("amount", amountFormatted)
            .appendQueryParameter("allowPrintCurrentTransaction", "false")
            
        if (!transactionDate.isNullOrEmpty()) {
            uriBuilder.appendQueryParameter("transactionDate", transactionDate)
        }

        if (!cvNumber.isNullOrEmpty()) {
            uriBuilder.appendQueryParameter("cvNumber", cvNumber)
        }

        if (!originTerminal.isNullOrEmpty()) {
            uriBuilder.appendQueryParameter("originTerminal", originTerminal)
        }

        val deeplinkUri = uriBuilder.build()
        val intent = Intent(Intent.ACTION_VIEW, deeplinkUri)
        pendingResult = result

        try {
            activity?.startActivityForResult(intent, REQUEST_CODE_PAYMENT)
        } catch (e: Exception) {
            result.error("DEEPLINK_ERROR", "Failed to open deeplink: ${e.localizedMessage}", null)
        }
    }

    fun handleActivityResult(resultCode: Int, data: Intent?) {
        if (resultCode == Activity.RESULT_OK && data != null) {
            val transaction = mapOf(
                "result" to data.getStringExtra("result"),
                "resultDetails" to data.getStringExtra("resultDetails"),
                "amount" to data.getStringExtra("amount"),
                "callerId" to data.getStringExtra("callerId"),
                "receiptAlreadyPrinted" to data.getBooleanExtra("receiptAlreadyPrinted", false),
                "type" to data.getStringExtra("type"),
                "inputType" to data.getStringExtra("inputType"),
                "nsu" to data.getStringExtra("nsu"),
                "nsuLastSuccesfullMessage" to data.getStringExtra("nsuLastSuccesfullMessage"),
                "cvNumber" to data.getStringExtra("cvNumber"),
                "brand" to data.getStringExtra("brand"),
                "installments" to data.getStringExtra("installments"),
                "gmtDateTime" to data.getStringExtra("gmtDateTime"),
                "nsuLocal" to data.getStringExtra("nsuLocal"),
                "authorizationCode" to data.getStringExtra("authorizationCode"),
                "cardBin" to data.getStringExtra("cardBin"),
                "cardLastDigits" to data.getStringExtra("cardLastDigits"),
                "extraScreensResult" to data.getStringExtra("extraScreensResult"),
                "splitPayloadResponse" to data.getStringExtra("splitPayloadResponse"),
                "cardholderName" to data.getStringExtra("cardholderName"),
                "automationSlip" to data.getStringExtra("automationSlip"),
                "printMerchantPreference" to data.getBooleanExtra("printMerchantPreference", false),
                "orderId" to data.getStringExtra("orderId"),
                "pixPayloadResponse" to data.getStringExtra("pixPayloadResponse"),
                "refundTransactionDate" to data.getStringExtra("refundTransactionDate"),
                "refundCvNumber" to data.getStringExtra("refundCvNumber"),
                "refundOriginTerminal" to data.getStringExtra("refundOriginTerminal")
            )
            val gson = Gson()
            val transactionJson = gson.toJson(transaction)
            pendingResult?.success(transactionJson)
        } else {
            pendingResult?.error("CANCELLED", "Payment was cancelled or failed", null)
        }
        pendingResult = null
    }
}
