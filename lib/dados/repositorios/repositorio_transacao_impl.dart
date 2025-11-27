import '../../dominio/entidades/transacao.dart';
import '../../dominio/repositorios/repositorio_transacao.dart';
import '../fontes_dados/transacao_data_source_local.dart';
import '../fontes_dados/transacao_data_source_remoto.dart';
import '../modelos/transacao_model.dart';

/// Implementação do Repository de Transações
/// Segue o padrão Repository com estratégia Local First
/// Tenta buscar dados localmente primeiro, depois sincroniza com o servidor
class RepositorioTransacaoImpl implements RepositorioTransacao {
  final TransacaoDataSourceLocal _dataSourceLocal;
  final TransacaoDataSourceRemoto _dataSourceRemoto;

  RepositorioTransacaoImpl(this._dataSourceLocal, this._dataSourceRemoto);

  @override
  Future<List<Transacao>> buscarTodas() async {
    try {
      // Busca local primeiro (mais rápido)
      return await _dataSourceLocal.buscarTodas();
    } catch (e) {
      // Se falhar localmente, tenta buscar remotamente
      try {
        final transacoesRemotas = await _dataSourceRemoto.buscarTodas();
        // Salva localmente para cache
        for (final transacao in transacoesRemotas) {
          await _dataSourceLocal.inserir(transacao);
        }
        return transacoesRemotas;
      } catch (e) {
        throw Exception('Erro ao buscar transações: $e');
      }
    }
  }

  @override
  Future<List<Transacao>> buscarPorPeriodo({
    required DateTime dataInicio,
    required DateTime dataFim,
  }) async {
    try {
      // Busca local primeiro
      return await _dataSourceLocal.buscarPorPeriodo(
        dataInicio: dataInicio,
        dataFim: dataFim,
      );
    } catch (e) {
      // Se falhar, busca remotamente
      try {
        final transacoesRemotas = await _dataSourceRemoto.buscarPorPeriodo(
          dataInicio: dataInicio,
          dataFim: dataFim,
        );
        return transacoesRemotas;
      } catch (e) {
        throw Exception('Erro ao buscar transações por período: $e');
      }
    }
  }

  @override
  Future<List<Transacao>> buscarPorCategoria(String categoriaId) async {
    try {
      return await _dataSourceLocal.buscarPorCategoria(categoriaId);
    } catch (e) {
      throw Exception('Erro ao buscar transações por categoria: $e');
    }
  }

  @override
  Future<Transacao?> buscarPorId(String id) async {
    try {
      return await _dataSourceLocal.buscarPorId(id);
    } catch (e) {
      throw Exception('Erro ao buscar transação: $e');
    }
  }

  @override
  Future<void> criar(Transacao transacao) async {
    try {
      final model = TransacaoModel.deEntidade(transacao);
      
      // Salva localmente primeiro
      await _dataSourceLocal.inserir(model);
      
      // Marca para sincronização
      await _dataSourceLocal.marcarComoNaoSincronizada(transacao.id, 'criar');
      
      // Tenta sincronizar imediatamente (mas não bloqueia se falhar)
      try {
        await _dataSourceRemoto.criar(model);
      } catch (e) {
        // Será sincronizado depois
        print('Erro ao sincronizar criação: $e');
      }
    } catch (e) {
      throw Exception('Erro ao criar transação: $e');
    }
  }

  @override
  Future<void> atualizar(Transacao transacao) async {
    try {
      final model = TransacaoModel.deEntidade(transacao);
      
      // Atualiza localmente primeiro
      await _dataSourceLocal.atualizar(model);
      
      // Marca para sincronização
      await _dataSourceLocal.marcarComoNaoSincronizada(transacao.id, 'atualizar');
      
      // Tenta sincronizar imediatamente (mas não bloqueia se falhar)
      try {
        await _dataSourceRemoto.atualizar(model);
      } catch (e) {
        print('Erro ao sincronizar atualização: $e');
      }
    } catch (e) {
      throw Exception('Erro ao atualizar transação: $e');
    }
  }

  @override
  Future<void> deletar(String id) async {
    try {
      // Deleta localmente primeiro
      await _dataSourceLocal.deletar(id);
      
      // Marca para sincronização
      await _dataSourceLocal.marcarComoNaoSincronizada(id, 'deletar');
      
      // Tenta sincronizar imediatamente (mas não bloqueia se falhar)
      try {
        await _dataSourceRemoto.deletar(id);
      } catch (e) {
        print('Erro ao sincronizar exclusão: $e');
      }
    } catch (e) {
      throw Exception('Erro ao deletar transação: $e');
    }
  }

  @override
  Future<void> sincronizar() async {
    try {
      // Busca registros não sincronizados
      final naoSincronizados = await _dataSourceLocal.buscarNaoSincronizadas();
      
      for (final registro in naoSincronizados) {
        try {
          final acao = registro['acao'] as String;
          final registroId = registro['registro_id'] as String;
          
          switch (acao) {
            case 'criar':
              final transacao = await _dataSourceLocal.buscarPorId(registroId);
              if (transacao != null) {
                await _dataSourceRemoto.criar(transacao);
              }
              break;
            case 'atualizar':
              final transacao = await _dataSourceLocal.buscarPorId(registroId);
              if (transacao != null) {
                await _dataSourceRemoto.atualizar(transacao);
              }
              break;
            case 'deletar':
              await _dataSourceRemoto.deletar(registroId);
              break;
          }
          
          // Marca como sincronizado
          await _dataSourceLocal.marcarComoSincronizada(registro['id'] as String);
        } catch (e) {
          print('Erro ao sincronizar registro ${registro['id']}: $e');
        }
      }
    } catch (e) {
      throw Exception('Erro ao sincronizar: $e');
    }
  }
}
