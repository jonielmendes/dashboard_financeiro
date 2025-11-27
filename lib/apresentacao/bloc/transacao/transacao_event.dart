import 'package:equatable/equatable.dart';
import '../../../dominio/entidades/transacao.dart';

/// Eventos do BLoC de Transações
abstract class TransacaoEvent extends Equatable {
  const TransacaoEvent();

  @override
  List<Object?> get props => [];
}

/// Evento para carregar todas as transações
class CarregarTransacoes extends TransacaoEvent {}

/// Evento para carregar transações por período
class CarregarTransacoesPorPeriodo extends TransacaoEvent {
  final DateTime dataInicio;
  final DateTime dataFim;

  const CarregarTransacoesPorPeriodo({
    required this.dataInicio,
    required this.dataFim,
  });

  @override
  List<Object?> get props => [dataInicio, dataFim];
}

/// Evento para criar uma nova transação
class CriarTransacao extends TransacaoEvent {
  final Transacao transacao;

  const CriarTransacao(this.transacao);

  @override
  List<Object?> get props => [transacao];
}

/// Evento para atualizar uma transação
class AtualizarTransacao extends TransacaoEvent {
  final Transacao transacao;

  const AtualizarTransacao(this.transacao);

  @override
  List<Object?> get props => [transacao];
}

/// Evento para deletar uma transação
class DeletarTransacao extends TransacaoEvent {
  final String id;

  const DeletarTransacao(this.id);

  @override
  List<Object?> get props => [id];
}

/// Evento para sincronizar com o servidor
class SincronizarTransacoes extends TransacaoEvent {}
