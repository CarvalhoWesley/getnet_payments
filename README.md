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
- Configuração para parcelamentos (até 12 vezes para crédito).
- Retorno estruturado da transação com detalhes como **resultDetails**, **authorizationCode** e outros.

## Instalação

Adicione o plugin ao seu arquivo `pubspec.yaml`:

```yaml
dependencies:
  getnet_payments: ^0.0.1
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
      callerId: Uuid().v4(), // Identificador único do cliente
      installment: 3, // Número de parcelas
    );

    if (transaction != null && transaction.result == "0") {
      print("Pagamento realizado com sucesso!");
      print("ID da transação: ${transaction.nsu}");
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
| `paymentType` | `PaymentTypeEnum` | Tipo de pagamento (`PaymentTypeEnum.credit`, `PaymentTypeEnum.debit`, `PaymentTypeEnum.voucher` ou `PaymentTypeEnum.pix` |
| `callerId`    | `String`          | Identificador único do cliente.                                                                                          |
| `installment` | `int`             | Número de parcelas (entre 1 e 12). Apenas 1 para pagamentos no débito.                                                   |

### Retorno

O método `payment` retorna um objeto `Transaction?` contendo as informações da transação.

#### Exemplo de Objeto `Transaction`

```json
{
  "result": "0",
  "amount": 150.0,
  "type": "02 - Débito",
  "installment": 3,
  "callerId": "abcd123456"
}
```

## Enumeração `PaymentTypeEnum`

| Valor     | Descrição              |
| --------- | ---------------------- |
| `credit`  | Pagamento no crédito.  |
| `debit`   | Pagamento no débito.   |
| `voucher` | Pagamento com voucher. |
| `pix`     | Pagamento com PIX.     |

## Contribuição

Contribuições são bem-vindas! Para reportar problemas ou sugerir melhorias, utilize a [página de issues](https://github.com/CarvalhoWesley/getnet_payments/issues).

## Licença

Este projeto está licenciado sob a licença MIT. Veja o arquivo [LICENSE](https://github.com/CarvalhoWesley/getnet_payments/blob/main/LICENSE) para mais detalhes.
