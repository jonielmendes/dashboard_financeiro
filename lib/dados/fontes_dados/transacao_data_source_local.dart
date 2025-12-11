import '../modelos/transacao_model.dart';
import 'banco_dados_local.dart';

/// Data Source Local para Transações usando SQLite
class TransacaoDataSourceLocal {
  final BancoDadosLocal _bancoDados;

  TransacaoDataSourceLocal(this._bancoDados);

  /// Busca todas as transações
  Future<List<TransacaoModel>> buscarTodas() async {
    final db = await _bancoDados.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transacoes',
      orderBy: 'data DESC',
    );

    print('🔍 Buscando transações no banco... Total: ${maps.length}');
    if (maps.isNotEmpty) {
      print('📋 Primeira transação: ${maps.first}');
    }

    return List.generate(maps.length, (i) {
      return TransacaoModel.doMapSQLite(maps[i]);
    });
  }

  /// Busca transações por período
  Future<List<TransacaoModel>> buscarPorPeriodo({
    required DateTime dataInicio,
    required DateTime dataFim,
  }) async {
    final db = await _bancoDados.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transacoes',
      where: 'data >= ? AND data <= ?',
      whereArgs: [dataInicio.toIso8601String(), dataFim.toIso8601String()],
      orderBy: 'data DESC',
    );

    return List.generate(maps.length, (i) {
      return TransacaoModel.doMapSQLite(maps[i]);
    });
  }

  /// Busca transações por categoria
  Future<List<TransacaoModel>> buscarPorCategoria(String categoriaId) async {
    final db = await _bancoDados.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transacoes',
      where: 'categoria_id = ?',
      whereArgs: [categoriaId],
      orderBy: 'data DESC',
    );

    return List.generate(maps.length, (i) {
      return TransacaoModel.doMapSQLite(maps[i]);
    });
  }

  /// Busca uma transação pelo ID
  Future<TransacaoModel?> buscarPorId(String id) async {
    final db = await _bancoDados.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transacoes',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return TransacaoModel.doMapSQLite(maps.first);
  }

  /// Insere uma nova transação
  Future<void> inserir(TransacaoModel transacao) async {
    final db = await _bancoDados.database;
    final map = transacao.paraMapSQLite();
    print('🔵 Inserindo transação no banco: $map');
    await db.insert(
      //executa
      'transacoes',
      map,
    );
    print('✅ Transação inserida com sucesso!');
  }

  /// Atualiza uma transação existente
  Future<void> atualizar(TransacaoModel transacao) async {
    final db = await _bancoDados.database;
    await db.update(
      'transacoes',
      transacao.paraMapSQLite(),
      where: 'id = ?',
      whereArgs: [transacao.id],
    );
  }

  /// Deleta uma transação
  Future<void> deletar(String id) async {
    final db = await _bancoDados.database;
    await db.delete('transacoes', where: 'id = ?', whereArgs: [id]);
  }

  /// Marca uma transação como não sincronizada
  Future<void> marcarComoNaoSincronizada(String id, String acao) async {
    final db = await _bancoDados.database;
    await db.insert('sincronizacao', {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'tabela': 'transacoes',
      'registro_id': id,
      'acao': acao,
      'sincronizado': 0,
      'criado_em': DateTime.now().toIso8601String(),
    });
  }

  /// Busca transações não sincronizadas
  Future<List<Map<String, dynamic>>> buscarNaoSincronizadas() async {
    final db = await _bancoDados.database;
    return await db.query(
      'sincronizacao',
      where: 'tabela = ? AND sincronizado = ?',
      whereArgs: ['transacoes', 0],
    );
  }

  /// Marca como sincronizado
  Future<void> marcarComoSincronizada(String sincronizacaoId) async {
    final db = await _bancoDados.database;
    await db.update(
      'sincronizacao',
      {'sincronizado': 1},
      where: 'id = ?',
      whereArgs: [sincronizacaoId],
    );
  }
}
