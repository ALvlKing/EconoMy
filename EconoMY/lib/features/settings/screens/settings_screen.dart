import 'package:flutter/material.dart';
import '../../../shared/facade/economy_facade.dart';

class SettingsScreen extends StatefulWidget {
  final EconomyFacade facade;
  const SettingsScreen({super.key, required this.facade});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final TextEditingController nameCtrl;
  late String selectedCurrency;
  late bool isDark;
  late bool isCompact;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.facade.userName);
    selectedCurrency = widget.facade.currency;
    isDark = widget.facade.darkMode;
    isCompact = widget.facade.compactCards;
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(
          controller: nameCtrl,
          decoration: const InputDecoration(
            labelText: 'Nome do usuário',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: selectedCurrency,
          decoration: const InputDecoration(
            labelText: 'Moeda utilizada',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'R\$', child: Text('Real (R\$)')),
            DropdownMenuItem(value: 'US\$', child: Text('Dólar (US\$)')),
            DropdownMenuItem(value: '€', child: Text('Euro (€)')),
          ],
          onChanged: (val) {
            if (val != null) setState(() => selectedCurrency = val);
          },
        ),
        const SizedBox(height: 12),
        SwitchListTile(
          title: const Text('Tema escuro'),
          value: isDark,
          onChanged: (val) => setState(() => isDark = val),
        ),
        SwitchListTile(
          title: const Text('Cartões compactos (preferência de exibição)'),
          value: isCompact,
          onChanged: (val) => setState(() => isCompact = val),
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: () {
            widget.facade.savePreferences(
              name: nameCtrl.text,
              selectedCurrency: selectedCurrency,
              isDark: isDark,
              isCompact: isCompact,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Configurações salvas.')),
            );
          },
          child: const Text('Salvar Configurações'),
        ),
        const SizedBox(height: 24),
        OutlinedButton.icon(
          onPressed: () {
            widget.facade.clearAllData();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Dados redefinidos.')),
            );
          },
          icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
          label: const Text(
            'Limpar / Redefinir Dados',
            style: TextStyle(color: Colors.redAccent),
          ),
        ),
      ],
    );
  }
}
