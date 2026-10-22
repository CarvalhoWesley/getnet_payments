package br.com.joelabs.getnet_payments.usecases

import android.os.Handler
import android.os.Looper
import com.getnet.posdigital.PosDigital
import com.getnet.posdigital.mifare.IMifareCallback
import com.getnet.posdigital.mifare.IMifareService
import com.getnet.posdigital.mifare.MifareStatus
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.CountDownLatch
import java.util.concurrent.Executors
import java.util.concurrent.TimeUnit
import java.util.concurrent.atomic.AtomicBoolean
import java.util.logging.Level
import java.util.logging.Logger

/**
 * API NFC genérica (Mifare Classic 1K/4K) sobre o IMifareService do PosDigital.
 *
 * Cada operação é feita numa única aproximação: aguarda o cartão (searchCard),
 * ativa, autentica, executa e encerra com halt().
 */
class NfcUsecase {

    private val logger = Logger.getLogger(NfcUsecase::class.java.name)
    private val executor = Executors.newSingleThreadExecutor()
    private val mainHandler = Handler(Looper.getMainLooper())
    private val aborted = AtomicBoolean(false)

    fun readCardId(call: MethodCall, result: MethodChannel.Result) {
        runOperation(result) { mifare, cardType ->
            val serial = mifare.getCardSerialNo(cardType)
            if (serial.isNullOrEmpty()) throw NfcException("READ_ERROR", "Não foi possível ler o UID do cartão")
            serial.replace(" ", "").uppercase()
        }
    }

    fun readBlock(call: MethodCall, result: MethodChannel.Result) {
        val block = call.argument<Int>("block") ?: -1
        if (!isValidBlock(block)) return invalidBlock(block, result)

        runOperation(result) { mifare, cardType ->
            authenticate(mifare, call, block)
            hexToBytes(readRaw(mifare, block))
        }
    }

    fun writeBlock(call: MethodCall, result: MethodChannel.Result) {
        val block = call.argument<Int>("block") ?: -1
        if (!isValidBlock(block) || block == 0 || isTrailer(block)) return invalidBlock(block, result)

        val data = call.argument<ByteArray>("data") ?: ByteArray(0)
        if (data.size > BLOCK_SIZE) {
            result.error("INVALID_DATA", "O bloco aceita no máximo $BLOCK_SIZE bytes", null)
            return
        }
        val padded = data.copyOf(BLOCK_SIZE)

        runOperation(result) { mifare, cardType ->
            authenticate(mifare, call, block)
            checkStatus("WRITE_ERROR", mifare.writeBlock(block, bytesToHex(padded)))

            // Relê na mesma aproximação para confirmar a gravação.
            val written = hexToBytes(readRaw(mifare, block))
            if (!written.contentEquals(padded)) {
                throw NfcException("WRITE_NOT_CONFIRMED", "Bloco lido após gravar: ${bytesToHex(written)}")
            }
            true
        }
    }

    fun debugReadBlock(call: MethodCall, result: MethodChannel.Result) {
        val block = call.argument<Int>("block") ?: -1
        if (!isValidBlock(block)) return invalidBlock(block, result)

        runOperation(result) { mifare, cardType ->
            authenticate(mifare, call, block)
            val raw = mifare.readBlock(block)
            "cardType=$cardType\nsector=${sectorOf(block)}\nblock=$block\nraw=[$raw]\nlength=${raw?.length}"
        }
    }

    fun abort(call: MethodCall, result: MethodChannel.Result) {
        aborted.set(true)
        try {
            PosDigital.getInstance().getMifare()?.halt()
        } catch (e: Exception) {
            logger.log(Level.WARNING, "halt ao abortar NFC: ${e.message}")
        }
        result.success(true)
    }

    // ===== Sessão: várias operações na mesma aproximação (detect -> read/write... -> powerOff) =====

    private var session: IMifareService? = null

