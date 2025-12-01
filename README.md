<img width="200" src="https://github.com/user-attachments/assets/14bb1f06-f700-43ba-844e-5f1c7872fec0" />

# Dashboard Financeiro

Aplicativo Flutter para gerenciamento financeiro pessoal com gráficos interativos e relatórios. 

## Sobre

Projeto desenvolvido para a **Atividade 6 - PRODM**, focado em visualização de dados financeiros, gráficos e exportação de relatórios.

## Funcionalidades

- Dashboard com resumo de receitas, despesas e saldo
- Gráficos interativos (linha, barras e pizza) usando **fl_chart**
- Adicionar/editar/excluir transações
- Gerenciar categorias personalizadas
- Filtros por período (7 dias, 30 dias, mês, ano)
- Tema claro/escuro

## Tecnologias

- **Flutter** 3.x / **Dart** 3.x
- **BLoC** (flutter_bloc) - Gerenciamento de estado
- **SQLite** (sqflite) - Armazenamento local
- **fl_chart** - Gráficos interativos

## Arquitetura

**Clean Architecture** com separação em camadas:

- **Apresentação**: UI + BLoCs (Transação, Categoria, Relatório, Filtro, Tema)
- **Domínio**: Entidades e interfaces
- **Dados**: Repositórios + SQLite

## Estrutura do Projeto

```plaintext
dashboard_financeiro/
├── lib/
│   ├── apresentacao/
│   │   ├── bloc/
│   │   │   ├── categoria/
│   │   │   ├── filtro/
│   │   │   ├── relatorio/
│   │   │   ├── tema/
│   │   │   └── transacao/
│   │   ├── telas/
│   │   │   ├── tela_adicionar_transacao. dart
│   │   │   ├── tela_dashboard. dart
│   │   │   ├── tela_gerenciar_categorias.dart
│   │   │   ├── tela_graficos.dart
│   │   │   ├── tela_navegacao_principal.dart
│   │   │   ├── tela_perfil.dart
│   │   │   └── tela_relatorios.dart
│   │   └── widgets/
│   │       ├── cartao_resumo.dart
│   │       ├── grafico_barras_despesas.dart
│   │       ├── grafico_linha_evolucao.dart
│   │       └── grafico_pizza_categorias.dart
│   ├── dados/
│   │   ├── fontes_dados/
│   │   │   ├── banco_dados_local.dart
│   │   │   ├── categoria_data_source_local. dart
│   │   │   └── transacao_data_source_local.dart
│   │   ├── modelos/
│   │   │   ├── categoria_model.dart
│   │   │   └── transacao_model.dart
│   │   ├── repositorios/
│   │   │   ├── repositorio_categoria_impl.dart
│   │   │   ├── repositorio_relatorio_impl.dart
│   │   │   └── repositorio_transacao_impl.dart
│   │   └── utils/
│   │       └── dados_teste.dart
│   ├── dominio/
│   │   ├── entidades/
│   │   │   ├── categoria.dart
│   │   │   ├── relatorio_financeiro.dart
│   │   │   └── transacao.dart
│   │   └── repositorios/
│   │       ├── repositorio_categoria.dart
│   │       ├── repositorio_relatorio.dart
│   │       └── repositorio_transacao.dart
│   └── main.dart
├── assets/
│   └── images/
│       └── logo.png
├── pubspec.yaml
└── README.md
```

## Armazenamento

- **Local**: SQLite com tabelas de categorias e transações
- **Preparado para**: Hasura GraphQL (integração futura)

## Como Executar

```bash
flutter pub get
flutter run
```
