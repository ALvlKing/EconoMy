import 'package:flutter/material.dart';
import '../../../shared/facade/economy_facade.dart';
import '../../../shared/widgets/transaction_tile.dart';
import '../../transactions/widgets/transaction_form_sheet.dart';

class HomeScreen extends StatelessWidget {
  final EconomyFacade facade;
  final VoidCallback onGoToHistory;

  const HomeScreen({
    super.key,
    required this.facade,
    required this.onGoToHistory,
  });

  @override
  Widget build(BuildContext context) {
    final pad = facade.compactCards ? 12.0 : 18.0;
    final balance = facade.currentBalance;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: EdgeInsets.all(pad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Saldo Atual'),
                const SizedBox(height: 6),
                Text(
                  facade.formatMoney(balance),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: balance >= 0
                            ? const Color(0xFF22C55E)
                            : Colors.redAccent,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Resumo do mês: Receitas ${facade.formatMoney(facade.totalIncome)} · '
                  'Despesas ${facade.formatMoney(facade.totalExpense)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(pad),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Receitas'),
                      const SizedBox(height: 4),
                      Text(
                        facade.formatMoney(facade.totalIncome),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF22C55E),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(pad),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Despesas'),
                      const SizedBox(height: 4),
                      Text(
                        facade.formatMoney(facade.totalExpense),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFEAB308),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Movimentações Recentes',
                style: Theme.of(context).textTheme.titleMedium),
            TextButton(onPressed: onGoToHistory, child: const Text('Ver tudo')),
          ],
        ),
        if (facade.recentTransactions.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child:
                Center(child: Text('Nenhuma movimentação registrada ainda.')),
          )
        else
          ...facade.recentTransactions.map(
            (item) => TransactionTile(
              item: item,
              facade: facade,
              onEdit: () =>
                  showTransactionFormSheet(context, facade, existing: item),
            ),
          ),
      ],
    );
  }
}
