import 'package:flutter/material.dart';

/// Origem de uma mensagem de log.
enum LogSource {
  pos('POS', Colors.blue),
  deeplink('Deeplink', Colors.deepPurple),
  nfc('NFC', Colors.teal),
  system('Sistema', Colors.grey);

  final String label;
  final Color color;

  const LogSource(this.label, this.color);
}

class LogEntry {
  final DateTime time;
  final LogSource source;
  final String message;
  final bool isError;

  LogEntry(this.source, this.message, {this.isError = false})
      : time = DateTime.now();

  String get timeLabel =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:'
      '${time.second.toString().padLeft(2, '0')}';

  @override
  String toString() =>
      '[$timeLabel] [${source.label}]${isError ? ' ERRO' : ''} $message';
}

/// Log central do app: todas as telas registram aqui e a aba Logs exibe.
/// Cada mensagem também vai para o console de debug.
class AppLog {
  AppLog._();

  static final entries = ValueNotifier<List<LogEntry>>([]);

  static void add(LogSource source, String message, {bool isError = false}) {
    final entry = LogEntry(source, message, isError: isError);
    debugPrint(entry.toString());
    entries.value = [entry, ...entries.value];
  }

  static void clear() => entries.value = [];
}
