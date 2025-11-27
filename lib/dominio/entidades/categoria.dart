import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Entidade representando uma categoria financeira
class Categoria extends Equatable {
  final String id;
  final String nome;
  final String icone;
  final String corHex;
  final TipoCategoria tipo;

  const Categoria({
    required this.id,
    required this.nome,
    required this.icone,
    required this.corHex,
    required this.tipo,
  });

  Color get cor => Color(int.parse(corHex.replaceFirst('#', '0xFF')));

  @override
  List<Object?> get props => [id, nome, icone, corHex, tipo];

  Categoria copiarCom({
    String? id,
    String? nome,
    String? icone,
    String? corHex,
    TipoCategoria? tipo,
  }) {
    return Categoria(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      icone: icone ?? this.icone,
      corHex: corHex ?? this.corHex,
      tipo: tipo ?? this.tipo,
    );
  }
}

enum TipoCategoria {
  receita,
  despesa;

  String get nome {
    switch (this) {
      case TipoCategoria.receita:
        return 'Receita';
      case TipoCategoria.despesa:
        return 'Despesa';
    }
  }
}
