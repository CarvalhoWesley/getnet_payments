import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:getnet_payments/enums/pos/align_mode_enum.dart';
import 'package:getnet_payments/enums/pos/font_format_enum.dart';
import 'package:getnet_payments/getnet_pos_method_channel.dart';
import 'package:getnet_payments/models/pos/item_print_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized(); // Inicializa o binding

  const MethodChannel channel = MethodChannel('getnet_payments');
  late MethodChannelGetnetPos methodChannelGetnetPos;
  late List<MethodCall> log;

  setUp(() {
    methodChannelGetnetPos = MethodChannelGetnetPos();
    log = [];

    // Configurando o mock do MethodChannel
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      log.add(methodCall);
      if (methodCall.method == 'print') {
        return "Printed successfully"; // Mock de resposta
      }
      return null;
    });
  });

  tearDown(() {
    // Limpando o mock do MethodChannel
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  group('MethodChannelGetnetPos.print', () {
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

    test('should invoke print with correct arguments', () async {
      final result = await methodChannelGetnetPos.print(mockItems);

      // Verificando o resultado
      expect(result, equals("Printed successfully"));

      // Verificando a chamada do MethodChannel
      expect(log, hasLength(1));
      expect(log.first.method, 'print');
      expect(log.first.arguments, mockItems.map((e) => e.toMap()).toList());
    });

    test('should return null when no items are provided', () async {
      final result = await methodChannelGetnetPos.print([]);

      // Verificando que o resultado é nulo
      expect(result, isNull);

      // Verificando que o método não foi chamado
      expect(log, isEmpty);
    });

    test('should prevent concurrent print operations', () async {
      // Simulando a operação em progresso
      methodChannelGetnetPos.printInProgress = true;

      final result = await methodChannelGetnetPos.print(mockItems);

      // Verificando que a operação não prosseguiu
      expect(result, isNull);
      expect(log, isEmpty);
    });

    test('should throw exception when method channel fails', () async {
      // Configurando o mock para lançar uma exceção
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        throw PlatformException(
            code: 'ERROR', message: 'Printer not available');
      });

      // Verificando que a exceção é lançada
      expect(
        () => methodChannelGetnetPos.print(mockItems),
        throwsA(isA<PlatformException>()),
      );
    });
  });
}
