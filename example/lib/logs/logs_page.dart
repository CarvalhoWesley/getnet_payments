import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/app_log.dart';

/// Log central de todas as áreas, com filtro por origem.
class LogsPage extends StatefulWidget {
  const LogsPage({super.key});

  @override
  State<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  LogSource? _filter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ValueListenableBuilder(
      valueListenable: AppLog.entries,
      builder: (context, entries, _) {
        final visible = _filter == null
            ? entries
            : entries.where((e) => e.source == _filter).toList();
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
              child: Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _chip('Todos', null),
                          for (final s in LogSource.values) _chip(s.label, s),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Copiar',
                    icon: const Icon(Icons.copy),
                    onPressed: visible.isEmpty
                        ? null
                        : () {
                            Clipboard.setData(ClipboardData(
                                text: visible.reversed.join('\n')));
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Log copiado'),
                                    behavior: SnackBarBehavior.floating));
                          },
                  ),
                  IconButton(
                    tooltip: 'Limpar',
                    icon: const Icon(Icons.delete_sweep),
                    onPressed: entries.isEmpty ? null : AppLog.clear,
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: visible.isEmpty
                  ? Center(
                      child: Text('Nenhuma mensagem',
                          style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant)),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: visible.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, i) => _LogTile(entry: visible[i]),
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _chip(String label, LogSource? source) => Padding(
        padding: const EdgeInsets.only(right: 8),
        child: FilterChip(
          label: Text(label),
          selected: _filter == source,
          onSelected: (_) => setState(() => _filter = source),
        ),
      );
}

class _LogTile extends StatelessWidget {
  final LogEntry entry;

  const _LogTile({required this.entry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(entry.timeLabel,
              style:
                  theme.textTheme.bodySmall?.copyWith(fontFamily: 'monospace')),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: entry.source.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(entry.source.label,
                style: theme.textTheme.labelSmall
                    ?.copyWith(color: entry.source.color)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SelectableText(
              entry.message,
              style: theme.textTheme.bodySmall?.copyWith(
                fontFamily: 'monospace',
                color: entry.isError ? theme.colorScheme.error : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
