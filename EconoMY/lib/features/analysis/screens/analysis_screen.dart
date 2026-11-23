import 'package:flutter/material.dart';
import '../../../shared/facade/economy_facade.dart';

class AnalysisScreen extends StatelessWidget {
  final EconomyFacade facade;
  const AnalysisScreen({super.key, required this.facade});

  @override
  Widget build(BuildContext context) {
    final dist = facade.expenseDistribution;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Distribuição Percentual por Categoria',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        ...dist.entries.map((entry) {
          final pct = facade.categoryPercentage(entry.key);
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(entry.key,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        '${(pct * 100).toStringAsFixed(1)}% (${facade.formatMoney(entry.value)})',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: pct,
                    color: const Color(0xFFEAB308),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
