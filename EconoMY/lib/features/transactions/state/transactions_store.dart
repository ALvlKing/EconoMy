import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/transaction_item.dart';

class TransactionsStore extends ChangeNotifier {
  static const List<String> expenseCategories = [
    'Alimentação',
    'Transporte',
    'Lazer',
    'Saúde',
    'Educação',
  ];

  static const List<String> incomeCategories = [
    'Salário',
    'Bolsa',
    'Renda Extra',
    'Outros',
  ];

  final List<TransactionItem> _items = [
    TransactionItem(
      id: '1',
      title: 'Bolsa / Recebimento',
      amount: 1400.0,
      category: 'Bolsa',
      date: DateTime.now(),
      type: TransactionType.income,
    ),
    TransactionItem(
      id: '2',
      title: 'Passagem e ônibus',
      amount: 120.0,
      category: 'Transporte',
      date: DateTime.now().subtract(const Duration(days: 1)),
      type: TransactionType.expense,
    ),
    TransactionItem(
      id: '3',
      title: 'Mercado / Café',
      amount: 210.0,
      category: 'Alimentação',
      date: DateTime.now().subtract(const Duration(days: 2)),
      type: TransactionType.expense,
    ),
  ];

  List<TransactionItem> get items => List.unmodifiable(_items);

  List<TransactionItem> recent({int limit = 4}) => _items.take(limit).toList();

  double get totalIncome => _items
      .where((item) => item.type == TransactionType.income)
      .fold(0.0, (sum, item) => sum + item.amount);

  double get totalExpense => _items
      .where((item) => item.type == TransactionType.expense)
      .fold(0.0, (sum, item) => sum + item.amount);

  double get balance => totalIncome - totalExpense;

  Map<String, double> get expenseByCategory {
    final map = <String, double>{for (final cat in expenseCategories) cat: 0.0};
    for (final item in _items) {
      if (item.type == TransactionType.expense) {
        map[item.category] = (map[item.category] ?? 0.0) + item.amount;
      }
    }
    return map;
  }

  String encodeItems() =>
      jsonEncode(_items.map((item) => item.toJson()).toList());

  void loadFromEncoded(String? encoded) {
    if (encoded == null) return;
    final List<dynamic> decoded = jsonDecode(encoded) as List<dynamic>;
    _items
      ..clear()
      ..addAll(
        decoded.map(
          (raw) => TransactionItem.fromJson(raw as Map<String, dynamic>),
        ),
      );
    notifyListeners();
  }

  void save({
    String? id,
    required String title,
    required double amount,
    required String category,
    required DateTime date,
    required TransactionType type,
  }) {
    final record = TransactionItem(
      id: id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      title: title.trim(),
      amount: amount,
      category: category,
      date: date,
      type: type,
    );

    final index = _items.indexWhere((item) => item.id == record.id);
    if (index != -1) {
      _items[index] = record;
    } else {
      _items.insert(0, record);
    }
    notifyListeners();
  }

  void remove(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
