import 'package:flutter/material.dart';
import '../../../shared/facade/economy_facade.dart';
import '../models/transaction_item.dart';

Future<void> showTransactionFormSheet(
  BuildContext context,
  EconomyFacade facade, {
  TransactionItem? existing,
}) {
  final isEditing = existing != null;
  TransactionType selectedType = existing?.type ?? TransactionType.expense;
  final titleCtrl = TextEditingController(text: existing?.title ?? '');
  final amountCtrl = TextEditingController(
    text: existing != null ? existing.amount.toStringAsFixed(2) : '',
  );
  DateTime selectedDate = existing?.date ?? DateTime.now();

  List<String> categoriesFor(TransactionType type) =>
      type == TransactionType.expense
          ? EconomyFacade.expenseCategories
          : EconomyFacade.incomeCategories;

  String selectedCategory =
      existing?.category ?? categoriesFor(selectedType).first;

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setModalState) {
        final cats = categoriesFor(selectedType);
        if (!cats.contains(selectedCategory)) {
          selectedCategory = cats.first;
        }

        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                isEditing ? 'Editar Movimentação' : 'Nova Movimentação',
                style: Theme.of(ctx).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              SegmentedButton<TransactionType>(
                segments: const [
                  ButtonSegment(
                    value: TransactionType.expense,
                    label: Text('Despesa'),
                    icon: Icon(Icons.remove_circle_outline),
                  ),
                  ButtonSegment(
                    value: TransactionType.income,
                    label: Text('Receita'),
                    icon: Icon(Icons.add_circle_outline),
                  ),
                ],
                selected: {selectedType},
                onSelectionChanged: (val) => setModalState(() {
                  selectedType = val.first;
                  selectedCategory = categoriesFor(selectedType).first;
                }),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amountCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Valor (${facade.currency})',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Categoria',
                  border: OutlineInputBorder(),
                ),
                items: cats
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setModalState(() => selectedCategory = val);
                },
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Data: ${facade.formatDate(selectedDate)}'),
                  TextButton.icon(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: ctx,
                        initialDate: selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setModalState(() => selectedDate = picked);
                      }
                    },
                    icon: const Icon(Icons.calendar_today, size: 18),
                    label: const Text('Alterar data'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  final parsed =
                      double.tryParse(amountCtrl.text.replaceAll(',', '.'));
                  if (titleCtrl.text.trim().isEmpty ||
                      parsed == null ||
                      parsed <= 0) {
                    return;
                  }
                  facade.saveTransaction(
                    id: existing?.id,
                    title: titleCtrl.text,
                    amount: parsed,
                    category: selectedCategory,
                    date: selectedDate,
                    type: selectedType,
                  );
                  Navigator.pop(ctx);
                },
                child: Text(isEditing ? 'Salvar Alterações' : 'Cadastrar'),
              ),
            ],
          ),
        );
      },
    ),
  );
}
