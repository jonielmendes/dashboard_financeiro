import 'package:equatable/equatable.dart';
import '../../../dominio/entidades/relatorio_financeiro.dart';

abstract class RelatorioState extends Equatable {
  const RelatorioState();

  @override
  List<Object?> get props => [];
}

class RelatorioInicial extends RelatorioState {}

class RelatorioCarregando extends RelatorioState {}

class RelatorioCarregado extends RelatorioState {
  final RelatorioFinanceiro relatorio;

  const RelatorioCarregado(this.relatorio);

  @override
  List<Object?> get props => [relatorio];
}

class RelatorioExportando extends RelatorioState {
  final String tipo; // 'csv' ou 'pdf'

  const RelatorioExportando(this.tipo);

  @override
  List<Object?> get props => [tipo];
}

class RelatorioExportado extends RelatorioState {
  final String caminho;
  final String tipo;

  const RelatorioExportado({
    required this.caminho,
    required this.tipo,
  });

  @override
  List<Object?> get props => [caminho, tipo];
}

class RelatorioErro extends RelatorioState {
  final String mensagem;

  const RelatorioErro(this.mensagem);

  @override
  List<Object?> get props => [mensagem];
}
