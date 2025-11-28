import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../dominio/entidades/filtro_data.dart';
import '../bloc/relatorio/relatorio_bloc.dart';
import '../bloc/relatorio/relatorio_event.dart';
import '../bloc/relatorio/relatorio_state.dart';
import '../bloc/filtro/filtro_bloc.dart';
import '../bloc/filtro/filtro_state.dart';
import '../bloc/filtro/filtro_event.dart';
import '../bloc/categoria/categoria_bloc.dart';
import '../bloc/categoria/categoria_state.dart';
import '../bloc/categoria/categoria_event.dart';
import '../bloc/tema/tema_bloc.dart';
import '../bloc/tema/tema_event.dart';
import 'tela_adicionar_transacao.dart';
import '../bloc/tema/tema_state.dart';
import '../widgets/cartao_resumo.dart';
import '../widgets/grafico_barras_despesas.dart';
import '../widgets/grafico_pizza_categorias.dart';
import '../widgets/grafico_linha_evolucao.dart';

/// Tela principal do Dashboard Financeiro
/// Exibe gráficos, resumos e permite filtrar por data e categoria
class TelaDashboard extends StatefulWidget {
  const TelaDashboard({super.key});

  @override
  State<TelaDashboard> createState() => _TelaDashboardState();
}

class _TelaDashboardState extends State<TelaDashboard> {
  @override
  void initState() {
    super.initState();
    // Carrega categorias
    context.read<CategoriaBloc>().add(CarregarCategorias());
    // Gera relatório inicial
    _gerarRelatorio();
  }

