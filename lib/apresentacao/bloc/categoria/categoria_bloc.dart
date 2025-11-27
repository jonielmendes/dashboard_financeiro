import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../dominio/repositorios/repositorio_categoria.dart';
import 'categoria_event.dart';
import 'categoria_state.dart';

class CategoriaBloc extends Bloc<CategoriaEvent, CategoriaState> {
  final RepositorioCategoria repositorio;

  CategoriaBloc(this.repositorio) : super(CategoriaInicial()) {
    on<CarregarCategorias>(_onCarregarCategorias);
    on<CarregarCategoriasPorTipo>(_onCarregarCategoriasPorTipo);
  }

  Future<void> _onCarregarCategorias(
    CarregarCategorias event,
    Emitter<CategoriaState> emit,
  ) async {
    emit(CategoriaCarregando());
    try {
      final categorias = await repositorio.buscarTodas();
      emit(CategoriaCarregada(categorias));
    } catch (e) {
      emit(CategoriaErro('Erro ao carregar categorias: $e'));
    }
  }

  Future<void> _onCarregarCategoriasPorTipo(
    CarregarCategoriasPorTipo event,
    Emitter<CategoriaState> emit,
  ) async {
    emit(CategoriaCarregando());
    try {
      final categorias = await repositorio.buscarPorTipo(event.tipo);
      emit(CategoriaCarregada(categorias));
    } catch (e) {
      emit(CategoriaErro('Erro ao carregar categorias por tipo: $e'));
    }
  }
}
