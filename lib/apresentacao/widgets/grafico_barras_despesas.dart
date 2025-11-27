import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../dominio/entidades/relatorio_financeiro.dart';

/// Widget de Gráfico de Barras para visualizar Receitas e Despesas Diárias
/// Utiliza fl_chart para renderização
class GraficoBarrasDespesas extends StatelessWidget {
  final List<TransacaoDiaria> transacoesDiarias;

  const GraficoBarrasDespesas({super.key, required this.transacoesDiarias});

  @override
  Widget build(BuildContext context) {
    if (transacoesDiarias.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Center(
            child: Text('Nenhum dado disponível para o período selecionado'),
          ),
        ),
      );
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _calcularMaxY(),
                  minY: 0,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.black87,
                      tooltipPadding: const EdgeInsets.all(8),
                      tooltipMargin: 8,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final transacao = transacoesDiarias[group.x.toInt()];
                        final formatador = DateFormat('dd/MM');
                        final formatadorMoeda = NumberFormat.currency(
                          locale: 'pt_BR',
                          symbol: 'R\$',
                        );

                        String tipo = rodIndex == 0 ? 'Receita' : 'Despesa';
                        double valor = rodIndex == 0
                            ? transacao.receita
                            : transacao.despesa;

                        return BarTooltipItem(
                          '${formatador.format(transacao.data)}\n',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          children: [
                            TextSpan(
                              text: '$tipo: ${formatadorMoeda.format(valor)}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= transacoesDiarias.length) {
                            return const Text('');
                          }

                          // Mostra apenas algumas datas para não sobrepor
                          final totalDias = transacoesDiarias.length;
                          final intervalo = totalDias > 15
                              ? 3
                              : (totalDias > 7 ? 2 : 1);

                          if (value.toInt() % intervalo != 0) {
                            return const Text('');
                          }

                          final transacao = transacoesDiarias[value.toInt()];
                          final formatador = DateFormat('dd/MM');
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Transform.rotate(
                              angle: -0.5, // Rotaciona 45 graus
                              child: Text(
                                formatador.format(transacao.data),
                                style: const TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                        reservedSize: 40,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            'R\$${value.toInt()}',
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                        reservedSize: 50,
                      ),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: _calcularMaxY() / 5,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.withOpacity(0.2),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: _criarGruposBarras(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Legenda
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _construirItemLegenda('Receitas', Colors.green),
                const SizedBox(width: 24),
                _construirItemLegenda('Despesas', Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _criarGruposBarras() {
    return List.generate(transacoesDiarias.length, (index) {
      final transacao = transacoesDiarias[index];
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: transacao.receita,
            color: Colors.green,
            width: 12,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
          ),
          BarChartRodData(
            toY: transacao.despesa,
            color: Colors.red,
            width: 12,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
          ),
        ],
      );
    });
  }

  double _calcularMaxY() {
    double max = 0;
    for (final transacao in transacoesDiarias) {
      if (transacao.receita > max) max = transacao.receita;
      if (transacao.despesa > max) max = transacao.despesa;
    }
    return (max * 1.2).ceilToDouble();
  }

  Widget _construirItemLegenda(String label, Color cor) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: cor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
