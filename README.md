<img width="2816" height="1536" alt="Image" src="https://github.com/user-attachments/assets/14bb1f06-f700-43ba-844e-5f1c7872fec0" />
A new Flutter project.

# 📊 Dashboard Financeiro

Aplicativo Flutter para gerenciamento financeiro pessoal com gráficos interativos e relatórios.

## 🎯 Sobre

Projeto desenvolvido para a **Atividade 6 - PRODM**, focado em visualização de dados financeiros, gráficos e exportação de relatórios.

## ✨ Funcionalidades

- Dashboard com resumo de receitas, despesas e saldo
- Gráficos interativos (linha, barras e pizza) usando **fl_chart**
- Adicionar/editar/excluir transações
- Gerenciar categorias personalizadas
- Filtros por período (7 dias, 30 dias, mês, ano)
- Exportação de relatórios em **CSV** e **PDF**
- Tema claro/escuro

## 🛠️ Tecnologias

- **Flutter** 3.x / **Dart** 3.x
- **BLoC** (flutter_bloc) - Gerenciamento de estado
- **SQLite** (sqflite) - Armazenamento local
- **fl_chart** - Gráficos interativos
- **pdf** + **csv** - Exportação de relatórios
- **share_plus** - Compartilhamento

## 🏗️ Arquitetura

**Clean Architecture** com separação em camadas:

- **Apresentação**: UI + BLoCs (Transação, Categoria, Relatório, Filtro, Tema)
- **Domínio**: Entidades e interfaces
- **Dados**: Repositórios + SQLite

## 💾 Armazenamento

- **Local**: SQLite com tabelas de categorias e transações
- **Preparado para**: Hasura GraphQL (integração futura)

## 🚀 Como Executar

```bash
flutter pub get
flutter run
