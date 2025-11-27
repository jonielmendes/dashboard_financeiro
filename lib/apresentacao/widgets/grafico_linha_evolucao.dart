import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../dominio/entidades/relatorio_financeiro.dart';

/// Widget de Gráfico de Linha para evolução de Receitas e Despesas
class GraficoLinhaEvolucao extends StatelessWidget {
  final List<TransacaoDiaria> transacoesDiarias;

  const GraficoLinhaEvolucao({
    super.key,
    required this.transacoesDiarias,
  });

  @override
  Widget build(BuildContext context) {
    if (transacoesDiarias.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Center(
            child: Text('Nenhum dado disponível'),
          ),
        ),
      );
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Evolução Receitas vs. Despesas',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
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
                          
                          // Mostra apenas algumas datas
                          final totalDias = transacoesDiarias.length;
                          final intervalo = totalDias > 15 ? 5 : (totalDias > 7 ? 3 : 2);
                          
                          if (value.toInt() % intervalo != 0) {
                            return const Text('');
                          }
                          
                          final transacao = transacoesDiarias[value.toInt()];
                          final formatador = DateFormat('dd/MM');
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              formatador.format(transacao.data),
                              style: const TextStyle(fontSize: 9),
                            ),
                          );
                        },
                        reservedSize: 32,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            'R\$${(value / 1000).toStringAsFixed(0)}k',
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                        reservedSize: 45,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: (transacoesDiarias.length - 1).toDouble(),
                  minY: 0,
                  maxY: _calcularMaxY(),
                  lineBarsData: [
                    // Linha de Receitas
                    LineChartBarData(
                      spots: _criarPontosReceitas(),
                      isCurved: true,
                      color: Colors.green,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.green.withOpacity(0.1),
                      ),
                    ),
                    // Linha de Despesas
                    LineChartBarData(
                      spots: _criarPontosDespesas(),
                      isCurved: true,
                      color: Colors.red,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.red.withOpacity(0.1),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      tooltipBgColor: Colors.black87,
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          final formatadorMoeda =
                              NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
                          final tipo = spot.barIndex == 0 ? 'Receita' : 'Despesa';
                          return LineTooltipItem(
                            '$tipo\n${formatadorMoeda.format(spot.y)}',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Legenda
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _construirItemLegenda('Receita', Colors.green),
                const SizedBox(width: 24),
                _construirItemLegenda('Despesas', Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _criarPontosReceitas() {
    return transacoesDiarias.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.receita);
    }).toList();
  }

  List<FlSpot> _criarPontosDespesas() {
    return transacoesDiarias.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.despesa);
    }).toList();
  }

  double _calcularMaxY() {
    double max = 0;
    for (var transacao in transacoesDiarias) {
      if (transacao.receita > max) max = transacao.receita;
      if (transacao.despesa > max) max = transacao.despesa;
    }
    return max * 1.2; // 20% de margem
  }

  Widget _construirItemLegenda(String titulo, Color cor) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 3,
          decoration: BoxDecoration(
            color: cor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
