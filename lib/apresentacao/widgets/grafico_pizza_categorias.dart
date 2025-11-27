import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/categoria/categoria_bloc.dart';
import '../bloc/categoria/categoria_state.dart';

/// Widget de Gráfico de Pizza para visualizar Despesas por Categoria
/// Utiliza fl_chart para renderização
class GraficoPizzaCategorias extends StatefulWidget {
  final Map<String, double> despesasPorCategoria;

  const GraficoPizzaCategorias({
    super.key,
    required this.despesasPorCategoria,
  });

  @override
  State<GraficoPizzaCategorias> createState() => _GraficoPizzaCategoriasState();
}

class _GraficoPizzaCategoriasState extends State<GraficoPizzaCategorias> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.despesasPorCategoria.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Center(
            child: Text('Nenhuma despesa registrada no período'),
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
        child: BlocBuilder<CategoriaBloc, CategoriaState>(
          builder: (context, state) {
            if (state is! CategoriaCarregada) {
              return const Center(child: CircularProgressIndicator());
            }

            final categorias = state.categorias;
            final formatadorMoeda =
                NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

            // Calcula o total
            final total = widget.despesasPorCategoria.values
                .fold<double>(0, (sum, valor) => sum + valor);

            return Column(
              children: [
                SizedBox(
                  height: 250,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 2,
                      centerSpaceRadius: 60,
                      sections: _criarSecoesPizza(categorias, total),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Legenda com valores
                Wrap(
                  spacing: 16,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: widget.despesasPorCategoria.entries.map((entry) {
                    // Busca a categoria
                    dynamic categoriaEncontrada;
                    for (var cat in categorias) {
                      try {
                        if ((cat as dynamic).id == entry.key) {
                          categoriaEncontrada = cat;
                          break;
                        }
                      } catch (e) {
                        continue;
                      }
                    }
                    
                    // Se não encontrou, usa a primeira
                    if (categoriaEncontrada == null && categorias.isNotEmpty) {
                      categoriaEncontrada = categorias.first;
                    }
                    
                    // Se ainda é nulo, pula
                    if (categoriaEncontrada == null) {
                      return const SizedBox.shrink();
                    }

                    final porcentagem = (entry.value / total * 100).toStringAsFixed(1);

                    return SizedBox(
                      width: 140,
                      child: Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: (categoriaEncontrada as dynamic).cor as Color? ?? Colors.grey,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${(categoriaEncontrada as dynamic).icone ?? ''} ${(categoriaEncontrada as dynamic).nome ?? 'Sem nome'}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '${formatadorMoeda.format(entry.value)} ($porcentagem%)',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<PieChartSectionData> _criarSecoesPizza(
    List<dynamic> categorias,
    double total,
  ) {
    final List<PieChartSectionData> secoes = [];
    int index = 0;

    for (var entry in widget.despesasPorCategoria.entries) {
      // Busca a categoria correspondente
      dynamic categoria;
      
      for (var cat in categorias) {
        try {
          if ((cat as dynamic).id == entry.key) {
            categoria = cat;
            break;
          }
        } catch (e) {
          continue;
        }
      }

      // Se não encontrou, pula esta entrada
      if (categoria == null) {
        continue;
      }

      final isTouched = index == touchedIndex;
      final radius = isTouched ? 110.0 : 100.0;
      final fontSize = isTouched ? 16.0 : 12.0;
      final porcentagem = (entry.value / total * 100).toStringAsFixed(1);

      Color cor = Colors.grey;
      try {
        cor = (categoria as dynamic).cor as Color;
      } catch (e) {
        cor = Colors.blue; // Cor padrão se falhar
      }

      secoes.add(
        PieChartSectionData(
          color: cor,
          value: entry.value,
          title: '$porcentagem%',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );

      index++;
    }

    return secoes;
  }
}
