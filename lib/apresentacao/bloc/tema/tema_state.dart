import 'package:flutter/material.dart';

/// Estados do BLoC de Tema
class TemaState {
  final ThemeMode modoTema;

  const TemaState({required this.modoTema});

  bool get isDark => modoTema == ThemeMode.dark;
}
