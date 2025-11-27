import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// Gerenciador do banco de dados SQLite local
/// Implementa o padrão Singleton para garantir uma única instância
class BancoDadosLocal {
  static final BancoDadosLocal _instancia = BancoDadosLocal._interno();
  static Database? _database;

  factory BancoDadosLocal() => _instancia;

  BancoDadosLocal._interno();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _inicializarBanco();
    return _database!;
  }

  Future<Database> _inicializarBanco() async {
    final caminhoDb = await getDatabasesPath();
    final caminho = join(caminhoDb, 'dashboard_financeiro.db');

    return await openDatabase(
      caminho,
      version: 1,
      onCreate: _criarBanco,
    );
  }

  Future<void> _criarBanco(Database db, int version) async {
    // Tabela de Categorias
    await db.execute('''
      CREATE TABLE categorias (
        id TEXT PRIMARY KEY,
        nome TEXT NOT NULL,
        icone TEXT NOT NULL,
        cor_hex TEXT NOT NULL,
        tipo TEXT NOT NULL
      )
    ''');

    // Tabela de Transações
    await db.execute('''
      CREATE TABLE transacoes (
        id TEXT PRIMARY KEY,
        titulo TEXT NOT NULL,
        valor REAL NOT NULL,
        categoria_id TEXT NOT NULL,
        data TEXT NOT NULL,
        tipo TEXT NOT NULL,
        descricao TEXT,
        criado_em TEXT NOT NULL,
        atualizado_em TEXT NOT NULL,
        FOREIGN KEY (categoria_id) REFERENCES categorias (id)
      )
    ''');

    // Tabela de Sincronização (para controlar o que já foi sincronizado)
    await db.execute('''
      CREATE TABLE sincronizacao (
        id TEXT PRIMARY KEY,
        tabela TEXT NOT NULL,
        registro_id TEXT NOT NULL,
        acao TEXT NOT NULL,
        sincronizado INTEGER NOT NULL DEFAULT 0,
        criado_em TEXT NOT NULL
      )
    ''');

    // Inserir categorias padrão
    await _inserirCategoriasPadrao(db);
  }

  Future<void> _inserirCategoriasPadrao(Database db) async {
    final categoriasPadrao = [
      // Categorias de Despesa
      {
        'id': 'cat_001',
        'nome': 'Alimentação',
        'icone': '🍔',
        'cor_hex': '#FF6B6B',
        'tipo': 'despesa'
      },
      {
        'id': 'cat_002',
        'nome': 'Transporte',
        'icone': '🚗',
        'cor_hex': '#4ECDC4',
        'tipo': 'despesa'
      },
      {
        'id': 'cat_003',
        'nome': 'Moradia',
        'icone': '🏠',
        'cor_hex': '#95E1D3',
        'tipo': 'despesa'
      },
      {
        'id': 'cat_004',
        'nome': 'Saúde',
        'icone': '⚕️',
        'cor_hex': '#F38181',
        'tipo': 'despesa'
      },
      {
        'id': 'cat_005',
        'nome': 'Lazer',
        'icone': '🎮',
        'cor_hex': '#AA96DA',
        'tipo': 'despesa'
      },
      {
        'id': 'cat_006',
        'nome': 'Educação',
        'icone': '📚',
        'cor_hex': '#FCBAD3',
        'tipo': 'despesa'
      },
      // Categorias de Receita
      {
        'id': 'cat_007',
        'nome': 'Salário',
        'icone': '💰',
        'cor_hex': '#6BCF7F',
        'tipo': 'receita'
      },
      {
        'id': 'cat_008',
        'nome': 'Freelance',
        'icone': '💻',
        'cor_hex': '#4D96FF',
        'tipo': 'receita'
      },
      {
        'id': 'cat_009',
        'nome': 'Investimentos',
        'icone': '📈',
        'cor_hex': '#FFD93D',
        'tipo': 'receita'
      },
    ];

    for (final categoria in categoriasPadrao) {
      await db.insert('categorias', categoria);
    }
  }

  Future<void> fechar() async {
    final db = await database;
    await db.close();
  }
}
