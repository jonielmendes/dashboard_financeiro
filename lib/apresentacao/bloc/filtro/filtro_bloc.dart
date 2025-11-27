import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../dominio/entidades/filtro_data.dart';
import 'filtro_event.dart';
import 'filtro_state.dart';

class FiltroBloc extends Bloc<FiltroEvent, FiltroState> {
  FiltroBloc()
      : super(FiltroState(
          filtroData: FiltroData(tipo: TipoFiltroData.mesAtual),
        )) {
    on<AlterarFiltroData>(_onAlterarFiltroData);
    on<AlterarCategoriaFiltro>(_onAlterarCategoriaFiltro);
    on<LimparFiltros>(_onLimparFiltros);
  }

  void _onAlterarFiltroData(
    AlterarFiltroData event,
    Emitter<FiltroState> emit,
  ) {
    emit(state.copiarCom(filtroData: event.filtroData));
  }

  void _onAlterarCategoriaFiltro(
    AlterarCategoriaFiltro event,
    Emitter<FiltroState> emit,
  ) {
    emit(state.copiarCom(categoriaIdSelecionada: event.categoriaId));
  }

  void _onLimparFiltros(
    LimparFiltros event,
    Emitter<FiltroState> emit,
  ) {
    emit(FiltroState(
      filtroData: FiltroData(tipo: TipoFiltroData.mesAtual),
      categoriaIdSelecionada: null,
    ));
  }
}
