import '../../dominio/entidades/categoria.dart';
import '../../dominio/repositorios/repositorio_categoria.dart';
import '../fontes_dados/categoria_data_source_local.dart';

/// Implementação do Repository de Categorias
/// Usa apenas fonte de dados local (categorias são gerenciadas localmente)
class RepositorioCategoriaImpl implements RepositorioCategoria {
  final CategoriaDataSourceLocal _dataSourceLocal;

  RepositorioCategoriaImpl(this._dataSourceLocal);

  @override
  Future<List<Categoria>> buscarTodas() async {
    try {
      return await _dataSourceLocal.buscarTodas();
    } catch (e) {
      throw Exception('Erro ao buscar categorias: $e');
    }
  }

  @override
  Future<List<Categoria>> buscarPorTipo(TipoCategoria tipo) async {
    try {
      final tipoString = tipo == TipoCategoria.receita ? 'receita' : 'despesa';
      return await _dataSourceLocal.buscarPorTipo(tipoString);
    } catch (e) {
      throw Exception('Erro ao buscar categorias por tipo: $e');
    }
  }

  @override
  Future<Categoria?> buscarPorId(String id) async {
    try {
      return await _dataSourceLocal.buscarPorId(id);
    } catch (e) {
      throw Exception('Erro ao buscar categoria: $e');
    }
  }

  @override
  Future<void> criar(Categoria categoria) async {
    try {
      final model = categoria as dynamic;
      await _dataSourceLocal.inserir(model);
    } catch (e) {
      throw Exception('Erro ao criar categoria: $e');
    }
  }

  @override
  Future<void> atualizar(Categoria categoria) async {
    try {
      final model = categoria as dynamic;
      await _dataSourceLocal.atualizar(model);
    } catch (e) {
      throw Exception('Erro ao atualizar categoria: $e');
    }
  }

  @override
  Future<void> deletar(String id) async {
    try {
      await _dataSourceLocal.deletar(id);
    } catch (e) {
      throw Exception('Erro ao deletar categoria: $e');
    }
  }

  @override
  Future<void> sincronizar() async {
    // Categorias não precisam de sincronização remota neste momento
    // Pode ser implementado futuramente se necessário
    return Future.value();
  }
}
