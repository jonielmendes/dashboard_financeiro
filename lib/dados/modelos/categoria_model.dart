import '../../dominio/entidades/categoria.dart';

/// Model de Categoria para a camada de dados
/// Responsável por serialização/deserialização
class CategoriaModel extends Categoria {
  const CategoriaModel({
    required super.id,
    required super.nome,
    required super.icone,
    required super.corHex,
    required super.tipo,
  });

  /// Converte de JSON (usado para GraphQL/Hasura)
  factory CategoriaModel.deJson(Map<String, dynamic> json) {
    return CategoriaModel(
      id: json['id'] as String,
      nome: json['nome'] as String,
      icone: json['icone'] as String,
      corHex: json['cor_hex'] as String,
      tipo: json['tipo'] == 'receita' ? TipoCategoria.receita : TipoCategoria.despesa,
    );
  }

  /// Converte para JSON (usado para GraphQL/Hasura)
  Map<String, dynamic> paraJson() {
    return {
      'id': id,
      'nome': nome,
      'icone': icone,
      'cor_hex': corHex,
      'tipo': tipo == TipoCategoria.receita ? 'receita' : 'despesa',
    };
  }

  /// Converte de Map do SQLite
  factory CategoriaModel.doMapSQLite(Map<String, dynamic> map) {
    return CategoriaModel(
      id: map['id'] as String,
      nome: map['nome'] as String,
      icone: map['icone'] as String,
      corHex: map['cor_hex'] as String,
      tipo: map['tipo'] == 'receita' ? TipoCategoria.receita : TipoCategoria.despesa,
    );
  }

  /// Converte para Map do SQLite
  Map<String, dynamic> paraMapSQLite() {
    return {
      'id': id,
      'nome': nome,
      'icone': icone,
      'cor_hex': corHex,
      'tipo': tipo == TipoCategoria.receita ? 'receita' : 'despesa',
    };
  }

  /// Converte de entidade para model
  factory CategoriaModel.deEntidade(Categoria categoria) {
    return CategoriaModel(
      id: categoria.id,
      nome: categoria.nome,
      icone: categoria.icone,
      corHex: categoria.corHex,
      tipo: categoria.tipo,
    );
  }
}
