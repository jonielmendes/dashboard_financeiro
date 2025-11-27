import 'package:equatable/equatable.dart';

/// Entidade que representa um relatório financeiro
/// Agrega dados de transações para visualização no Dashboard
class RelatorioFinanceiro extends Equatable {
  final double totalReceitas;
  final double totalDespesas;
  final double saldo;
  final Map<String, double> despesasPorCategoria;
  final Map<String, double> receitasPorCategoria;
  final List<TransacaoDiaria> transacoesDiarias;
  final DateTime dataInicio;
  final DateTime dataFim;

  const RelatorioFinanceiro({
    required this.totalReceitas,
    required this.totalDespesas,
    required this.saldo,
    required this.despesasPorCategoria,
    required this.receitasPorCategoria,
    required this.transacoesDiarias,
    required this.dataInicio,
    required this.dataFim,
  });

  @override
  List<Object?> get props => [
        totalReceitas,
        totalDespesas,
        saldo,
        despesasPorCategoria,
        receitasPorCategoria,
        transacoesDiarias,
        dataInicio,
        dataFim,
      ];
}

/// Representa transações agregadas por dia
class TransacaoDiaria extends Equatable {
  final DateTime data;
  final double receita;
  final double despesa;

  const TransacaoDiaria({
    required this.data,
    required this.receita,
    required this.despesa,
  });

  double get saldo => receita - despesa;

  @override
  List<Object?> get props => [data, receita, despesa];
}
