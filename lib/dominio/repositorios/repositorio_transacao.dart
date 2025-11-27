import '../entidades/transacao.dart';

/// Interface do Repository de Transações
/// Define o contrato para acesso aos dados de transações
abstract class RepositorioTransacao {
  /// Busca todas as transações
  Future<List<Transacao>> buscarTodas();

  /// Busca transações por período
  Future<List<Transacao>> buscarPorPeriodo({
    required DateTime dataInicio,
    required DateTime dataFim,
  });

  /// Busca transações por categoria
  Future<List<Transacao>> buscarPorCategoria(String categoriaId);

  /// Busca uma transação pelo ID
  Future<Transacao?> buscarPorId(String id);

  /// Cria uma nova transação
  Future<void> criar(Transacao transacao);

  /// Atualiza uma transação existente
  Future<void> atualizar(Transacao transacao);

  /// Deleta uma transação
  Future<void> deletar(String id);

  /// Sincroniza dados locais com o servidor
  Future<void> sincronizar();
}
