import '../../dominio/entidades/transacao.dart';

/// Model de Transação para a camada de dados
/// Responsável por serialização/deserialização
class TransacaoModel extends Transacao {
  const TransacaoModel({
    required super.id,
    required super.titulo,
    required super.valor,
    required super.categoriaId,
    required super.data,
    required super.tipo,
    super.descricao,
    required super.criadoEm,
    required super.atualizadoEm,
  });

  /// Converte de JSON (usado para GraphQL/Hasura)
  factory TransacaoModel.deJson(Map<String, dynamic> json) {
    return TransacaoModel(
      id: json['id'] as String,
      titulo: json['titulo'] as String,
      valor: (json['valor'] as num).toDouble(),
      categoriaId: json['categoria_id'] as String,
      data: DateTime.parse(json['data'] as String),
      tipo: json['tipo'] == 'receita' ? TipoTransacao.receita : TipoTransacao.despesa,
      descricao: json['descricao'] as String?,
      criadoEm: DateTime.parse(json['criado_em'] as String),
      atualizadoEm: DateTime.parse(json['atualizado_em'] as String),
    );
  }

  /// Converte para JSON (usado para GraphQL/Hasura)
  Map<String, dynamic> paraJson() {
    return {
      'id': id,
      'titulo': titulo,
      'valor': valor,
      'categoria_id': categoriaId,
      'data': data.toIso8601String(),
      'tipo': tipo == TipoTransacao.receita ? 'receita' : 'despesa',
      'descricao': descricao,
      'criado_em': criadoEm.toIso8601String(),
      'atualizado_em': atualizadoEm.toIso8601String(),
    };
  }

  /// Converte de Map do SQLite
  factory TransacaoModel.doMapSQLite(Map<String, dynamic> map) {
    return TransacaoModel(
      id: map['id'] as String,
      titulo: map['titulo'] as String,
      valor: map['valor'] as double,
      categoriaId: map['categoria_id'] as String,
      data: DateTime.parse(map['data'] as String),
      tipo: map['tipo'] == 'receita' ? TipoTransacao.receita : TipoTransacao.despesa,
      descricao: map['descricao'] as String?,
      criadoEm: DateTime.parse(map['criado_em'] as String),
      atualizadoEm: DateTime.parse(map['atualizado_em'] as String),
    );
  }

  /// Converte para Map do SQLite
  Map<String, dynamic> paraMapSQLite() {
    return {
      'id': id,
      'titulo': titulo,
      'valor': valor,
      'categoria_id': categoriaId,
      'data': data.toIso8601String(),
      'tipo': tipo == TipoTransacao.receita ? 'receita' : 'despesa',
      'descricao': descricao,
      'criado_em': criadoEm.toIso8601String(),
      'atualizado_em': atualizadoEm.toIso8601String(),
    };
  }

  /// Converte de entidade para model
  factory TransacaoModel.deEntidade(Transacao transacao) {
    return TransacaoModel(
      id: transacao.id,
      titulo: transacao.titulo,
      valor: transacao.valor,
      categoriaId: transacao.categoriaId,
      data: transacao.data,
      tipo: transacao.tipo,
      descricao: transacao.descricao,
      criadoEm: transacao.criadoEm,
      atualizadoEm: transacao.atualizadoEm,
    );
  }
}
