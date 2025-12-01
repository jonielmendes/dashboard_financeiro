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

class AdicionarCategoria extends CategoriaEvent {
  final Categoria categoria;

  const AdicionarCategoria(this.categoria);

  @override
  List<Object?> get props => [categoria];
}

class ExcluirCategoria extends CategoriaEvent {
  final String categoriaId;

  const ExcluirCategoria(this.categoriaId);

  @override
  List<Object?> get props => [categoriaId];
}
