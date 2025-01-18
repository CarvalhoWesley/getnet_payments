package br.com.joelabs.getnet_payments

import android.app.Activity
import android.content.Intent
import android.net.Uri
import androidx.activity.result.ActivityResultCallback
import androidx.activity.result.contract.ActivityResultContracts
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import com.google.gson.Gson

/** GetnetPaymentsPlugin */
class GetnetPaymentsPlugin: FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null
    private var activityBinding: ActivityPluginBinding? = null
    private var pendingResult: MethodChannel.Result? = null

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "getnet_payments")
    channel.setMethodCallHandler(this)
  }

  override fun onDetachedFromEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
      channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
    activityBinding = binding

    // Registrar o ActivityResultListener
    activityBinding?.addActivityResultListener { requestCode, resultCode, data ->
        if (requestCode == REQUEST_CODE_PAYMENT) {
            handleActivityResult(resultCode, data)
            true
        } else {
            false
        }
    }
  }

  override fun onDetachedFromActivity() {
      activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
      onAttachedToActivity(binding)
  }

  override fun onDetachedFromActivityForConfigChanges() {
      onDetachedFromActivity()
  }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    when (call.method) {
      "paymentDeeplink" -> {
        val paymentType = call.argument<String>("paymentType")
        val creditType = call.argument<String>("creditType")
        val installments = call.argument<Int>("installment")
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

        if (!creditType.isNullOrEmpty()) {
            uriBuilder.appendQueryParameter("creditType", creditType)
        }

        if (installments != null && installments > 0) { // Verifica se não é nulo e maior que zero
          uriBuilder.appendQueryParameter("installments", installments.toString())
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
      else -> {
        result.notImplemented()
      }
    }
  }

  private fun handleActivityResult(resultCode: Int, data: Intent?) {
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
        "pixPayloadResponse" to data.getStringExtra("pixPayloadResponse")
      )

      // Converter o objeto para uma JSON String
      val gson = Gson()
      val transactionJson = gson.toJson(transaction)
      pendingResult?.success(transactionJson)
    } else {
        pendingResult?.error("CANCELLED", "Payment was cancelled or failed", null)
    }
    pendingResult = null
}

companion object {
    private const val REQUEST_CODE_PAYMENT = 1001
}
}
