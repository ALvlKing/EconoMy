# EconoMY

Aplicativo de controle financeiro pessoal desenvolvido em **Flutter** com foco em organização visual, acompanhamento de metas e persistência local de dados.

---

## Funcionalidades

- **Visão Geral (Início):** resumo de saldo atual, total de receitas, total de despesas e listagem rápida das movimentações recentes.
- **Lançamentos e Histórico:** cadastro, edição e remoção de receitas e despesas com título, valor, categoria e data.
- **Análise de Gastos:** distribuição percentual das despesas por categoria e acompanhamento visual do progresso em relação aos limites definidos.
- **Metas e Orçamentos:** definição de meta mensal de economia e limites individuais por categoria (`Alimentação`, `Transporte`, `Lazer`, `Saúde` e `Educação`).
- **Configurações e Personalização:** edição do nome de exibição, moeda, alternância entre tema claro e escuro, modo de cartões compactos e opção para redefinir os dados locais.
- **Persistência Local:** armazenamento automático em arquivo JSON (`economy_data.json`) no diretório de suporte da aplicação, preservando lançamentos, metas e preferências entre sessões.

---

## Tecnologias e Arquitetura

- **Framework:** Flutter (Dart, Material 3)
- **Gerenciamento de Estado:** `ChangeNotifier` + `AnimatedBuilder`
- **Arquitetura:** Feature-first simples com padrão **Facade** (`EconomyFacade`) centralizando o acesso das telas ao estado e à persistência
- **Persistência:** `path_provider` + `dart:io` (serialização JSON)
- **Ícone do Aplicativo:** `flutter_launcher_icons`

### Estrutura de Diretórios

```text
lib/
├── features/
│   ├── analysis/
│   │   └── screens/          # Tela de análise e distribuição de gastos
│   ├── goals/
│   │   └── screens/          # Tela de metas mensais e limites por categoria
│   ├── overview/
│   │   └── screens/          # Tela inicial com resumo financeiro
│   ├── settings/
│   │   └── screens/          # Tela de preferências e redefinição de dados
│   └── transactions/
│       ├── models/           # Modelo TransactionItem e serialização JSON
│       ├── screens/          # Tela de histórico completo de movimentações
│       ├── state/            # TransactionsStore (regras e cálculos de lançamentos)
│       └── widgets/          # Formulário modal de criação/edição de lançamentos
├── shared/
│   └── facade/               # EconomyFacade (ponto único de integração e persistência)
└── main.dart                 # Inicialização do app, temas e navegação principal

## Como Executar Localmente

### Pré-requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado e configurado
- Android SDK / JDK (para compilação Android)

### Passos

1. Clone o repositório:
   ```bash
   git clone [https://github.com/ALvlKing/economy.git](https://github.com/ALvlKing/economy.git)
   cd economy

2. Instale as dependências:
   ```bash
   flutter pub get

3. Execute o aplicativo em modo de desenvolvimento:
   ```bash
   flutter run

4. (Opcional) Gere o APK de release para Android:
   ```bash
   flutter build apk --release
