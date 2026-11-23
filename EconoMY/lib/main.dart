import 'package:flutter/material.dart';
import 'features/analysis/screens/analysis_screen.dart';
import 'features/goals/screens/goals_screen.dart';
import 'features/overview/screens/home_screen.dart';
import 'features/settings/screens/settings_screen.dart';
import 'features/transactions/screens/history_screen.dart';
import 'features/transactions/widgets/transaction_form_sheet.dart';
import 'shared/facade/economy_facade.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const EconomyApp());
}

class EconomyApp extends StatefulWidget {
  const EconomyApp({super.key});

  @override
  State<EconomyApp> createState() => _EconomyAppState();
}

class _EconomyAppState extends State<EconomyApp> {
  final EconomyFacade facade = EconomyFacade();
  int _currentIndex = 0;

  static const Color primaryGreen = Color(0xFF1B8A5A);
  static const Color accentYellow = Color(0xFFEAB308);

  @override
  void initState() {
    super.initState();
    facade.loadLocalData();
  }

  @override
  void dispose() {
    facade.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: facade,
      builder: (context, _) {
        return MaterialApp(
          title: 'EconoMY',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: primaryGreen,
              primary: primaryGreen,
              secondary: accentYellow,
              surface: const Color(0xFFF3F4F6),
              brightness: Brightness.light,
            ),
            scaffoldBackgroundColor: const Color(0xFFF3F4F6),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: primaryGreen,
              primary: const Color(0xFF22C55E),
              secondary: accentYellow,
              surface: const Color(0xFF18181B),
              brightness: Brightness.dark,
            ),
            scaffoldBackgroundColor: const Color(0xFF111113),
          ),
          themeMode: facade.darkMode ? ThemeMode.dark : ThemeMode.light,
          home: _EconomyHome(
            facade: facade,
            currentIndex: _currentIndex,
            onSelectTab: (idx) => setState(() => _currentIndex = idx),
          ),
        );
      },
    );
  }
}

class _EconomyHome extends StatelessWidget {
  final EconomyFacade facade;
  final int currentIndex;
  final ValueChanged<int> onSelectTab;

  const _EconomyHome({
    required this.facade,
    required this.currentIndex,
    required this.onSelectTab,
  });

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(
        facade: facade,
        onGoToHistory: () => onSelectTab(1),
      ),
      HistoryScreen(facade: facade),
      AnalysisScreen(facade: facade),
      GoalsScreen(facade: facade),
      SettingsScreen(facade: facade),
    ];

    const titles = [
      'EconoMY',
      'Histórico',
      'Análise de Gastos',
      'Metas e Orçamentos',
      'Configurações',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[currentIndex]),
        actions: [
          if (currentIndex == 0)
            Padding(
              padding: const EdgeInsets.only(right: 14),
              child: Center(child: Text('Olá, ${facade.userName}')),
            ),
        ],
      ),
      body: pages[currentIndex],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showTransactionFormSheet(context, facade),
        icon: const Icon(Icons.add),
        label: const Text('Lançar'),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onSelectTab,
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_outlined), label: 'Início'),
          NavigationDestination(icon: Icon(Icons.list_alt), label: 'Histórico'),
          NavigationDestination(
              icon: Icon(Icons.pie_chart_outline), label: 'Análise'),
          NavigationDestination(
              icon: Icon(Icons.savings_outlined), label: 'Metas'),
          NavigationDestination(
              icon: Icon(Icons.settings_outlined), label: 'Ajustes'),
        ],
      ),
    );
  }
}
