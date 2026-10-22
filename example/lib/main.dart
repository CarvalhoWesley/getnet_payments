import 'package:flutter/material.dart';

import 'core/app_log.dart';
import 'deeplink/deeplink_page.dart';
import 'logs/logs_page.dart';
import 'nfc/nfc_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Getnet Payments',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFFE30613),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  static const _titles = [
    'Deeplink',
    'NFC',
    'Logs',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_index])),
      body: IndexedStack(
        index: _index,
        children: const [
          DeeplinkPage(),
          NfcPage(),
          LogsPage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          const NavigationDestination(
              icon: Icon(Icons.open_in_new), label: 'Deeplink'),
          const NavigationDestination(
              icon: Icon(Icons.contactless), label: 'NFC'),
          NavigationDestination(
            icon: ValueListenableBuilder(
              valueListenable: AppLog.entries,
              builder: (context, entries, _) => Badge(
                isLabelVisible: entries.any((e) => e.isError),
                child: const Icon(Icons.terminal),
              ),
            ),
            label: 'Logs',
          ),
        ],
      ),
    );
  }
}
