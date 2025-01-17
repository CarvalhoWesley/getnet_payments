package br.com.joelabs.getnet_payments

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import androidx.activity.result.ActivityResultCallback
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity

class DeeplinkUsecase(private val context: AppCompatActivity) {

    // Função para processar o pagamento via Deeplink e aguardar o resultado
    fun doPayment(
        amount: Double,
        paymentType: String,
        callerId: String,
        installment: Int?,
        callback: (Boolean) -> Unit // Chamada de retorno para Flutter
    ) {
        try {
            // Validar tipo de pagamento
            if (paymentType == "credit" || paymentType == "debit" || paymentType == "voucher") {
                val amountInCents = (amount * 100).toInt()  // Converte para centavos (ex: 100.50 -> 10050)
                val formattedAmount = String.format("%012d", amountInCents)  // Formata para 12 dígitos com zeros à esquerda

                // Lógica para criar o Intent com o Deeplink da Getnet
                val bundle = Bundle()
                bundle.putString("amount", formattedAmount)
                bundle.putString("currencyPosition", "CURRENCY_BEFORE_AMOUNT")
                bundle.putString("currencyCode", "986")
                bundle.putString("paymentType", paymentType)
                bundle.putString("callerId", callerId)

                // Criação do Intent para abrir o deeplink
                val intent = Intent(Intent.ACTION_VIEW, Uri.parse("getnet://pagamento/v3/payment"))
                intent.putExtras(bundle)

                // Use o ActivityResultContracts para aguardar o resultado
                val startForResult =
                    context.registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
                        if (result.resultCode == AppCompatActivity.RESULT_OK) {
                            callback(true) // Pagamento finalizado com sucesso
                        } else {
                            callback(false) // Pagamento não concluído ou falhou
                        }
                    }

                // Inicia a atividade e aguarda o resultado
                startForResult.launch(intent)

            } else {
                callback(false) // Tipo de pagamento inválido
            }
        } catch (e: Exception) {
            callback(false) // Caso de erro
        }
    }
}
