import 'package:equatable/equatable.dart';

/// Entidade representando uma transação financeira
/// Seguindo Clean Architecture, essa entidade é independente de frameworks
class Transaction extends Equatable {
  final String id;
  final String title;
  final double amount;
  final String categoryId;
  final DateTime date;
  final TransactionType type;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.categoryId,
    required this.date,
    required this.type,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        amount,
        categoryId,
        date,
        type,
        description,
        createdAt,
        updatedAt,
      ];

  Transaction copyWith({
    String? id,
    String? title,
    double? amount,
    String? categoryId,
    DateTime? date,
    TransactionType? type,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Transaction(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      categoryId: categoryId ?? this.categoryId,
      date: date ?? this.date,
      type: type ?? this.type,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Tipo de transação: Receita ou Despesa
enum TransactionType {
  income,
  expense;

  String get name {
    switch (this) {
      case TransactionType.income:
        return 'Receita';
      case TransactionType.expense:
        return 'Despesa';
    }
  }
}