    fun sessionDetectCard(call: MethodCall, result: MethodChannel.Result) {
        aborted.set(false)
        execute(result) {
            haltQuietly(session)
            session = null
            val mifare = requireMifare()
            val cardType = waitCard(mifare)
            checkStatus("NFC_ERROR", mifare.activate(cardType))
            session = mifare
            mifare.getCardSerialNo(cardType)?.replace(" ", "")?.uppercase() ?: ""
        }
    }

    fun sessionReadBlock(call: MethodCall, result: MethodChannel.Result) {
        val block = call.argument<Int>("block") ?: -1
        if (!isValidBlock(block)) return invalidBlock(block, result)

        execute(result) {
            val mifare = requireSession()
            authenticate(mifare, call, block)
            hexToBytes(readRaw(mifare, block))
        }
    }

    fun sessionWriteBlock(call: MethodCall, result: MethodChannel.Result) {
        val block = call.argument<Int>("block") ?: -1
        if (!isValidBlock(block) || block == 0 || isTrailer(block)) return invalidBlock(block, result)
        val data = call.argument<ByteArray>("data") ?: ByteArray(0)
        if (data.size > BLOCK_SIZE) {
            result.error("INVALID_DATA", "O bloco aceita no máximo $BLOCK_SIZE bytes", null)
            return
        }

        execute(result) {
            val mifare = requireSession()
            authenticate(mifare, call, block)
            checkStatus("WRITE_ERROR", mifare.writeBlock(block, bytesToHex(data.copyOf(BLOCK_SIZE))))
            true
        }
    }

    fun sessionPowerOff(call: MethodCall, result: MethodChannel.Result) {
        execute(result) {
            haltQuietly(session)
            session = null
            true
        }
    }

    private fun requireSession(): IMifareService =
        session ?: throw NfcException("NO_CARD", "Nenhum cartão detectado na sessão")

    // ===== Internos =====

    private fun runOperation(result: MethodChannel.Result, operation: (IMifareService, Int) -> Any) {
        aborted.set(false)
        execute(result) {
            val mifare = requireMifare()
            try {
                val cardType = waitCard(mifare)
                checkStatus("NFC_ERROR", mifare.activate(cardType))
                operation(mifare, cardType)
            } finally {
                haltQuietly(mifare)
            }
        }
    }

    // As chamadas ao serviço são bloqueantes, por isso rodam fora da main thread.
    private fun execute(result: MethodChannel.Result, operation: () -> Any) {
        executor.execute {
            var reply: Runnable
            try {
                val value = operation()
                reply = Runnable { result.success(value) }
            } catch (e: NfcException) {
                logger.log(Level.WARNING, "NFC ${e.code}: ${e.message}")
                reply = Runnable { result.error(e.code, e.message, null) }
            } catch (e: Exception) {
                logger.log(Level.SEVERE, "NFC: ${e.message}")
                reply = Runnable { result.error("NFC_ERROR", e.message, e.toString()) }
            }
            mainHandler.post(reply)
        }
    }

    private fun haltQuietly(mifare: IMifareService?) {
        try {
            mifare?.halt()
        } catch (e: Exception) {
            logger.log(Level.WARNING, "halt: ${e.message}")
        }
    }

    private fun requireMifare(): IMifareService {
        val posDigital = PosDigital.getInstance()
        if (!posDigital.isInitiated()) throw NfcException("NO_SERVICE", "Serviço PosDigital não conectado")
        return posDigital.getMifare() ?: throw NfcException("NO_SERVICE", "Serviço Mifare indisponível")
    }

    // searchCard devolve o tipo do cartão por callback; bloqueia até o cartão ser aproximado.
    private fun waitCard(mifare: IMifareService): Int {
        val latch = CountDownLatch(1)
        var cardType: Int? = null
        var error: String? = null

        mifare.searchCard(object : IMifareCallback.Stub() {
            override fun onCard(type: Int) {
                cardType = type
                latch.countDown()
            }

            override fun onError(message: String?) {
                error = message
                latch.countDown()
            }
        })

        while (!latch.await(200, TimeUnit.MILLISECONDS)) {
            if (aborted.get()) throw NfcException("ABORTED", "Leitura NFC cancelada")
        }
        if (aborted.get()) throw NfcException("ABORTED", "Leitura NFC cancelada")
        return cardType ?: throw NfcException("NO_CARD", error ?: "Nenhum cartão detectado")
    }

