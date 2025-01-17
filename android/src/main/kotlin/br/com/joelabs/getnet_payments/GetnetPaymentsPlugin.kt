package br.com.joelabs.getnet_payments

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.util.Log

/** GetnetPaymentsPlugin */
class GetnetPaymentsPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var channel : MethodChannel
  private lateinit var applicationContext: android.content.Context

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "getnet_payments")
    channel.setMethodCallHandler(this)
    applicationContext = flutterPluginBinding.applicationContext
  }

  override fun onDetachedFromEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
      channel.setMethodCallHandler(null)
  }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    when (call.method) {
      "paymentDeeplink" -> {
        // Obter os argumentos do método
        val amount = call.argument<Double>("amount") ?: 0.0

        val formattedAmount = String.format("%012d", (amount * 100).toLong())

        if (formattedAmount.isNotEmpty()) {
            Log.d("GetnetPaymentsPlugin", "Chamado método: paymentDeeplink")
            try {
                // Criar o Intent com Uri e Bundle
                val intent = Intent(Intent.ACTION_VIEW, Uri.parse("getnet://pagamento/v3/payment"))

                // Adicionar os extras ao Bundle
                val bundle = Bundle()
                bundle.putString("amount", formattedAmount)
                bundle.putString("currencyPosition", "CURRENCY_BEFORE_AMOUNT")
                bundle.putString("currencyCode", "986")
                bundle.putString("paymentType", "credit")
                bundle.putString("callerId", "123456789")
                bundle.putString("installments", "1")
                Log.d("GetnetPaymentsPlugin", "Formatted amount: $formattedAmount")

                // Passar o Bundle para o Intent
                intent.putExtras(bundle)

                // Garantir que o Intent será executado
                intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                Log.d("GetnetPaymentsPlugin", "Intent criado com sucesso: $intent")

                applicationContext.startActivity(intent)

                Log.d("GetnetPaymentsPlugin", "Activity iniciada com sucesso")

                // Enviar sucesso de volta para o Flutter
                // result.success("Deeplink called successfully")
            } catch (e: Exception) {
                result.error("INTENT_ERROR", "Failed to launch deeplink: ${e.message}", null)
            }
        } else {
            result.error("INVALID_ARGUMENTS", "Amount is required and cannot be empty", null)
        }
      }
      else -> {
        result.notImplemented()
      }
    }
  }
}