  void _gerarRelatorio() {
    final filtroState = context.read<FiltroBloc>().state;
    context.read<RelatorioBloc>().add(
      GerarRelatorio(
        dataInicio: filtroState.filtroData.dataInicio,
        dataFim: filtroState.filtroData.dataFim,
        categoriaId: filtroState.categoriaIdSelecionada,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard Financeiro',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Gestão Inteligente de Finanças',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF4CAF50), // Verde
                Color(0xFF2196F3), // Azul
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        actions: [
          // Botão de alternar tema
          BlocBuilder<TemaBloc, TemaState>(
            builder: (context, temaState) {
              return IconButton(
                icon: Icon(
                  temaState.isDark ? Icons.light_mode : Icons.dark_mode,
                ),
                onPressed: () {
                  context.read<TemaBloc>().add(AlternarTema());
                },
                tooltip: temaState.isDark ? 'Modo Claro' : 'Modo Escuro',
              );
            },
          ),
          // Botão de exportar
          PopupMenuButton<String>(
            icon: const Icon(Icons.download),
            onSelected: (value) {
              if (value == 'csv') {
                context.read<RelatorioBloc>().add(ExportarRelatorioCSV());
              } else if (value == 'pdf') {
                context.read<RelatorioBloc>().add(ExportarRelatorioPDF());
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'csv',
                child: Row(
                  children: [
                    Icon(Icons.table_chart),
                    SizedBox(width: 8),
                    Text('Exportar CSV'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'pdf',
                child: Row(
                  children: [
                    Icon(Icons.picture_as_pdf),
                    SizedBox(width: 8),
                    Text('Exportar PDF'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: BlocListener<FiltroBloc, FiltroState>(
        listenWhen: (previous, current) {
          return previous.filtroData.tipo != current.filtroData.tipo ||
                 previous.categoriaIdSelecionada != current.categoriaIdSelecionada;
        },
        listener: (context, state) {
          _gerarRelatorio();
        },
        child: BlocListener<RelatorioBloc, RelatorioState>(
          listener: (context, state) {
            if (state is RelatorioExportado) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Relatório ${state.tipo.toUpperCase()} exportado com sucesso!',
                  ),
                  action: SnackBarAction(
                    label: 'Ver',
                    onPressed: () {
                      // Aqui você pode abrir o arquivo
                      print('Arquivo: ${state.caminho}');
                    },
                  ),
                ),
              );
            } else if (state is RelatorioErro) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.mensagem),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: Column(
            children: [
              // Filtros
              _construirSecaoFiltros(),
              // Conteúdo do Dashboard
              Expanded(
                child: BlocBuilder<RelatorioBloc, RelatorioState>(
                  builder: (context, state) {
                    if (state is RelatorioCarregando) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is RelatorioErro) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              state.mensagem,
                              style: const TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: _gerarRelatorio,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Tentar Novamente'),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is RelatorioCarregado) {
                      return _construirConteudoDashboard(state.relatorio);
                    }

                    return const Center(
                      child: Text(
                        'Selecione um período para visualizar os dados',
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TelaAdicionarTransacao(),
            ),
          ).then((_) => _gerarRelatorio()); // Atualiza ao voltar
        },
        icon: const Icon(Icons.add),
        label: const Text('Nova Transação'),
      ),
    );
  }

  Widget _construirSecaoFiltros() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filtros',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          BlocBuilder<FiltroBloc, FiltroState>(
            builder: (context, state) {
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  // Filtros de data
                  ...TipoFiltroData.values.map((tipo) {
                    final filtro = FiltroData(tipo: tipo);
                    final selecionado = state.filtroData.tipo == tipo;
                    return ChoiceChip(
                      label: Text(filtro.rotulo),
                      selected: selecionado,
                      onSelected: (selected) {
                        if (selected) {
                          context.read<FiltroBloc>().add(
                            AlterarFiltroData(filtro),
                          );
                        }
                      },
                    );
                  }),
                ],
              );
            },
          ),
          const SizedBox(height: 8),
          // Filtro de categoria
          BlocBuilder<CategoriaBloc, CategoriaState>(
            builder: (context, categoriaState) {
              if (categoriaState is CategoriaCarregada) {
                return BlocBuilder<FiltroBloc, FiltroState>(
                  builder: (context, filtroState) {
                    return DropdownButtonFormField<String?>(
                      key: ValueKey(filtroState.categoriaIdSelecionada),
                      decoration: const InputDecoration(
                        labelText: 'Filtrar por categoria',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      value: filtroState.categoriaIdSelecionada,
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('Todas as categorias'),
                        ),
                        ...categoriaState.categorias
                            .where((categoria) {
                              // Mostra apenas categorias de DESPESA
                              final cat = categoria as dynamic;
                              return cat.tipo.toString() == 'TipoCategoria.despesa';
                            })
                            .map((categoria) {
                              return DropdownMenuItem(
                                value: (categoria as dynamic).id,
                                child: Row(
                                  children: [
                                    Text((categoria as dynamic).icone),
                                    const SizedBox(width: 8),
                                    Text((categoria as dynamic).nome),
                                  ],
                                ),
                              );
                            }),
                      ],
                      onChanged: (value) {
                        context.read<FiltroBloc>().add(
                          AlterarCategoriaFiltro(value),
                        );
                      },
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _construirConteudoDashboard(dynamic relatorio) {
    final formatadorMoeda = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cards de Resumo
          Row(
            children: [
              Expanded(
                child: CartaoResumo(
                  titulo: 'Receitas',
                  valor: formatadorMoeda.format(relatorio.totalReceitas),
                  icone: Icons.arrow_upward,
                  cor: Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CartaoResumo(
                  titulo: 'Despesas',
                  valor: formatadorMoeda.format(relatorio.totalDespesas),
                  icone: Icons.arrow_downward,
                  cor: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          CartaoResumo(
            titulo: 'Saldo',
            valor: formatadorMoeda.format(relatorio.saldo),
            icone: Icons.account_balance_wallet,
            cor: relatorio.saldo >= 0 ? Colors.blue : Colors.orange,
          ),
          const SizedBox(height: 24),

          // Gráfico de Linha - Evolução
          GraficoLinhaEvolucao(transacoesDiarias: relatorio.transacoesDiarias),
          const SizedBox(height: 24),

          // Gráfico de Barras - Despesas Diárias
          const Text(
            'Receitas e Despesas Diárias',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          GraficoBarrasDespesas(transacoesDiarias: relatorio.transacoesDiarias),
          const SizedBox(height: 24),

          // Gráfico de Pizza - Despesas por Categoria
          const Text(
            'Despesas por Categoria',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          GraficoPizzaCategorias(
            despesasPorCategoria: relatorio.despesasPorCategoria,
          ),
        ],
      ),
    );
  }
}
