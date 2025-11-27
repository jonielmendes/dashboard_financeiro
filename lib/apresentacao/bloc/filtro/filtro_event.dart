import 'package:equatable/equatable.dart';
import '../../../dominio/entidades/filtro_data.dart';

abstract class FiltroEvent extends Equatable {
  const FiltroEvent();

  @override
  List<Object?> get props => [];
}

class AlterarFiltroData extends FiltroEvent {
  final FiltroData filtroData;

  const AlterarFiltroData(this.filtroData);

  @override
  List<Object?> get props => [filtroData];
}

class AlterarCategoriaFiltro extends FiltroEvent {
  final String? categoriaId;

  const AlterarCategoriaFiltro(this.categoriaId);

  @override
  List<Object?> get props => [categoriaId];
}

class LimparFiltros extends FiltroEvent {}
