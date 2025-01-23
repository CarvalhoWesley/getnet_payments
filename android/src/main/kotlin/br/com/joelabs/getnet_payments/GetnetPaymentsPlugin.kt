package br.com.joelabs.getnet_payments

import android.app.Activity
import android.content.Intent
import android.net.Uri
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import com.google.gson.Gson
import br.com.joelabs.getnet_payments.usecases.PosUsecase

/** GetnetPaymentsPlugin */
class GetnetPaymentsPlugin : FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware {
  private lateinit var channel: MethodChannel
  private var activity: Activity? = null
  private var deeplinkUsecase: DeeplinkUsecase? = null
  private var posUsecase: PosUsecase? = null

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
      channel = MethodChannel(flutterPluginBinding.binaryMessenger, "getnet_payments")
      channel.setMethodCallHandler(this)
  }

  override fun onDetachedFromEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
      channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
      activity = binding.activity

      // Inicializar os casos de uso com o contexto ou atividade
      deeplinkUsecase = DeeplinkUsecase(activity)
      posUsecase = PosUsecase(activity!!)

      // Conecta ao serviço PosDigital
      posUsecase?.connectPosDigitalService()

      // Registrar o ActivityResultListener
      binding.addActivityResultListener { requestCode, resultCode, data ->
          if (requestCode == DeeplinkUsecase.REQUEST_CODE_PAYMENT) {
              deeplinkUsecase?.handleActivityResult(resultCode, data)
              true
          } else {
              false
          }
      }
  }

  override fun onDetachedFromActivity() {
      posUsecase?.disconnectPosDigitalService()
      activity = null
      deeplinkUsecase = null
      posUsecase = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
      onAttachedToActivity(binding)
  }

  override fun onDetachedFromActivityForConfigChanges() {
      onDetachedFromActivity()
  }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
      when (call.method) {
          // Métodos relacionados ao DeeplinkUsecase
          "paymentDeeplink" -> deeplinkUsecase?.doPayment(call, result)
          "refundDeeplink" -> deeplinkUsecase?.doRefund(call, result)

          // Métodos relacionados ao PosUsecase
          "print" -> posUsecase?.print(call, result)
              
          else -> 
              result.notImplemented()
          
      }
  }
}