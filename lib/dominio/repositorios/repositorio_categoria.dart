import '../entidades/categoria.dart';

/// Interface do Repository de Categorias
/// Define o contrato para acesso aos dados de categorias
abstract class RepositorioCategoria {
  /// Busca todas as categorias
  Future<List<Categoria>> buscarTodas();

  /// Busca categorias por tipo
  Future<List<Categoria>> buscarPorTipo(TipoCategoria tipo);

  /// Busca uma categoria pelo ID
  Future<Categoria?> buscarPorId(String id);

  /// Cria uma nova categoria
  Future<void> criar(Categoria categoria);

  /// Atualiza uma categoria existente
  Future<void> atualizar(Categoria categoria);

  /// Deleta uma categoria
  Future<void> deletar(String id);

  /// Sincroniza dados locais com o servidor
  Future<void> sincronizar();
}
