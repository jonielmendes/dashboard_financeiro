import 'package:equatable/equatable.dart';
import '../../../dominio/entidades/transacao.dart';

/// Estados do BLoC de Transações
abstract class TransacaoState extends Equatable {
  const TransacaoState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class TransacaoInicial extends TransacaoState {}

/// Estado de carregamento
class TransacaoCarregando extends TransacaoState {}

/// Estado de sucesso ao carregar transações
class TransacaoCarregada extends TransacaoState {
  final List<Transacao> transacoes;

  const TransacaoCarregada(this.transacoes);

  @override
  List<Object?> get props => [transacoes];
}

/// Estado de sucesso em operação (criar, atualizar, deletar)
class TransacaoOperacaoSucesso extends TransacaoState {
  final String mensagem;

  const TransacaoOperacaoSucesso(this.mensagem);

  @override
  List<Object?> get props => [mensagem];
}

/// Estado de erro
class TransacaoErro extends TransacaoState {
  final String mensagem;

  const TransacaoErro(this.mensagem);

  @override
  List<Object?> get props => [mensagem];
}
