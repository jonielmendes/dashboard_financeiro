import 'package:equatable/equatable.dart';

/// Entidade que representa um relatório financeiro
/// Agrega dados de transações para visualização no Dashboard
class FinancialReport extends Equatable {
  final double totalIncome;
  final double totalExpense;
  final double balance;
  final Map<String, double> expensesByCategory;
  final Map<String, double> incomesByCategory;
  final List<DailyTransaction> dailyTransactions;
  final DateTime startDate;
  final DateTime endDate;

  const FinancialReport({
    required this.totalIncome,
    required this.totalExpense,
    required this.balance,
    required this.expensesByCategory,
    required this.incomesByCategory,
    required this.dailyTransactions,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [
        totalIncome,
        totalExpense,
        balance,
        expensesByCategory,
        incomesByCategory,
        dailyTransactions,
        startDate,
        endDate,
      ];
}

/// Representa transações agregadas por dia
class DailyTransaction extends Equatable {
  final DateTime date;
  final double income;
  final double expense;

  const DailyTransaction({
    required this.date,
    required this.income,
    required this.expense,
  });

  double get balance => income - expense;

  @override
  List<Object?> get props => [date, income, expense];
}
