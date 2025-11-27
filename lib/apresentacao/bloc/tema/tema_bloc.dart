import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'tema_event.dart';
import 'tema_state.dart';

/// BLoC para gerenciar o tema do aplicativo (claro/escuro)
class TemaBloc extends Bloc<TemaEvent, TemaState> {
  TemaBloc() : super(const TemaState(modoTema: ThemeMode.light)) {
    on<AlternarTema>(_onAlternarTema);
  }

  void _onAlternarTema(AlternarTema event, Emitter<TemaState> emit) {
    final novoModo = state.isDark ? ThemeMode.light : ThemeMode.dark;
    emit(TemaState(modoTema: novoModo));
  }
}
