import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/relatorio/relatorio_bloc.dart';
import '../bloc/relatorio/relatorio_state.dart';

class TelaRelatorios extends StatelessWidget {
  const TelaRelatorios({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA);
    final moeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    
    return Scaffold(
      backgroundColor: bgColor,
      body: BlocBuilder<RelatorioBloc, RelatorioState>(
        builder: (context, state) {
          if (state is RelatorioCarregando) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is RelatorioCarregado) {
            final relatorio = state.relatorio;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Logo no topo
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 50,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Resumo do Período',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildCard(
                  context,
                  'Total de Receitas',
                  moeda.format(relatorio.totalReceitas),
                  Colors.green,
                  Icons.arrow_upward,
                ),
                const SizedBox(height: 12),
                _buildCard(
                  context,
                  'Total de Despesas',
                  moeda.format(relatorio.totalDespesas),
                  Colors.red,
                  Icons.arrow_downward,
                ),
                const SizedBox(height: 12),
                _buildCard(
                  context,
                  'Saldo',
                  moeda.format(relatorio.saldo),
                  relatorio.saldo >= 0 ? const Color(0xFFFDD835) : Colors.orange,
                  Icons.account_balance_wallet,
                ),
              ],
            );
          }
          
          return const Center(child: Text('Carregue os dados primeiro'));
        },
      ),
    );
  }

  Widget _buildCard(BuildContext context, String titulo, String valor, Color cor, IconData icone) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: cor.withOpacity(0.2),
            child: Icon(icone, color: cor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  valor,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: cor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
