import '../../dominio/entidades/transacao.dart';
import '../../dominio/repositorios/repositorio_transacao.dart';
import '../fontes_dados/transacao_data_source_local.dart';
import '../modelos/transacao_model.dart';

/// Implementação do Repository de Transações
/// Usa apenas armazenamento local com SQLite
class RepositorioTransacaoImpl implements RepositorioTransacao {
  final TransacaoDataSourceLocal _dataSourceLocal;

  RepositorioTransacaoImpl(this._dataSourceLocal);

  @override
  Future<List<Transacao>> buscarTodas() async {
    return await _dataSourceLocal.buscarTodas();
  }

  @override
  Future<List<Transacao>> buscarPorPeriodo({
    required DateTime dataInicio,
    required DateTime dataFim,
  }) async {
    return await _dataSourceLocal.buscarPorPeriodo(
      dataInicio: dataInicio,
      dataFim: dataFim,
    );
  }

  @override
  Future<List<Transacao>> buscarPorCategoria(String categoriaId) async {
    return await _dataSourceLocal.buscarPorCategoria(categoriaId);
  }

  @override
  Future<Transacao?> buscarPorId(String id) async {
    return await _dataSourceLocal.buscarPorId(id);
  }

  @override
  Future<void> criar(Transacao transacao) async {
    final model = TransacaoModel.deEntidade(transacao);
    await _dataSourceLocal.inserir(model);
  }

  @override
  Future<void> atualizar(Transacao transacao) async {
    final model = TransacaoModel.deEntidade(transacao);
    await _dataSourceLocal.atualizar(model);
  }

  @override
  Future<void> deletar(String id) async {
    await _dataSourceLocal.deletar(id);
  }

  @override
  Future<void> sincronizar() async {
    // Sincronização removida - apenas SQLite local
  }
}
