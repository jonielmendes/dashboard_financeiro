import 'package:uuid/uuid.dart';
import '../../dominio/entidades/transacao.dart';

/// Classe utilitária para popular o banco com dados de teste realistas
class DadosTeste {
  static const _uuid = Uuid();

  /// Gera transações de teste para o último mês (30 dias)
  static List<Transacao> gerarTransacoesTeste() {
    final agora = DateTime.now();
    return _gerarTransacoesMes(agora.year, agora.month);
  }

  /// Gera transações realistas para um mês específico
  static List<Transacao> _gerarTransacoesMes(int ano, int mes) {
    final transacoes = <Transacao>[];

    // ========== RECEITAS ==========

    // Salário no dia 1
    transacoes.add(
      Transacao(
        id: _uuid.v4(),
        titulo: 'Salário',
        valor: 5500.00,
        categoriaId: 'cat_007',
        data: DateTime(ano, mes, 1),
        tipo: TipoTransacao.receita,
        descricao: 'Salário mensal',
        criadoEm: DateTime.now(),
        atualizadoEm: DateTime.now(),
      ),
    );

    // Freelance no dia 15
    transacoes.add(
      Transacao(
        id: _uuid.v4(),
        titulo: 'Freelance - App Mobile',
        valor: 1800.00,
        categoriaId: 'cat_008',
        data: DateTime(ano, mes, 15),
        tipo: TipoTransacao.receita,
        descricao: 'Desenvolvimento de aplicativo',
        criadoEm: DateTime.now(),
        atualizadoEm: DateTime.now(),
      ),
    );

    // Dividendos no dia 10
    transacoes.add(
      Transacao(
        id: _uuid.v4(),
        titulo: 'Dividendos',
        valor: 420.00,
        categoriaId: 'cat_009',
        data: DateTime(ano, mes, 10),
        tipo: TipoTransacao.receita,
        descricao: 'Dividendos de ações e FIIs',
        criadoEm: DateTime.now(),
        atualizadoEm: DateTime.now(),
      ),
    );

    // ========== DESPESAS FIXAS ==========

    // MORADIA
    transacoes.add(
      Transacao(
        id: _uuid.v4(),
        titulo: 'Aluguel',
        valor: 1500.00,
        categoriaId: 'cat_003',
        data: DateTime(ano, mes, 5),
        tipo: TipoTransacao.despesa,
        descricao: 'Aluguel mensal',
        criadoEm: DateTime.now(),
        atualizadoEm: DateTime.now(),
      ),
    );

    transacoes.add(
      Transacao(
        id: _uuid.v4(),
        titulo: 'Conta de Luz',
        valor: 215.80,
        categoriaId: 'cat_003',
        data: DateTime(ano, mes, 8),
        tipo: TipoTransacao.despesa,
        descricao: 'Energia elétrica',
        criadoEm: DateTime.now(),
        atualizadoEm: DateTime.now(),
      ),
    );

    transacoes.add(
      Transacao(
        id: _uuid.v4(),
        titulo: 'Conta de Água',
        valor: 95.00,
        categoriaId: 'cat_003',
        data: DateTime(ano, mes, 10),
        tipo: TipoTransacao.despesa,
        descricao: 'Água e esgoto',
        criadoEm: DateTime.now(),
        atualizadoEm: DateTime.now(),
      ),
    );

    transacoes.add(
      Transacao(
        id: _uuid.v4(),
        titulo: 'Internet + TV',
        valor: 149.90,
        categoriaId: 'cat_003',
        data: DateTime(ano, mes, 12),
        tipo: TipoTransacao.despesa,
        descricao: 'Internet fibra 300MB + TV',
        criadoEm: DateTime.now(),
        atualizadoEm: DateTime.now(),
      ),
    );

    transacoes.add(
      Transacao(
        id: _uuid.v4(),
        titulo: 'Condomínio',
        valor: 380.00,
        categoriaId: 'cat_003',
        data: DateTime(ano, mes, 6),
        tipo: TipoTransacao.despesa,
        descricao: 'Taxa de condomínio',
        criadoEm: DateTime.now(),
        atualizadoEm: DateTime.now(),
      ),
    );

    // ALIMENTAÇÃO - Supermercado
    final comprasSupermercado = [
      {'dia': 3, 'valor': 285.50},
      {'dia': 9, 'valor': 156.80},
      {'dia': 16, 'valor': 312.00},
      {'dia': 23, 'valor': 198.75},
    ];

    for (var compra in comprasSupermercado) {
      transacoes.add(
        Transacao(
          id: _uuid.v4(),
          titulo: 'Supermercado',
          valor: compra['valor'] as double,
          categoriaId: 'cat_001',
          data: DateTime(ano, mes, compra['dia'] as int),
          tipo: TipoTransacao.despesa,
          descricao: 'Compras do mês',
          criadoEm: DateTime.now(),
          atualizadoEm: DateTime.now(),
        ),
      );
    }

    // ALIMENTAÇÃO - Restaurantes
    transacoes.add(
      Transacao(
        id: _uuid.v4(),
        titulo: 'Restaurante',
        valor: 85.00,
        categoriaId: 'cat_001',
        data: DateTime(ano, mes, 7),
        tipo: TipoTransacao.despesa,
        descricao: 'Almoço domingo',
        criadoEm: DateTime.now(),
        atualizadoEm: DateTime.now(),
      ),
    );

    transacoes.add(
      Transacao(
        id: _uuid.v4(),
        titulo: 'iFood',
        valor: 45.50,
        categoriaId: 'cat_001',
        data: DateTime(ano, mes, 14),
        tipo: TipoTransacao.despesa,
        descricao: 'Jantar delivery',
        criadoEm: DateTime.now(),
        atualizadoEm: DateTime.now(),
      ),
    );

    transacoes.add(
      Transacao(
        id: _uuid.v4(),
        titulo: 'Restaurante',
        valor: 92.00,
        categoriaId: 'cat_001',
        data: DateTime(ano, mes, 21),
        tipo: TipoTransacao.despesa,
        descricao: 'Jantar com amigos',
        criadoEm: DateTime.now(),
        atualizadoEm: DateTime.now(),
      ),
    );

    transacoes.add(
      Transacao(
        id: _uuid.v4(),
        titulo: 'Delivery',
        valor: 38.90,
        categoriaId: 'cat_001',
        data: DateTime(ano, mes, 28),
        tipo: TipoTransacao.despesa,
        descricao: 'Pizza',
        criadoEm: DateTime.now(),
        atualizadoEm: DateTime.now(),
      ),
    );

    // TRANSPORTE
    transacoes.add(
      Transacao(
        id: _uuid.v4(),
        titulo: 'Combustível',
        valor: 320.00,
        categoriaId: 'cat_002',
        data: DateTime(ano, mes, 4),
        tipo: TipoTransacao.despesa,
        descricao: 'Abastecimento',
        criadoEm: DateTime.now(),
        atualizadoEm: DateTime.now(),
      ),
    );

    transacoes.add(
      Transacao(
        id: _uuid.v4(),
        titulo: 'Combustível',
        valor: 280.00,
        categoriaId: 'cat_002',
        data: DateTime(ano, mes, 18),
        tipo: TipoTransacao.despesa,
        descricao: 'Abastecimento',
        criadoEm: DateTime.now(),
        atualizadoEm: DateTime.now(),
      ),
    );

    transacoes.add(
      Transacao(
        id: _uuid.v4(),
        titulo: 'Uber',
        valor: 65.50,
        categoriaId: 'cat_002',
        data: DateTime(ano, mes, 20),
        tipo: TipoTransacao.despesa,
        descricao: 'Corridas',
        criadoEm: DateTime.now(),
        atualizadoEm: DateTime.now(),
      ),
    );

    transacoes.add(
      Transacao(
        id: _uuid.v4(),
        titulo: 'Estacionamento',
        valor: 25.00,
        categoriaId: 'cat_002',
        data: DateTime(ano, mes, 22),
        tipo: TipoTransacao.despesa,
        descricao: 'Shopping',
        criadoEm: DateTime.now(),
        atualizadoEm: DateTime.now(),
      ),
    );

    // SAÚDE
    transacoes.add(
      Transacao(
        id: _uuid.v4(),
        titulo: 'Plano de Saúde',
        valor: 520.00,
        categoriaId: 'cat_004',
        data: DateTime(ano, mes, 7),
        tipo: TipoTransacao.despesa,
        descricao: 'Plano familiar',
        criadoEm: DateTime.now(),
        atualizadoEm: DateTime.now(),
      ),
    );

    transacoes.add(
      Transacao(
        id: _uuid.v4(),
        titulo: 'Farmácia',
        valor: 125.40,
        categoriaId: 'cat_004',
        data: DateTime(ano, mes, 14),
        tipo: TipoTransacao.despesa,
        descricao: 'Medicamentos',
        criadoEm: DateTime.now(),
        atualizadoEm: DateTime.now(),
      ),
    );

    transacoes.add(
      Transacao(
        id: _uuid.v4(),
        titulo: 'Academia',
        valor: 89.90,
        categoriaId: 'cat_004',
        data: DateTime(ano, mes, 2),
        tipo: TipoTransacao.despesa,
        descricao: 'Mensalidade',
        criadoEm: DateTime.now(),
        atualizadoEm: DateTime.now(),
      ),
    );

    // LAZER
    transacoes.add(
      Transacao(
        id: _uuid.v4(),
        titulo: 'Netflix',
        valor: 55.90,
        categoriaId: 'cat_005',
        data: DateTime(ano, mes, 1),
        tipo: TipoTransacao.despesa,
        descricao: 'Streaming',
        criadoEm: DateTime.now(),
        atualizadoEm: DateTime.now(),
      ),
    );

    transacoes.add(
      Transacao(
        id: _uuid.v4(),
        titulo: 'Spotify',
        valor: 21.90,
        categoriaId: 'cat_005',
        data: DateTime(ano, mes, 1),
        tipo: TipoTransacao.despesa,
        descricao: 'Música',
        criadoEm: DateTime.now(),
        atualizadoEm: DateTime.now(),
      ),
    );

    transacoes.add(
      Transacao(
        id: _uuid.v4(),
        titulo: 'Cinema',
        valor: 85.00,
        categoriaId: 'cat_005',
        data: DateTime(ano, mes, 13),
        tipo: TipoTransacao.despesa,
        descricao: 'Ingressos + pipoca',
        criadoEm: DateTime.now(),
        atualizadoEm: DateTime.now(),
      ),
    );

    transacoes.add(
      Transacao(
        id: _uuid.v4(),
        titulo: 'Shopping',
        valor: 245.00,
        categoriaId: 'cat_005',
        data: DateTime(ano, mes, 19),
        tipo: TipoTransacao.despesa,
        descricao: 'Compras',
        criadoEm: DateTime.now(),
        atualizadoEm: DateTime.now(),
      ),
    );

    // EDUCAÇÃO
    transacoes.add(
      Transacao(
        id: _uuid.v4(),
        titulo: 'Curso Online',
        valor: 147.00,
        categoriaId: 'cat_006',
        data: DateTime(ano, mes, 11),
        tipo: TipoTransacao.despesa,
        descricao: 'Flutter Avançado',
        criadoEm: DateTime.now(),
        atualizadoEm: DateTime.now(),
      ),
    );

    transacoes.add(
      Transacao(
        id: _uuid.v4(),
        titulo: 'Livros Técnicos',
        valor: 189.90,
        categoriaId: 'cat_006',
        data: DateTime(ano, mes, 25),
        tipo: TipoTransacao.despesa,
        descricao: 'Programação',
        criadoEm: DateTime.now(),
        atualizadoEm: DateTime.now(),
      ),
    );

    return transacoes;
  }
}
