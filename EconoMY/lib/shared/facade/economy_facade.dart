import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../features/transactions/models/transaction_item.dart';
import '../../features/transactions/state/transactions_store.dart';

class EconomyFacade extends ChangeNotifier {
  final TransactionsStore _transactionsStore;

  EconomyFacade({TransactionsStore? transactionsStore})
      : _transactionsStore = transactionsStore ?? TransactionsStore() {
    _transactionsStore.addListener(_onStoreChanged);
  }

  String userName = 'José Ricardo';
  String currency = 'R\$';
  bool darkMode = true;
  bool compactCards = true;
  double monthlySavingsGoal = 500.0;
  bool _hasLoaded = false;

  static const List<String> expenseCategories =
      TransactionsStore.expenseCategories;

  static const List<String> incomeCategories =
      TransactionsStore.incomeCategories;

  final Map<String, double> _categoryLimits = {
    'Alimentação': 600.0,
    'Transporte': 250.0,
    'Lazer': 200.0,
    'Saúde': 200.0,
    'Educação': 300.0,
  };

  List<TransactionItem> get transactions => _transactionsStore.items;
  List<TransactionItem> get recentTransactions => _transactionsStore.recent();
  Map<String, double> get categoryLimits => Map.unmodifiable(_categoryLimits);

  double get totalIncome => _transactionsStore.totalIncome;
  double get totalExpense => _transactionsStore.totalExpense;
  double get currentBalance => _transactionsStore.balance;
  Map<String, double> get expenseDistribution =>
      _transactionsStore.expenseByCategory;

  double categoryPercentage(String category) {
    final total = totalExpense;
    if (total <= 0) return 0.0;
    return ((expenseDistribution[category] ?? 0.0) / total).clamp(0.0, 1.0);
  }

  double categoryLimitProgress(String category) {
    final limit = _categoryLimits[category] ?? 0.0;
    if (limit <= 0) return 0.0;
    return (expenseDistribution[category] ?? 0.0) / limit;
  }

  String formatMoney(double value) => '$currency ${value.toStringAsFixed(2)}';

  String formatDate(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    return '$d/$m/${date.year}';
  }

  Future<File> _dataFile() async {
    final dir = await getApplicationSupportDirectory();
    return File('${dir.path}/economy_data.json');
  }

  Future<void> loadLocalData() async {
    try {
      final file = await _dataFile();
      if (!await file.exists()) {
        _hasLoaded = true;
        await _saveToDisk();
        notifyListeners();
        return;
      }

      final content = await file.readAsString();
      if (content.trim().isEmpty) {
        _hasLoaded = true;
        notifyListeners();
        return;
      }

      final map = jsonDecode(content) as Map<String, dynamic>;
      userName = (map['userName'] as String?) ?? userName;
      currency = (map['currency'] as String?) ?? currency;
      darkMode = (map['darkMode'] as bool?) ?? darkMode;
      compactCards = (map['compactCards'] as bool?) ?? compactCards;
      monthlySavingsGoal =
          (map['monthlySavingsGoal'] as num?)?.toDouble() ?? monthlySavingsGoal;

      final limitsMap = map['categoryLimits'] as Map<String, dynamic>?;
      if (limitsMap != null) {
        for (final cat in expenseCategories) {
          _categoryLimits[cat] = (limitsMap[cat] as num?)?.toDouble() ?? 0.0;
        }
      }

      final encodedTx = map['transactions'] as String?;
      if (encodedTx != null) {
        _transactionsStore.removeListener(_onStoreChanged);
        _transactionsStore.loadFromEncoded(encodedTx);
        _transactionsStore.addListener(_onStoreChanged);
      }

      _hasLoaded = true;
      notifyListeners();
    } catch (_) {
      _hasLoaded = true;
      notifyListeners();
    }
  }

  void _onStoreChanged() {
    if (_hasLoaded) {
      _saveToDisk();
    }
    notifyListeners();
  }

  Future<void> _saveToDisk() async {
    try {
      final file = await _dataFile();
      final payload = {
        'userName': userName,
        'currency': currency,
        'darkMode': darkMode,
        'compactCards': compactCards,
        'monthlySavingsGoal': monthlySavingsGoal,
        'categoryLimits': _categoryLimits,
        'transactions': _transactionsStore.encodeItems(),
      };
      await file.writeAsString(jsonEncode(payload));
    } catch (_) {}
  }

  void saveTransaction({
    String? id,
    required String title,
    required double amount,
    required String category,
    required DateTime date,
    required TransactionType type,
  }) {
    _transactionsStore.save(
      id: id,
      title: title,
      amount: amount,
      category: category,
      date: date,
      type: type,
    );
  }

  void removeTransaction(String id) {
    _transactionsStore.remove(id);
  }

  void saveGoalsAndLimits({
    required double savingsGoal,
    required Map<String, double> limits,
  }) {
    monthlySavingsGoal = savingsGoal;
    _categoryLimits
      ..clear()
      ..addAll(limits);
    _saveToDisk();
    notifyListeners();
  }

  void savePreferences({
    required String name,
    required String selectedCurrency,
    required bool isDark,
    required bool isCompact,
  }) {
    userName = name.trim().isEmpty ? 'Usuário' : name.trim();
    currency = selectedCurrency;
    darkMode = isDark;
    compactCards = isCompact;
    _saveToDisk();
    notifyListeners();
  }

  void clearAllData() {
    _transactionsStore.clear();
    monthlySavingsGoal = 0.0;
    for (final key in _categoryLimits.keys) {
      _categoryLimits[key] = 0.0;
    }
    _saveToDisk();
    notifyListeners();
  }

  @override
  void dispose() {
    _transactionsStore.removeListener(_onStoreChanged);
    _transactionsStore.dispose();
    super.dispose();
  }
}
