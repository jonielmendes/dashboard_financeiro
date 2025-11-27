import '../modelos/categoria_model.dart';
import 'banco_dados_local.dart';

/// Data Source Local para Categorias usando SQLite
class CategoriaDataSourceLocal {
  final BancoDadosLocal _bancoDados;

  CategoriaDataSourceLocal(this._bancoDados);

  /// Busca todas as categorias
  Future<List<CategoriaModel>> buscarTodas() async {
    final db = await _bancoDados.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'categorias',
      orderBy: 'nome ASC',
    );

    return List.generate(maps.length, (i) {
      return CategoriaModel.doMapSQLite(maps[i]);
    });
  }

  /// Busca categorias por tipo
  Future<List<CategoriaModel>> buscarPorTipo(String tipo) async {
    final db = await _bancoDados.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'categorias',
      where: 'tipo = ?',
      whereArgs: [tipo],
      orderBy: 'nome ASC',
    );

    return List.generate(maps.length, (i) {
      return CategoriaModel.doMapSQLite(maps[i]);
    });
  }

  /// Busca uma categoria pelo ID
  Future<CategoriaModel?> buscarPorId(String id) async {
    final db = await _bancoDados.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'categorias',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return CategoriaModel.doMapSQLite(maps.first);
  }

  /// Insere uma nova categoria
  Future<void> inserir(CategoriaModel categoria) async {
    final db = await _bancoDados.database;
    await db.insert(
      'categorias',
      categoria.paraMapSQLite(),
    );
  }

  /// Atualiza uma categoria existente
  Future<void> atualizar(CategoriaModel categoria) async {
    final db = await _bancoDados.database;
    await db.update(
      'categorias',
      categoria.paraMapSQLite(),
      where: 'id = ?',
      whereArgs: [categoria.id],
    );
  }

  /// Deleta uma categoria
  Future<void> deletar(String id) async {
    final db = await _bancoDados.database;
    await db.delete(
      'categorias',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
