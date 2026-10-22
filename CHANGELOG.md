## [1.3.0] - 2026-10-22

### Added

- Generic NFC API (Mifare Classic 1K/4K) via `GetnetPayments.nfc`: `readCardId`, `readBlock`, `writeBlock`, `readBlockText`, `writeBlockText`, `debugReadBlock` and `abort`.
- `MifareKeyTypeEnum` to authenticate with key A or B.
- NFC session (`detectCard`, `sessionReadBlock`, `sessionWriteBlock`, `powerOff`) for several operations in a single tap.
- `GetnetNfcCashless`: event (cashless) card compatible with pagseguro_smart_flutter and stone_payments (`readCard`, `openCard`, `recharge`, `debit`, `refund`, `format`, `formatAll`).
- Example app reorganized (Deeplink · NFC · Logs), with Cartão, Evento and Blocos tabs.
## [1.1.0] - 2025-04-25

### Added

- `allowPrintCurrentTransaction` parameter in payment and refund method.

## [1.0.0] - 2025-03-09

### Added

- Method to check status of the transaction.

#### Example :
```dart
GetnetPayments.deeplink.checkStatus(callerId: '1234567890');
```

### Fixed

- POS Digital Service Register.

## [0.0.4] - 2025-01-23

### Added

- Communication with POS Hardware (Only Printer).
- Method to reprint the last receipt.

## [0.0.2] - 2025-01-22

### Added

- `creditType` param to payment method.
- new subclasses in Transaction class.
- refund feature.

#### Example :
```dart
GetnetPayments.deeplink.refund(
    amount: '000000001256',
    transactionDate: DateTime.now(),
    cvNumber: '123',
);
```

## [0.0.1] - 2025-01-18

- Initial version.
