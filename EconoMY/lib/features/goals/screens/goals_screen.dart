import 'package:flutter/material.dart';
import '../../../shared/facade/economy_facade.dart';

class GoalsScreen extends StatelessWidget {
  final EconomyFacade facade;
  const GoalsScreen({super.key, required this.facade});

  @override
  Widget build(BuildContext context) {
    final goalCtrl = TextEditingController(
      text: facade.monthlySavingsGoal.toStringAsFixed(0),
    );
    final limitCtrls = {
      for (final cat in EconomyFacade.expenseCategories)
        cat: TextEditingController(
          text: (facade.categoryLimits[cat] ?? 0).toStringAsFixed(0),
        ),
    };
    final spentByCat = facade.expenseDistribution;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Meta de Economia Mensal',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                TextField(
                  controller: goalCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Meta (${facade.currency})',
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Saldo atual disponível para meta: ${facade.formatMoney(facade.currentBalance)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text('Limites por Categoria',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        ...EconomyFacade.expenseCategories.map((cat) {
          final spent = spentByCat[cat] ?? 0.0;
          final limit = facade.categoryLimits[cat] ?? 0.0;
          final ratio = facade.categoryLimitProgress(cat);

          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: limitCtrls[cat],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Limite - $cat (${facade.currency})',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: ratio.clamp(0.0, 1.0),
                    color: ratio > 1.0
                        ? Colors.redAccent
                        : const Color(0xFF22C55E),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Gasto: ${facade.formatMoney(spent)} de ${facade.formatMoney(limit)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 8),
        FilledButton(
          onPressed: () {
            final newGoal =
                double.tryParse(goalCtrl.text.replaceAll(',', '.')) ?? 0.0;
            final newLimits = <String, double>{
              for (final cat in EconomyFacade.expenseCategories)
                cat: double.tryParse(
                        limitCtrls[cat]!.text.replaceAll(',', '.')) ??
                    0.0,
            };
            facade.saveGoalsAndLimits(savingsGoal: newGoal, limits: newLimits);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Metas e limites atualizados.')),
            );
          },
          child: const Text('Salvar Metas e Limites'),
        ),
      ],
    );
  }
}
