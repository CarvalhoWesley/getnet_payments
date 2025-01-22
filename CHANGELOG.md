## [0.0.2] - 2025-01-22

### Added

- Added `creditType` param to payment method.
- Added new subclasses in Transaction class.
- Added refund feature.

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
