import 'package:equatable/equatable.dart';
import '../../../dominio/entidades/categoria.dart';

abstract class CategoriaEvent extends Equatable {
  const CategoriaEvent();

  @override
  List<Object?> get props => [];
}

class CarregarCategorias extends CategoriaEvent {}

class CarregarCategoriasPorTipo extends CategoriaEvent {
  final TipoCategoria tipo;

  const CarregarCategoriasPorTipo(this.tipo);

  @override
  List<Object?> get props => [tipo];
}
