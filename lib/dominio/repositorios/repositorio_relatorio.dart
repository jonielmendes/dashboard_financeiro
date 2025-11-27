import '../entidades/relatorio_financeiro.dart';

/// Interface do Repository de Relatórios
/// Define o contrato para geração de relatórios financeiros
abstract class RepositorioRelatorio {
  /// Gera um relatório financeiro para o período especificado
  Future<RelatorioFinanceiro> gerarRelatorio({
    required DateTime dataInicio,
    required DateTime dataFim,
    String? categoriaId,
  });

  /// Exporta o relatório em formato CSV
  Future<String> exportarCSV(RelatorioFinanceiro relatorio);

  /// Exporta o relatório em formato PDF
  Future<String> exportarPDF(RelatorioFinanceiro relatorio);
}
