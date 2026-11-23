import 'package:flutter/material.dart';
import '../../../shared/facade/economy_facade.dart';
import '../../../shared/widgets/transaction_tile.dart';
import '../widgets/transaction_form_sheet.dart';

class HistoryScreen extends StatelessWidget {
  final EconomyFacade facade;
  const HistoryScreen({super.key, required this.facade});

  @override
  Widget build(BuildContext context) {
    if (facade.transactions.isEmpty) {
      return const Center(
        child: Text('Histórico vazio. Toque em "Lançar" para adicionar.'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: facade.transactions.length,
      itemBuilder: (_, i) {
        final item = facade.transactions[i];
        return TransactionTile(
          item: item,
          facade: facade,
          onEdit: () =>
              showTransactionFormSheet(context, facade, existing: item),
        );
      },
    );
  }
}
