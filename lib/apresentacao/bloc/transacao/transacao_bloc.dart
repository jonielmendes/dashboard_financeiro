import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../dominio/repositorios/repositorio_transacao.dart';
import 'transacao_event.dart';
import 'transacao_state.dart';

/// BLoC para gerenciar o estado das Transações
class TransacaoBloc extends Bloc<TransacaoEvent, TransacaoState> {
  final RepositorioTransacao repositorio;

  TransacaoBloc(this.repositorio) : super(TransacaoInicial()) {
    on<CarregarTransacoes>(_onCarregarTransacoes);
    on<CarregarTransacoesPorPeriodo>(_onCarregarTransacoesPorPeriodo);
    on<CriarTransacao>(_onCriarTransacao);
    on<AtualizarTransacao>(_onAtualizarTransacao);
    on<DeletarTransacao>(_onDeletarTransacao);
    on<SincronizarTransacoes>(_onSincronizarTransacoes);
  }

  Future<void> _onCarregarTransacoes(
    CarregarTransacoes event,
    Emitter<TransacaoState> emit,
  ) async {
    emit(TransacaoCarregando());
    try {
      final transacoes = await repositorio.buscarTodas();
      emit(TransacaoCarregada(transacoes));
    } catch (e) {
      emit(TransacaoErro('Erro ao carregar transações: $e'));
    }
  }

  Future<void> _onCarregarTransacoesPorPeriodo(
    CarregarTransacoesPorPeriodo event,
    Emitter<TransacaoState> emit,
  ) async {
    emit(TransacaoCarregando());
    try {
      final transacoes = await repositorio.buscarPorPeriodo(
        dataInicio: event.dataInicio,
        dataFim: event.dataFim,
      );
      emit(TransacaoCarregada(transacoes));
    } catch (e) {
      emit(TransacaoErro('Erro ao carregar transações por período: $e'));
    }
  }

  Future<void> _onCriarTransacao(
    CriarTransacao event,
    Emitter<TransacaoState> emit,
  ) async {
    try {
      await repositorio.criar(event.transacao);
      emit(const TransacaoOperacaoSucesso('Transação criada com sucesso!'));
      // Recarrega as transações
      add(CarregarTransacoes());
    } catch (e) {
      emit(TransacaoErro('Erro ao criar transação: $e'));
    }
  }

  Future<void> _onAtualizarTransacao(
    AtualizarTransacao event,
    Emitter<TransacaoState> emit,
  ) async {
    try {
      await repositorio.atualizar(event.transacao);
      emit(const TransacaoOperacaoSucesso('Transação atualizada com sucesso!'));
      // Recarrega as transações
      add(CarregarTransacoes());
    } catch (e) {
      emit(TransacaoErro('Erro ao atualizar transação: $e'));
    }
  }

  Future<void> _onDeletarTransacao(
    DeletarTransacao event,
    Emitter<TransacaoState> emit,
  ) async {
    try {
      await repositorio.deletar(event.id);
      emit(const TransacaoOperacaoSucesso('Transação deletada com sucesso!'));
      // Recarrega as transações
      add(CarregarTransacoes());
    } catch (e) {
      emit(TransacaoErro('Erro ao deletar transação: $e'));
    }
  }

  Future<void> _onSincronizarTransacoes(
    SincronizarTransacoes event,
    Emitter<TransacaoState> emit,
  ) async {
    try {
      await repositorio.sincronizar();
      emit(const TransacaoOperacaoSucesso('Sincronização concluída!'));
      // Recarrega as transações
      add(CarregarTransacoes());
    } catch (e) {
      emit(TransacaoErro('Erro ao sincronizar: $e'));
    }
  }
}
