import 'package:equatable/equatable.dart';
import '../../../dominio/entidades/filtro_data.dart';

/// Estado do BLoC de Filtros
class FiltroState extends Equatable {
  final FiltroData filtroData;
  final String? categoriaIdSelecionada;

  const FiltroState({
    required this.filtroData,
    this.categoriaIdSelecionada,
  });

  FiltroState copiarCom({
    FiltroData? filtroData,
    String? categoriaIdSelecionada,
    bool limparCategoria = false,
  }) {
    return FiltroState(
      filtroData: filtroData ?? this.filtroData,
      categoriaIdSelecionada: limparCategoria ? null : (categoriaIdSelecionada ?? this.categoriaIdSelecionada),
    );
  }

  @override
  List<Object?> get props => [filtroData, categoriaIdSelecionada];
}
