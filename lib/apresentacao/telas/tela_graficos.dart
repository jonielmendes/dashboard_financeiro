import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/relatorio/relatorio_bloc.dart';
import '../bloc/relatorio/relatorio_state.dart';
import '../bloc/tema/tema_bloc.dart';
import '../bloc/tema/tema_event.dart';
import '../bloc/tema/tema_state.dart';
import '../widgets/grafico_linha_evolucao.dart';
import '../widgets/grafico_barras_despesas.dart';
import '../widgets/grafico_pizza_categorias.dart';

class TelaGraficos extends StatelessWidget {
  const TelaGraficos({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Image.asset('assets/images/logo.png', height: 50),
                  const Spacer(),
                  BlocBuilder<TemaBloc, TemaState>(
                    builder: (context, temaState) {
                      return IconButton(
                        icon: Icon(
                          temaState.isDark ? Icons.light_mode : Icons.dark_mode,
                          color: temaState.isDark
                              ? const Color(0xFFFDD835)
                              : Colors.black87,
                        ),
                        onPressed: () =>
                            context.read<TemaBloc>().add(AlternarTema()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<RelatorioBloc, RelatorioState>(
        builder: (context, state) {
          if (state is RelatorioCarregando) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is RelatorioErro) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(state.mensagem, textAlign: TextAlign.center),
                ],
              ),
            );
          }
          if (state is RelatorioCarregado) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Gráficos
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Evolução Temporal',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GraficoLinhaEvolucao(
                      transacoesDiarias: state.relatorio.transacoesDiarias,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Receitas e Despesas',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GraficoBarrasDespesas(
                      transacoesDiarias: state.relatorio.transacoesDiarias,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Despesas por Categoria',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GraficoPizzaCategorias(
                      despesasPorCategoria:
                          state.relatorio.despesasPorCategoria,
                    ),
                  ],
                ),
              ],
            );
          }
          return const Center(child: Text('Carregue os dados primeiro'));
        },
      ),
    );
  }
}
