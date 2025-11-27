import 'package:equatable/equatable.dart';
import '../../../dominio/entidades/categoria.dart';

abstract class CategoriaState extends Equatable {
  const CategoriaState();

  @override
  List<Object?> get props => [];
}

class CategoriaInicial extends CategoriaState {}

class CategoriaCarregando extends CategoriaState {}

class CategoriaCarregada extends CategoriaState {
  final List<Categoria> categorias;

  const CategoriaCarregada(this.categorias);

  @override
  List<Object?> get props => [categorias];
}

class CategoriaErro extends CategoriaState {
  final String mensagem;

  const CategoriaErro(this.mensagem);

  @override
  List<Object?> get props => [mensagem];
}
