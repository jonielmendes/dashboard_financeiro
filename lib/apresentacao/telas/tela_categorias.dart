import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/categoria/categoria_bloc.dart';
import '../bloc/categoria/categoria_state.dart';
import '../bloc/categoria/categoria_event.dart';
import '../../../dominio/entidades/categoria.dart';

class TelaCategorias extends StatefulWidget {
  const TelaCategorias({super.key});

  @override
  State<TelaCategorias> createState() => _TelaCategoriasState();
}

class _TelaCategoriasState extends State<TelaCategorias> {
  @override
  void initState() {
    super.initState();
    context.read<CategoriaBloc>().add(CarregarCategorias());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA);
    
    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          // Logo no topo
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Image.asset(
                'assets/images/logo.png',
                height: 50,
                fit: BoxFit.contain,
              ),
            ),
          ),
          // Conteúdo
          Expanded(
            child: BlocBuilder<CategoriaBloc, CategoriaState>(
              builder: (context, state) {
                if (state is CategoriaCarregando) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is CategoriaErro) {
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
                if (state is CategoriaCarregada) {
                  final categorias = state.categorias;
                  if (categorias.isEmpty) {
                    return const Center(child: Text('Nenhuma categoria cadastrada'));
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: categorias.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final isDark = Theme.of(context).brightness == Brightness.dark;
                final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
                final textColor = isDark ? Colors.white : const Color(0xFF212121);
                final subtitleColor = isDark ? Colors.white70 : Colors.grey[600]!;
                
                final categoria = categorias[index] as dynamic;
                final isReceita = categoria.tipo.toString() == 'TipoCategoria.receita';
                return Card(
                  color: cardColor,
                  elevation: isDark ? 2 : 0.5,
                  margin: const EdgeInsets.only(bottom: 8),
                  shadowColor: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.05),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isReceita ? Colors.green.shade100 : Colors.red.shade100,
                      child: Text(
                        categoria.icone,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                    title: Text(
                      categoria.nome,
                      style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                    ),
                    subtitle: Text(isReceita ? 'Receita' : 'Despesa', style: TextStyle(color: subtitleColor)),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: subtitleColor,
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Editar ${categoria.nome}')),
                      );
                    },
                  ),
                );
              },
            );
                }
                return const Center(child: Text('Carregando...'));
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _mostrarDialogoNovaCategoria(context),
        icon: const Icon(Icons.add),
        label: const Text('Nova Categoria'),
      ),
    );
  }

  void _mostrarDialogoNovaCategoria(BuildContext context) {
    final nomeController = TextEditingController();
    TipoCategoria tipoSelecionado = TipoCategoria.despesa;
    String iconeSelecionado = '🛒';

    final icones = [
      '🛒', '🍔', '🚗', '🏠', '💊', '🎮', '📚', '✈️', '👕', '🎬',
      '💰', '💼', '🎁', '📱', '⚡', '💳', '🏋️', '🍕', '☕', '🎵'
    ];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('Nova Categoria'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                SegmentedButton<TipoCategoria>(
                  segments: const [
                    ButtonSegment(
                      value: TipoCategoria.receita,
                      label: Text('Receita'),
                      icon: Icon(Icons.arrow_upward),
                    ),
                    ButtonSegment(
                      value: TipoCategoria.despesa,
                      label: Text('Despesa'),
                      icon: Icon(Icons.arrow_downward),
                    ),
                  ],
                  selected: {tipoSelecionado},
                  onSelectionChanged: (Set<TipoCategoria> selected) {
                    setState(() => tipoSelecionado = selected.first);
                  },
                ),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Escolha um ícone:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: icones.map((icone) {
                    return GestureDetector(
                      onTap: () => setState(() => iconeSelecionado = icone),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: iconeSelecionado == icone
                              ? (tipoSelecionado == TipoCategoria.receita
                                      ? Colors.green
                                      : Colors.red)
                                  .withOpacity(0.2)
                              : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: iconeSelecionado == icone
                                ? (tipoSelecionado == TipoCategoria.receita
                                    ? Colors.green
                                    : Colors.red)
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Text(icone, style: const TextStyle(fontSize: 24)),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nomeController.text.trim().isNotEmpty) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Categoria "${nomeController.text}" criada!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: const Text('Criar'),
            ),
          ],
        ),
      ),
    );
  }
}
