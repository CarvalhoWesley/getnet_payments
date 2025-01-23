import 'package:flutter_test/flutter_test.dart';
import 'package:getnet_payments/enums/pos/align_mode_enum.dart';
import 'package:getnet_payments/enums/pos/font_format_enum.dart';
import 'package:mockito/mockito.dart';
import 'package:getnet_payments/getnet_pos.dart';
import 'package:getnet_payments/getnet_pos_platform_interface.dart';
import 'package:getnet_payments/models/pos/item_print_model.dart';

class MockGetnetPosPlatform extends Mock implements GetnetPosPlatform {
  @override
  Future<String?> print(List<ItemPrintModel> items) async {
    return super.noSuchMethod(
      Invocation.method(#print, [items]),
      returnValue: "Printed successfully",
    );
  }
}

void main() {
  late GetnetPos getnetPos;
  late MockGetnetPosPlatform mockPlatform;

  setUp(() {
    mockPlatform = MockGetnetPosPlatform();
    GetnetPosPlatform.instance = mockPlatform;
    getnetPos = GetnetPos();
  });

  group('GetnetPos.print', () {
    final List<ItemPrintModel> mockItems = [
      ItemPrintModel.text(
        content: "TEXTO CENTRALIZADO",
        align: AlignModeEnum.center,
        fontFormat: FontFormatEnum.medium,
      ),
      ItemPrintModel.qrcode(
        content: "https://example.com",
        align: AlignModeEnum.center,
      ),
    ];

    test('should call platform implementation with correct arguments',
        () async {
      // Configurando o mock para retornar sucesso
      when(mockPlatform.print(mockItems))
          .thenAnswer((_) async => "Printed successfully");

      final result = await getnetPos.print(mockItems);

      // Verificando os resultados
      expect(result, equals("Printed successfully"));
      verify(mockPlatform.print(mockItems)).called(1);
    });

    test('should return null when platform implementation fails', () async {
      // Configurando o mock para retornar null
      when(mockPlatform.print(mockItems)).thenAnswer((_) async => null);

      final result = await getnetPos.print(mockItems);

      // Verificando os resultados
      expect(result, isNull);
      verify(mockPlatform.print(mockItems)).called(1);
    });

    test('should throw exception when platform implementation throws',
        () async {
      // Configurando o mock para lançar uma exceção
      when(mockPlatform.print(mockItems)).thenThrow(Exception("Print failed"));

      expect(
        () => getnetPos.print(mockItems),
        throwsA(isA<Exception>()),
      );

      // Verificando que o método foi chamado
      verify(mockPlatform.print(mockItems)).called(1);
    });
  });
}
