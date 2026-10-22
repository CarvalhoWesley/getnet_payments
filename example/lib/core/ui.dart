import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getnet_payments/getnet_payments.dart';

import 'app_log.dart';

/// Executa ações com barra de carregamento, registro no log central
/// e um aviso rápido com o resultado.
mixin ActionRunner<T extends StatefulWidget> on State<T> {
  bool busy = false;

  LogSource get logSource;

  Future<void> run(String name, Future<String?> Function() action) async {
    FocusScope.of(context).unfocus();
    setState(() => busy = true);
    AppLog.add(logSource, '$name: iniciado');
    try {
      final result = await action();
      AppLog.add(logSource, '$name OK${result != null ? ': $result' : ''}');
      _toast('$name concluído', error: false);
    } catch (e) {
      final message = describeError(e);
      AppLog.add(logSource, '$name: $message', isError: true);
      _toast('$name falhou: $message', error: true);
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  void _toast(String text, {required bool error}) {
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(SnackBar(
      content: Text(text, maxLines: 2, overflow: TextOverflow.ellipsis),
      backgroundColor: error ? Theme.of(context).colorScheme.error : null,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
    ));
  }
}

String describeError(Object e) {
  if (e is PlatformException) return '[${e.code}] ${e.message ?? ''}';
  if (e is NfcCashlessException) return '[${e.code}] ${e.message}';
  return e.toString();
}

/// Página rolável com a barra de carregamento no topo.
class ActionPage extends StatelessWidget {
  final bool busy;
  final List<Widget> children;

  const ActionPage({super.key, required this.busy, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 3,
          child: busy ? const LinearProgressIndicator() : null,
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: children,
          ),
        ),
      ],
    );
  }
}

/// Bloco com título, descrição opcional e conteúdo.
class Section extends StatelessWidget {
  final String title;
  final String? hint;
  final List<Widget> children;

  const Section(
      {super.key, required this.title, this.hint, required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: theme.textTheme.titleMedium),
            if (hint != null) ...[
              const SizedBox(height: 4),
              Text(hint!,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

/// Campos lado a lado que quebram linha em telas estreitas.
class FieldWrap extends StatelessWidget {
  final List<Widget> children;

  const FieldWrap({super.key, required this.children});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Wrap(spacing: 12, runSpacing: 12, children: children),
      );
}

class AppField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool numeric;
  final bool hex;
  final double width;

  const AppField({
    super.key,
    required this.controller,
    required this.label,
    this.numeric = false,
    this.hex = false,
    this.width = 150,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        keyboardType: numeric
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        inputFormatters: [
          if (hex) FilteringTextInputFormatter.allow(RegExp(r'[0-9a-fA-F ]')),
          if (numeric) FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
        ],
        decoration: InputDecoration(
          labelText: label,
          isDense: true,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

/// Botões de ação em grade fluida.
class ActionWrap extends StatelessWidget {
  final List<Widget> children;

  const ActionWrap({super.key, required this.children});

  @override
  Widget build(BuildContext context) =>
      Wrap(spacing: 8, runSpacing: 8, children: children);
}

class ActionButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool primary;
  final bool danger;

  const ActionButton({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
    this.primary = false,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final child = Text(label);
    final iconWidget = icon != null ? Icon(icon, size: 18) : null;

    if (danger) {
      final style = FilledButton.styleFrom(
          backgroundColor: scheme.error, foregroundColor: scheme.onError);
      return iconWidget != null
          ? FilledButton.icon(
              onPressed: onPressed,
              style: style,
              icon: iconWidget,
              label: child)
          : FilledButton(onPressed: onPressed, style: style, child: child);
    }
    if (primary) {
      return iconWidget != null
          ? FilledButton.icon(
              onPressed: onPressed, icon: iconWidget, label: child)
          : FilledButton(onPressed: onPressed, child: child);
    }
    return iconWidget != null
        ? OutlinedButton.icon(
            onPressed: onPressed, icon: iconWidget, label: child)
        : OutlinedButton(onPressed: onPressed, child: child);
  }
}

/// Janela com texto selecionável e botão Copiar.
void showTextDialog(BuildContext context, String title, String text,
    {double fontSize = 12}) {
  showDialog(
    context: context,
    builder: (c) => AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: SelectableText(text,
            style: TextStyle(fontFamily: 'monospace', fontSize: fontSize)),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: text));
            Navigator.pop(c);
          },
          child: const Text('Copiar'),
        ),
        TextButton(onPressed: () => Navigator.pop(c), child: const Text('OK')),
      ],
    ),
  );
}

Future<bool> confirm(BuildContext context, String message) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      content: Text(message),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('Cancelar')),
        FilledButton(
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Continuar')),
      ],
    ),
  );
  return result == true;
}

double parseAmount(String text) =>
    double.tryParse(text.replaceAll(',', '.')) ?? 0;
