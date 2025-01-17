package br.com.joelabs.getnet_payments

import android.content.Context
import android.content.Intent
import android.net.Uri
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

import androidx.appcompat.app.AppCompatActivity
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

/** GetnetPaymentsPlugin */
class GetnetPaymentsPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  private lateinit var channel : MethodChannel
  private var activity: AppCompatActivity? = null

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "getnet_payments")
    channel.setMethodCallHandler(this)
  }

  override fun onDetachedFromEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
      channel.setMethodCallHandler(null)
  }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    when (call.method) {
      "paymentDeeplink" -> {
          handleDeeplink(result)
      }
      else -> {
        result.notImplemented()
      }
    }
  }
  // ActivityAware methods
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity as AppCompatActivity // Atribuindo a Activity corretamente
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity as AppCompatActivity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

  private fun handleDeeplink(result: MethodChannel.Result) {
    // Chama o Deeplink, isso pode ser uma chamada de Intent ou outra lógica do seu usecase
    val success = openDeeplink()

    // Retorna o resultado de volta para o Flutter
    if (success) {
      result.success("Deeplink aberto com sucesso.")
    } else {
      result.error("DEEP_LINK_FAILED", "Falha ao abrir o deeplink.", null)
    }
  }

  fun openDeeplink(): Boolean {
    try {
      val intent = Intent(Intent.ACTION_VIEW, Uri.parse("getnet://pagamento/v3/payment"))
      activity!!.startActivity(intent)
      return true
    } catch (e: Exception) {
      e.printStackTrace()
      return false
    }
  }
}
