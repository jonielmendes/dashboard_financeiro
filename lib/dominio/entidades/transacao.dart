import 'package:equatable/equatable.dart';

/// Entidade representando uma transação financeira
/// Seguindo Clean Architecture, essa entidade é independente de frameworks
class Transacao extends Equatable {
  final String id;
  final String titulo;
  final double valor;
  final String categoriaId;
  final DateTime data;
  final TipoTransacao tipo;
  final String? descricao;
  final DateTime criadoEm;
  final DateTime atualizadoEm;

  const Transacao({
    required this.id,
    required this.titulo,
    required this.valor,
    required this.categoriaId,
    required this.data,
    required this.tipo,
    this.descricao,
    required this.criadoEm,
    required this.atualizadoEm,
  });

  @override
  List<Object?> get props => [
        id,
        titulo,
        valor,
        categoriaId,
        data,
        tipo,
        descricao,
        criadoEm,
        atualizadoEm,
      ];

  Transacao copiarCom({
    String? id,
    String? titulo,
    double? valor,
    String? categoriaId,
    DateTime? data,
    TipoTransacao? tipo,
    String? descricao,
    DateTime? criadoEm,
    DateTime? atualizadoEm,
  }) {
    return Transacao(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      valor: valor ?? this.valor,
      categoriaId: categoriaId ?? this.categoriaId,
      data: data ?? this.data,
      tipo: tipo ?? this.tipo,
      descricao: descricao ?? this.descricao,
      criadoEm: criadoEm ?? this.criadoEm,
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
    );
  }
}

/// Tipo de transação: Receita ou Despesa
enum TipoTransacao {
  receita,
  despesa;

  String get nome {
    switch (this) {
      case TipoTransacao.receita:
        return 'Receita';
      case TipoTransacao.despesa:
        return 'Despesa';
    }
  }
}
