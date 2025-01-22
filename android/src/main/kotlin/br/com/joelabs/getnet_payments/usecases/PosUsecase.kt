package br.com.joelabs.getnet_payments.usecases

import android.content.Context
import android.os.RemoteException
import com.getnet.posdigital.PosDigital
import com.getnet.posdigital.camera.ICameraCallback
import com.getnet.posdigital.mifare.IMifareCallback
import com.getnet.posdigital.printer.AlignMode
import com.getnet.posdigital.printer.FontFormat
import com.getnet.posdigital.printer.IPrinterCallback
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.logging.Level
import java.util.logging.Logger
import java.util.regex.Pattern
import org.json.JSONException
import android.graphics.Bitmap

class PosUsecase(private val context: Context) {

    private val logger = Logger.getLogger(PosUsecase::class.java.name)

    fun connectPosDigitalService() {
        try {
            PosDigital.register(context, object : PosDigital.BindCallback {
                override fun onError(e: Exception) {
                    logger.log(Level.SEVERE, "Failed to connect to PosDigital: ${e.message}")
                    reconnect()
                }

                override fun onConnected() {
                    logger.info("PosDigital connected successfully!")
                }

                override fun onDisconnected() {
                    logger.info("PosDigital disconnected.")
                }
            })
        } catch (e: Exception) {
            logger.log(Level.SEVERE, "Exception while registering PosDigital: ${e.message}")
        }
    }

    fun disconnectPosDigitalService() {
        try {
            if (PosDigital.getInstance().isInitiated) {
                PosDigital.unregister(context)
                logger.info("PosDigital service unregistered.")
            }
        } catch (e: Exception) {
            logger.log(Level.SEVERE, "Error while unregistering PosDigital: ${e.message}")
        }
    }

    private fun reconnect() {
        try {
            disconnectPosDigitalService()
            connectPosDigitalService()
        } catch (e: Exception) {
            logger.log(Level.SEVERE, "Error while reconnecting to PosDigital: ${e.message}")
        }
    }

    fun print(call: MethodCall, result: MethodChannel.Result) {
        val instructions = call.argument<List<Map<String, Any>>>("instructions")
        if (instructions.isNullOrEmpty()) {
            result.error("INVALID_ARGUMENTS", "Instructions list cannot be null or empty.", null)
            return
        }

        try {
            // Inicializa a impressora
            PosDigital.getInstance().getPrinter().init()
            PosDigital.getInstance().getPrinter().setGray(10)

            // Processa cada instrução
            for (instruction in instructions) {
                processInstruction(instruction)
            }

            // Chama o método de impressão
            PosDigital.getInstance().getPrinter().print(object : IPrinterCallback.Stub() {
                override fun onSuccess() {
                    result.success("Printed successfully.")
                }

                override fun onError(cause: Int) {
                    val errorMessage = mapPrinterError(cause)
                    result.error("PRINT_ERROR", errorMessage, null)
                }
            })

        } catch (e: RemoteException) {
            result.error("PRINT_ERROR", "Failed to print: ${e.message}", null)
        } catch (e: JSONException) {
            result.error("JSON_ERROR", "Invalid instruction format: ${e.message}", null)
        } catch (e: Exception) {
            result.error("UNKNOWN_ERROR", "Unexpected error: ${e.message}", null)
        }
    }

    private fun processInstruction(instruction: Map<String, Any>) {
        val type = instruction["type"] as? String ?: throw JSONException("Instruction must have a 'type' field.")
        val align = mapAlignMode(instruction["align"] as? String ?: "LEFT")
    
        // Configura o formato da fonte (int), se especificado
        val fontFormat = mapFontFormat(instruction["fontFormat"] as? String ?: "MEDIUM")
        PosDigital.getInstance().getPrinter().defineFontFormat(fontFormat)
    
        when (type) {
            "text" -> {
                val text = instruction["content"] as? String ?: throw JSONException("Text instruction must have 'content'.")
                PosDigital.getInstance().getPrinter().addText(align, text)
            }
            "qrcode" -> {
                val content = instruction["content"] as? String ?: throw JSONException("QR code instruction must have 'content'.")
                val height = (instruction["height"] as? Int) ?: 300
                PosDigital.getInstance().getPrinter().addQrCode(align, height, content)
            }
            "barcode" -> {
                val content = instruction["content"] as? String ?: throw JSONException("Barcode instruction must have 'content'.")
                PosDigital.getInstance().getPrinter().addBarCode(align, content)
            }
            "linewrap" -> {
                var lines = (instruction["lines"] as? Int) ?: 1
                while (lines-- > 0)
                    PosDigital.getInstance().getPrinter().addText(align, "\n")
            }
            "image" -> {
                val base64Image = instruction["content"] as? String ?: throw JSONException("Image instruction must have 'content'.")
                val bitmap = decodeBase64ToBitmap(base64Image)
                PosDigital.getInstance().getPrinter().addImageBitmap(align, bitmap)
            }
            else -> {
                throw JSONException("Unsupported instruction type: $type")
            }
        }
    }

    private fun mapAlignMode(align: String): Int {
        return when (align.uppercase()) {
            "CENTER" -> AlignMode.CENTER
            "RIGHT" -> AlignMode.RIGHT
            else -> AlignMode.LEFT
        }
    }

    private fun mapPrinterError(cause: Int): String {
        return when (cause) {
            0 -> "OK"
            1 -> "Printing"
            2 -> "Printer not initialized"
            3 -> "Printer overheating"
            4 -> "Buffer overflow"
            5 -> "Invalid parameters"
            10 -> "Printer door open"
            11 -> "Temperature too low for printing"
            12 -> "Low battery"
            13 -> "Stepper motor issues"
            15 -> "No paper"
            16 -> "Paper roll is ending"
            17 -> "Paper jam"
            else -> "Unknown error"
        }
    }

    private fun mapFontFormat(fontFormat: String): Int {
        return when (fontFormat.uppercase()) {
            "SMALL" -> FontFormat.SMALL // 48 caracteres por linha
            "LARGE" -> FontFormat.LARGE // 32 caracteres por linha
            else -> FontFormat.MEDIUM   // 32 caracteres por linha (padrão)
        }
    }

    private fun decodeBase64ToBitmap(base64Image: String): Bitmap {
        val decodedBytes = android.util.Base64.decode(base64Image, android.util.Base64.DEFAULT)
        return android.graphics.BitmapFactory.decodeByteArray(decodedBytes, 0, decodedBytes.size)
    }
}
