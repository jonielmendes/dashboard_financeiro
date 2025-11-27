import 'package:equatable/equatable.dart';

abstract class RelatorioEvent extends Equatable {
  const RelatorioEvent();

  @override
  List<Object?> get props => [];
}

/// Evento para gerar relatório com base nos filtros atuais
class GerarRelatorio extends RelatorioEvent {
  final DateTime dataInicio;
  final DateTime dataFim;
  final String? categoriaId;

  const GerarRelatorio({
    required this.dataInicio,
    required this.dataFim,
    this.categoriaId,
  });

  @override
  List<Object?> get props => [dataInicio, dataFim, categoriaId];
}

/// Evento para exportar relatório em CSV
class ExportarRelatorioCSV extends RelatorioEvent {}

/// Evento para exportar relatório em PDF
class ExportarRelatorioPDF extends RelatorioEvent {}
