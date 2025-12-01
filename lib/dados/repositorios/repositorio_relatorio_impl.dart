import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;

import '../../dominio/entidades/relatorio_financeiro.dart';
import '../../dominio/repositorios/repositorio_relatorio.dart';
import '../../dominio/repositorios/repositorio_transacao.dart';

/// Implementação do Repository de Relatórios
/// Gera relatórios a partir dos dados de transações
class RepositorioRelatorioImpl implements RepositorioRelatorio {
  final RepositorioTransacao _repositorioTransacao;

  RepositorioRelatorioImpl(this._repositorioTransacao);

  @override
  Future<RelatorioFinanceiro> gerarRelatorio({
    required DateTime dataInicio,
    required DateTime dataFim,
    String? categoriaId,
  }) async {
    // Busca transações do período
    List<dynamic> transacoes;

    if (categoriaId != null) {
      transacoes = await _repositorioTransacao.buscarPorCategoria(categoriaId);
      // Filtra por data
      transacoes = transacoes.where((t) {
        final data = (t as dynamic).data as DateTime;
        return data.isAfter(dataInicio.subtract(const Duration(seconds: 1))) &&
            data.isBefore(dataFim.add(const Duration(seconds: 1)));
      }).toList();
    } else {
      transacoes = await _repositorioTransacao.buscarPorPeriodo(
        dataInicio: dataInicio,
        dataFim: dataFim,
      );
    }

    // Calcula totais
    double totalReceitas = 0;
    double totalDespesas = 0;
    Map<String, double> despesasPorCategoria = {};
    Map<String, double> receitasPorCategoria = {};

    for (final transacao in transacoes) {
      final t = transacao as dynamic;
      final valor = t.valor as double;
      final categoriaId = t.categoriaId as String;

      if (t.tipo.toString().contains('receita')) {
        totalReceitas += valor;
        receitasPorCategoria[categoriaId] =
            (receitasPorCategoria[categoriaId] ?? 0) + valor;
      } else {
        totalDespesas += valor;
        despesasPorCategoria[categoriaId] =
            (despesasPorCategoria[categoriaId] ?? 0) + valor;
      }
    }

    // Agrupa por dia
    Map<String, TransacaoDiaria> transacoesPorDia = {};

    for (final transacao in transacoes) {
      final t = transacao as dynamic;
      final data = t.data as DateTime;
      final dataKey = DateFormat('yyyy-MM-dd').format(data);
      final valor = t.valor as double;

      if (!transacoesPorDia.containsKey(dataKey)) {
        transacoesPorDia[dataKey] = TransacaoDiaria(
          data: DateTime(data.year, data.month, data.day),
          receita: 0,
          despesa: 0,
        );
      }

      final atual = transacoesPorDia[dataKey]!;

      if (t.tipo.toString().contains('receita')) {
        transacoesPorDia[dataKey] = TransacaoDiaria(
          data: atual.data,
          receita: atual.receita + valor,
          despesa: atual.despesa,
        );
      } else {
        transacoesPorDia[dataKey] = TransacaoDiaria(
          data: atual.data,
          receita: atual.receita,
          despesa: atual.despesa + valor,
        );
      }
    }

    final transacoesDiarias = transacoesPorDia.values.toList()
      ..sort((a, b) => a.data.compareTo(b.data));

    return RelatorioFinanceiro(
      totalReceitas: totalReceitas,
      totalDespesas: totalDespesas,
      saldo: totalReceitas - totalDespesas,
      despesasPorCategoria: despesasPorCategoria,
      receitasPorCategoria: receitasPorCategoria,
      transacoesDiarias: transacoesDiarias,
      dataInicio: dataInicio,
      dataFim: dataFim,
    );
  }

  @override
  Future<String> exportarCSV(RelatorioFinanceiro relatorio) async {
    final formatador = DateFormat('dd/MM/yyyy');

    List<List<dynamic>> linhas = [
      ['Data', 'Receitas', 'Despesas', 'Saldo'],
    ];

    for (final transacao in relatorio.transacoesDiarias) {
      linhas.add([
        formatador.format(transacao.data),
        'R\$ ${transacao.receita.toStringAsFixed(2)}',
        'R\$ ${transacao.despesa.toStringAsFixed(2)}',
        'R\$ ${transacao.saldo.toStringAsFixed(2)}',
      ]);
    }

    linhas.add(['']);
    linhas.add(['Resumo']);
    linhas.add([
      'Total de Receitas',
      'R\$ ${relatorio.totalReceitas.toStringAsFixed(2)}',
    ]);
    linhas.add([
      'Total de Despesas',
      'R\$ ${relatorio.totalDespesas.toStringAsFixed(2)}',
    ]);
    linhas.add(['Saldo', 'R\$ ${relatorio.saldo.toStringAsFixed(2)}']);

    String csv = const ListToCsvConverter().convert(linhas);

    // Salva o arquivo
    final diretorio = await getApplicationDocumentsDirectory();
    final arquivo = File(
      '${diretorio.path}/relatorio_${DateTime.now().millisecondsSinceEpoch}.csv',
    );
    await arquivo.writeAsString(csv);

    return arquivo.path;
  }

  @override
  Future<String> exportarPDF(RelatorioFinanceiro relatorio) async {
    final pdf = pw.Document();
    final formatador = DateFormat('dd/MM/yyyy');

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Relatório Financeiro',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'Período: ${formatador.format(relatorio.dataInicio)} - ${formatador.format(relatorio.dataFim)}',
                style: const pw.TextStyle(fontSize: 14),
              ),
              pw.SizedBox(height: 20),

              // Resumo
              pw.Text(
                'Resumo',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'Total de Receitas: R\$ ${relatorio.totalReceitas.toStringAsFixed(2)}',
              ),
              pw.Text(
                'Total de Despesas: R\$ ${relatorio.totalDespesas.toStringAsFixed(2)}',
              ),
              pw.Text('Saldo: R\$ ${relatorio.saldo.toStringAsFixed(2)}'),
              pw.SizedBox(height: 20),

              // Tabela de transações diárias
              pw.Text(
                'Transações Diárias',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Table.fromTextArray(
                headers: ['Data', 'Receitas', 'Despesas', 'Saldo'],
                data: relatorio.transacoesDiarias
                    .map(
                      (t) => [
                        formatador.format(t.data),
                        'R\$ ${t.receita.toStringAsFixed(2)}',
                        'R\$ ${t.despesa.toStringAsFixed(2)}',
                        'R\$ ${t.saldo.toStringAsFixed(2)}',
                      ],
                    )
                    .toList(),
              ),
            ],
          );
        },
      ),
    );

    // Salva o arquivo
    final diretorio = await getApplicationDocumentsDirectory();
    final arquivo = File(
      '${diretorio.path}/relatorio_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
    await arquivo.writeAsBytes(await pdf.save());

    return arquivo.path;
  }
}
