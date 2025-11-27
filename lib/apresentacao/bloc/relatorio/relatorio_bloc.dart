import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../dominio/entidades/relatorio_financeiro.dart';
import '../../../dominio/repositorios/repositorio_relatorio.dart';
import 'relatorio_event.dart';
import 'relatorio_state.dart';

/// BLoC responsável por gerenciar relatórios financeiros
/// Escuta mudanças nos filtros e recompila os dados
class RelatorioBloc extends Bloc<RelatorioEvent, RelatorioState> {
  final RepositorioRelatorio repositorio;
  RelatorioFinanceiro? _relatorioAtual;

  RelatorioBloc(this.repositorio) : super(RelatorioInicial()) {
    on<GerarRelatorio>(_onGerarRelatorio);
    on<ExportarRelatorioCSV>(_onExportarCSV);
    on<ExportarRelatorioPDF>(_onExportarPDF);
  }

  Future<void> _onGerarRelatorio(
    GerarRelatorio event,
    Emitter<RelatorioState> emit,
  ) async {
    emit(RelatorioCarregando());
    try {
      final relatorio = await repositorio.gerarRelatorio(
        dataInicio: event.dataInicio,
        dataFim: event.dataFim,
        categoriaId: event.categoriaId,
      );
      _relatorioAtual = relatorio;
      emit(RelatorioCarregado(relatorio));
    } catch (e) {
      emit(RelatorioErro('Erro ao gerar relatório: $e'));
    }
  }

  Future<void> _onExportarCSV(
    ExportarRelatorioCSV event,
    Emitter<RelatorioState> emit,
  ) async {
    if (_relatorioAtual == null) {
      emit(const RelatorioErro('Nenhum relatório disponível para exportar'));
      return;
    }

    emit(const RelatorioExportando('csv'));
    try {
      final caminho = await repositorio.exportarCSV(_relatorioAtual!);
      emit(RelatorioExportado(caminho: caminho, tipo: 'csv'));
      // Volta ao estado carregado
      emit(RelatorioCarregado(_relatorioAtual!));
    } catch (e) {
      emit(RelatorioErro('Erro ao exportar CSV: $e'));
    }
  }

  Future<void> _onExportarPDF(
    ExportarRelatorioPDF event,
    Emitter<RelatorioState> emit,
  ) async {
    if (_relatorioAtual == null) {
      emit(const RelatorioErro('Nenhum relatório disponível para exportar'));
      return;
    }

    emit(const RelatorioExportando('pdf'));
    try {
      final caminho = await repositorio.exportarPDF(_relatorioAtual!);
      emit(RelatorioExportado(caminho: caminho, tipo: 'pdf'));
      // Volta ao estado carregado
      emit(RelatorioCarregado(_relatorioAtual!));
    } catch (e) {
      emit(RelatorioErro('Erro ao exportar PDF: $e'));
    }
  }
}
