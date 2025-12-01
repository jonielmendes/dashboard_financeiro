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
import '../bloc/tema/tema_state.dart';
import '../widgets/cartao_resumo.dart';

class TelaDashboard extends StatefulWidget {
  const TelaDashboard({super.key});

  @override
  State<TelaDashboard> createState() => _TelaDashboardState();
}

class _TelaDashboardState extends State<TelaDashboard> {
  @override
  void initState() {
    super.initState();
    context.read<CategoriaBloc>().add(CarregarCategorias());
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA);
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF212121);
    
    return Scaffold(
      backgroundColor: bgColor,
      body: BlocListener<FiltroBloc, FiltroState>(
        listenWhen: (previous, current) =>
            previous.filtroData.tipo != current.filtroData.tipo ||
            previous.categoriaIdSelecionada != current.categoriaIdSelecionada,
        listener: (context, state) => _gerarRelatorio(),
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
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(state.mensagem, textAlign: TextAlign.center),
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
              return _construirDashboard(state.relatorio);
            }
            return const Center(child: Text('Carregando...'));
          },
        ),
      ),
    );
  }

  Widget _construirDashboard(dynamic relatorio) {
    final moeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white70 : Colors.grey[600];
    
    return SingleChildScrollView(
      child: Column(
        children: [
          // Logo e botão de tema no topo
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 40),
                Image.asset(
                  'assets/images/logo.png',
                  height: 50,
                  fit: BoxFit.contain,
                ),
                BlocBuilder<TemaBloc, TemaState>(
                  builder: (context, temaState) {
                    return IconButton(
                      icon: Icon(
                        temaState.isDark ? Icons.light_mode : Icons.dark_mode,
                        color: temaState.isDark ? const Color(0xFFFDD835) : Colors.black87,
                      ),
                      onPressed: () => context.read<TemaBloc>().add(AlternarTema()),
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CartaoResumo(
                        titulo: 'Receitas',
                        valor: moeda.format(relatorio.totalReceitas),
                        icone: Icons.arrow_upward,
                        cor: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CartaoResumo(
                        titulo: 'Despesas',
                        valor: moeda.format(relatorio.totalDespesas),
                        icone: Icons.arrow_downward,
                        cor: Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.05),
                        blurRadius: isDark ? 12 : 10,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.account_balance_wallet, color: const Color(0xFFFDD835), size: 28),
                          const SizedBox(width: 8),
                          Text(
                            'Saldo',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          moeda.format(relatorio.saldo),
                          style: TextStyle(
                            color: relatorio.saldo >= 0 ? const Color(0xFFFDD835) : Colors.orange,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _construirFiltros(),
          const SizedBox(height: 80), // Espaço para o BottomNavigationBar
        ],
      ),
    );
  }

  Widget _construirFiltros() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF212121);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filtros',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 12),
          BlocBuilder<FiltroBloc, FiltroState>(
            builder: (context, state) {
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: TipoFiltroData.values.map((tipo) {
                  final filtro = FiltroData(tipo: tipo);
                  return ChoiceChip(
                    label: Text(filtro.rotulo),
                    selected: state.filtroData.tipo == tipo,
                    onSelected: (sel) {
                      if (sel) context.read<FiltroBloc>().add(AlterarFiltroData(filtro));
                    },
                  );
                }).toList(),
              );
            },
          ),
          const SizedBox(height: 8),
          BlocBuilder<CategoriaBloc, CategoriaState>(
            builder: (context, categoriaState) {
              if (categoriaState is! CategoriaCarregada) return const SizedBox.shrink();
              return BlocBuilder<FiltroBloc, FiltroState>(
                builder: (context, filtroState) {
                  return DropdownButtonFormField<String?>(
                    decoration: const InputDecoration(
                      labelText: 'Categoria',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    value: filtroState.categoriaIdSelecionada,
                    items: [
                      const DropdownMenuItem(value: null, child: Text('Todas')),
                      ...categoriaState.categorias.where((cat) {
                        final c = cat as dynamic;
                        return c.tipo.toString() == 'TipoCategoria.despesa';
                      }).map((cat) {
                        final c = cat as dynamic;
                        return DropdownMenuItem<String>(
                          value: c.id as String,
                          child: Text('${c.icone} ${c.nome}'),
                        );
                      }),
                    ],
                    onChanged: (val) => context.read<FiltroBloc>().add(AlterarCategoriaFiltro(val)),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
