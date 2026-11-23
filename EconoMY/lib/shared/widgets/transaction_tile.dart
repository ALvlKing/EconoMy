import 'package:flutter/material.dart';
import '../../features/transactions/models/transaction_item.dart';
import '../facade/economy_facade.dart';

class TransactionTile extends StatelessWidget {
  final TransactionItem item;
  final EconomyFacade facade;
  final VoidCallback onEdit;

  const TransactionTile({
    super.key,
    required this.item,
    required this.facade,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = item.type == TransactionType.income;
    final color = isIncome ? const Color(0xFF22C55E) : const Color(0xFFEAB308);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          isIncome ? Icons.arrow_downward : Icons.arrow_upward,
          color: color,
        ),
        title: Text(item.title),
        subtitle: Text('${item.category} · ${facade.formatDate(item.date)}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${isIncome ? '+' : '-'} ${facade.formatMoney(item.amount)}',
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20),
              onPressed: () => facade.removeTransaction(item.id),
            ),
          ],
        ),
      ),
    );
  }
}