    private fun authenticate(mifare: IMifareService, call: MethodCall, block: Int) {
        val key = call.argument<ByteArray>("key") ?: DEFAULT_KEY
        if (key.size != 6) throw NfcException("INVALID_DATA", "A chave Mifare deve ter 6 bytes")
        val keyB = call.argument<Int>("keyType") == 1
        val sector = sectorOf(block)

        val sectorStatus = if (keyB) mifare.authenticateSectorWithKeyB(sector, key)
        else mifare.authenticateSectorWithKeyA(sector, key)
        checkStatus("AUTH_ERROR", sectorStatus)

        val blockStatus = if (keyB) mifare.authenticateBlockWithKeyB(block, key)
        else mifare.authenticateBlockWithKeyA(block, key)
        checkStatus("AUTH_ERROR", blockStatus)
    }

    private fun readRaw(mifare: IMifareService, block: Int): String =
        mifare.readBlock(block) ?: throw NfcException("READ_ERROR", "Falha ao ler o bloco $block")

    private fun checkStatus(code: String, status: Int) {
        if (status != MifareStatus.SUCCESS) throw NfcException(code, statusName(status))
    }

    private fun invalidBlock(block: Int, result: MethodChannel.Result) {
        result.error("INVALID_BLOCK", "Bloco inválido: $block", null)
    }

    private class NfcException(val code: String, message: String) : Exception(message)

    companion object {
        private const val BLOCK_SIZE = 16
        private const val MAX_BLOCK = 255 // Mifare Classic 4K
        private val DEFAULT_KEY = ByteArray(6) { 0xFF.toByte() }

        fun isValidBlock(block: Int) = block in 0..MAX_BLOCK

        // 4K: setores 0-31 têm 4 blocos; setores 32-39 têm 16 blocos.
        fun sectorOf(block: Int) = if (block < 128) block / 4 else 32 + (block - 128) / 16

        fun isTrailer(block: Int) = if (block < 128) block % 4 == 3 else (block - 128) % 16 == 15

        fun bytesToHex(bytes: ByteArray) = bytes.joinToString("") { "%02X".format(it) }

        // O SDK devolve o bloco em hex; se vier em outro formato, devolve os bytes do texto.
        fun hexToBytes(raw: String): ByteArray {
            val hex = raw.replace(" ", "")
            if (hex.length % 2 != 0 || !hex.all { it.isDigit() || it.uppercaseChar() in 'A'..'F' }) {
                return raw.toByteArray(Charsets.UTF_8)
            }
            return ByteArray(hex.length / 2) { hex.substring(it * 2, it * 2 + 2).toInt(16).toByte() }
        }

        fun statusName(status: Int) = when (status) {
            MifareStatus.HALT -> "HALT"
            MifareStatus.SERVICE_CRASH -> "SERVICE_CRASH"
            MifareStatus.REQUEST_EXCEPTION -> "REQUEST_EXCEPTION"
            MifareStatus.INVALID_CALL -> "INVALID_CALL"
            MifareStatus.NOT_ACTIVATE -> "NOT_ACTIVATE"
            MifareStatus.NOTAGERR -> "NOTAGERR"
            MifareStatus.ERRPARAM -> "ERRPARAM"
            MifareStatus.IC_SWDIFF -> "IC_SWDIFF"
            MifareStatus.TRANSERR -> "TRANSERR"
            MifareStatus.PROTERR -> "PROTERR"
            MifareStatus.MULTIERR -> "MULTIERR"
            MifareStatus.TIMEOUT -> "TIMEOUT"
            MifareStatus.CARDNOACT -> "CARDNOACT"
            else -> "STATUS_$status"
        }
    }
}
