# Getnet Payments - Plugin Flutter para Pagamentos Getnet (Não Oficial)
<a href="https://www.buymeacoffee.com/carvalhowesley" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important;box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" ></a>

<p>
<a href="https://github.com/CarvalhoWesley" rel="ugc"><img src="https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white" alt="Github Badge"></a>
<a href="https://www.linkedin.com/in/wesleycarvalhodev" rel="ugc"><img src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white" alt="LinkedIn Badge"></a>
</p>


**getnet_payments** é um plugin Flutter (Não Oficial) para integração de pagamentos com a Getnet utilizando **deeplinks**. Ele permite abrir o Intent do deeplink diretamente do aplicativo Flutter e retornar um objeto `Transaction` com o resultado da transação.

## Recursos

- Realize pagamentos via Getnet utilizando **deeplinks**.
- Suporte a pagamentos nos modos **crédito**, **débito**, **voucher** e **PIX**.
- Configuração de parcelamentos.
- Retorno estruturado da transação com detalhes como **calledId**, **authorizationCode** e outros.

## Recomendações
Recomendamos que você leia a [documentação oficial da Getnet](https://getstore.getnet.com.br/docs) para obter mais informações sobre a integração de pagamentos.

## Instalação

Adicione o plugin ao seu arquivo `pubspec.yaml`:

```yaml
dependencies:
  getnet_payments: any
```

Em seguida, execute o comando:

```bash
flutter pub get
```

## Configuração

### Android

1. Certifique-se de que o pacote contém a permissão para acesso à internet.

```xml
<uses-permission android:name="android.permission.INTERNET" />
```

2. Altere o minSdkVersion para 22 ou superior no arquivo `android/app/build.gradle`.

```gradle
android {
    defaultConfig {
        minSdkVersion 22
        targetSdkVersion 33 // Recomendado para o Android 13
    }
}
```

## Uso

### Importação

```dart
import 'package:getnet_payments/getnet_payments.dart';
```

### Inicialização

Utilize a classe principal `GetnetPayments` para iniciar pagamentos. Veja o exemplo abaixo:

```dart
import 'package:getnet_payments/getnet_payments.dart';

void realizarPagamento() async {
  try {
    final transaction = await GetnetPayments.deeplink.payment(
      amount: 150.00,
      paymentType: PaymentTypeEnum.credit,
      callerId: Uuid().v4(), // Identificador único da transação
      installment: 1, // Número de parcelas
    );

    if (transaction != null && transaction.result == "0") {
      print("Pagamento realizado com sucesso!");
      print("ID da Transação: ${transaction.callerId}");
    } else {
      print("Pagamento cancelado ou falhou.");
    }
  } catch (e) {
    print("Erro ao processar pagamento: $e");
  }
}
```

### Parâmetros do Método `payment`

| Parâmetro     | Tipo              | Descrição                                                                                                                |
| ------------- | ----------------- | ------------------------------------------------------------------------------------------------------------------------ |
| `amount`      | `double`          | Valor do pagamento (deve ser maior que zero).                                                                            |
| `paymentType` | `PaymentTypeEnum` | Tipo de pagamento (`PaymentTypeEnum.credit`, `PaymentTypeEnum.debit`, `PaymentTypeEnum.voucher` ou `PaymentTypeEnum.pix`) |
| `callerId`    | `String`          | Identificador único do cliente.                                                                                          |
| `installment` | `int`             | Número de parcelas. Apenas 1 para pagamentos no débito.                                                   |

### Retorno

O método `payment` retorna um objeto `Transaction` contendo as informações da transação.

#### Exemplo de Objeto `Transaction`

```json
{
  "result": "0",
  "resultDetails": "TRANSACAO APROVADA",
  "amount": "000000018975",
  "callerId": "d68d27af-b830-41ab-876e-3ffe7b903504",
  "nsu": "000000048",
  "nsuLastSuccesfullMessage": "0212117132457",
  "cvNumber": "000000048",
  "receiptAlreadyPrinted": false,
  "type": "11",
  "inputType": "051",
  "installments": null,
  "gmtDateTime": "0122114101",
  "nsuLocal": "000090",
  "authorizationCode": "164550",
  "cardBin": "123456",
  "cardLastDigits": "1234",
  "extraScreensResult": null,
  "splitPayloadResponse": null,
  "cardholderName": null,
  "automationSlip": {
    "mandatory_all_receipts_fields": {
      "authorizationCode": "008532",
      "brand": "MASTERCARD",
      "cardLastDigits": "4283",
      "city": "PORTO ALEGRE",
      "ecDocument": "42.130.708/0001-07",
      "ecName": "GETNET DEVELOPERS ESTAB",
      "ecNumber": "000000000034567",
      "letterTypeTransaction": "C",
      "version": "XXX57.0005.0024",
      "getnetLogo": "iVBORw0KGgoAAAANSUhEUgAAAPAAAAA...",
      "dateTime": "09/15/21 17:35:59",
      "nsu": "000000637",
      "terminal": "10001593"
    },
    "mandatory_client_fields": {
      "clientBody": "CREDITO A VISTA VALOR:         1,00",
      "receiptTypeClient": "Via Cliente"
    },
    "mandatory_ec_fields": {
      "aid": "A0000000041010",
      "arqc": "77EE7FFDACF51DB9",
      "ecBody": "CREDITO A VISTA VALOR:         1,00 TRANSACAO APROVADA MEDIANTE USO DE SENHA PESSOAL",
      "nsuLocal": "000302",
      "receiptTypeEc": "Via Estabelecimento"
    }
  },
  "printMerchantPreference": true,
  "orderId": null,
  "pixPayloadResponse": null
}
```

## Enumerador `PaymentTypeEnum`

| Valor     | Descrição              |
| --------- | ---------------------- |
| `credit`  | Pagamento no crédito.  |
| `debit`   | Pagamento no débito.   |
| `voucher` | Pagamento com voucher. |
| `pix`     | Pagamento com PIX.     |

## Enumerador `TransactionResultEnum`

| Valor     | Descrição              |
| --------- | ---------------------- |
| `0`       | Sucesso                |
| `1`       | Negada                 |
| `2`       | Cancelada              |
| `3`       | Falha                  |
| `4`       | Desconhecido           |
| `5`       | Pendente               |

## Contribuição

Contribuições são bem-vindas! Para reportar problemas ou sugerir melhorias, utilize a [página de issues](https://github.com/CarvalhoWesley/getnet_payments/issues).

## Licença

Este projeto está licenciado sob a licença MIT. Veja o arquivo [LICENSE](https://github.com/CarvalhoWesley/getnet_payments/blob/main/LICENSE) para mais detalhes.
