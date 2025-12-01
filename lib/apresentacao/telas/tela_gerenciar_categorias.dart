import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/categoria/categoria_bloc.dart';
import '../bloc/categoria/categoria_event.dart';
import '../bloc/categoria/categoria_state.dart';
import '../../dominio/entidades/categoria.dart';

class TelaGerenciarCategorias extends StatefulWidget {
  const TelaGerenciarCategorias({super.key});

  @override
  State<TelaGerenciarCategorias> createState() => _TelaGerenciarCategoriasState();
}

class _TelaGerenciarCategoriasState extends State<TelaGerenciarCategorias> {
  @override
  void initState() {
    super.initState();
    context.read<CategoriaBloc>().add(CarregarCategorias());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA);
    final textColor = isDark ? const Color(0xFFFDD835) : const Color(0xFF212121);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Gerenciar Categorias'),
        backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
        foregroundColor: textColor,
        elevation: 0,
      ),
      body: BlocConsumer<CategoriaBloc, CategoriaState>(
        listener: (context, state) {
          if (state is CategoriaErro) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.mensagem),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
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

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: categorias.length + 1, // +1 para o botão de adicionar
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Botão de adicionar nova categoria
                  return Card(
                    color: const Color(0xFFFDD835),
                    child: ListTile(
                      leading: const Icon(Icons.add, color: Colors.black87),
                      title: const Text(
                        'Adicionar Nova Categoria',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      onTap: () => _mostrarDialogAdicionarCategoria(context),
                    ),
                  );
                }

                final categoria = categorias[index - 1];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: categoria.cor,
                      child: Icon(
                        _getIconData(categoria.icone),
                        color: Colors.white,
                      ),
                    ),
                    title: Text(categoria.nome),
                    subtitle: Text(categoria.tipo == TipoCategoria.receita ? 'Receita' : 'Despesa'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmarExclusao(context, categoria),
                    ),
                  ),
                );
              },
            );
          }

          return const Center(child: Text('Carregue as categorias'));
        },
      ),
    );
  }

  void _mostrarDialogAdicionarCategoria(BuildContext context) {
    final nomeController = TextEditingController();
    IconData iconeSelecionado = Icons.category;
    Color corSelecionada = Colors.blue;
    TipoCategoria tipoSelecionado = TipoCategoria.despesa;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Nova Categoria'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nomeController,
                      decoration: const InputDecoration(
                        labelText: 'Nome da Categoria',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Tipo:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<TipoCategoria>(
                            title: const Text('Receita'),
                            value: TipoCategoria.receita,
                            groupValue: tipoSelecionado,
                            onChanged: (value) {
                              setState(() => tipoSelecionado = value!);
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<TipoCategoria>(
                            title: const Text('Despesa'),
                            value: TipoCategoria.despesa,
                            groupValue: tipoSelecionado,
                            onChanged: (value) {
                              setState(() => tipoSelecionado = value!);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('Escolha um ícone:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _iconesDisponiveis.map((icone) {
                        final selecionado = icone == iconeSelecionado;
                        return GestureDetector(
                          onTap: () {
                            setState(() => iconeSelecionado = icone);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: selecionado ? const Color(0xFFFDD835) : Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: selecionado ? const Color(0xFFFDD835) : Colors.grey,
                                width: 2,
                              ),
                            ),
                            child: Icon(icone, color: selecionado ? Colors.black87 : Colors.grey[700]),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    const Text('Escolha uma cor:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _coresDisponiveis.map((cor) {
                        final selecionado = cor == corSelecionada;
                        return GestureDetector(
                          onTap: () {
                            setState(() => corSelecionada = cor);
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: cor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: selecionado ? Colors.black : Colors.grey,
                                width: selecionado ? 3 : 1,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFDD835),
                    foregroundColor: Colors.black87,
                  ),
                  onPressed: () {
                    if (nomeController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Digite um nome para a categoria')),
                      );
                      return;
                    }

                    try {
                      // Converter cor para hex
                      String corHex = corSelecionada.value.toRadixString(16).padLeft(8, '0');
                      // Remover canal alpha se for FF (opaco) e adicionar #
                      if (corHex.startsWith('ff')) {
                        corHex = '#${corHex.substring(2).toUpperCase()}';
                      } else {
                        corHex = '#$corHex';
                      }

                      final novaCategoria = Categoria(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        nome: nomeController.text.trim(),
                        icone: _getIconName(iconeSelecionado),
                        corHex: corHex,
                        tipo: tipoSelecionado,
                      );

                      context.read<CategoriaBloc>().add(AdicionarCategoria(novaCategoria));
                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Categoria "${novaCategoria.nome}" adicionada!')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erro ao adicionar categoria: $e'), backgroundColor: Colors.red),
                      );
                    }
                  },
                  child: const Text('Adicionar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmarExclusao(BuildContext context, Categoria categoria) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Excluir Categoria'),
          content: Text('Deseja realmente excluir a categoria "${categoria.nome}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                context.read<CategoriaBloc>().add(ExcluirCategoria(categoria.id));
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Categoria "${categoria.nome}" excluída!')),
                );
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  // Lista de ícones disponíveis
  static final List<IconData> _iconesDisponiveis = [
    Icons.shopping_cart,
    Icons.restaurant,
    Icons.local_gas_station,
    Icons.home,
    Icons.directions_car,
    Icons.school,
    Icons.health_and_safety,
    Icons.fitness_center,
    Icons.theater_comedy,
    Icons.airplane_ticket,
    Icons.phone_android,
    Icons.pets,
    Icons.checkroom,
    Icons.attach_money,
    Icons.card_giftcard,
    Icons.category,
  ];

  // Lista de cores disponíveis
  static final List<Color> _coresDisponiveis = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
  ];

  // Converter IconData para String
  String _getIconName(IconData icon) {
    if (icon == Icons.shopping_cart) return 'shopping_cart';
    if (icon == Icons.restaurant) return 'restaurant';
    if (icon == Icons.local_gas_station) return 'local_gas_station';
    if (icon == Icons.home) return 'home';
    if (icon == Icons.directions_car) return 'directions_car';
    if (icon == Icons.school) return 'school';
    if (icon == Icons.health_and_safety) return 'health_and_safety';
    if (icon == Icons.fitness_center) return 'fitness_center';
    if (icon == Icons.theater_comedy) return 'theater_comedy';
    if (icon == Icons.airplane_ticket) return 'airplane_ticket';
    if (icon == Icons.phone_android) return 'phone_android';
    if (icon == Icons.pets) return 'pets';
    if (icon == Icons.checkroom) return 'checkroom';
    if (icon == Icons.attach_money) return 'attach_money';
    if (icon == Icons.card_giftcard) return 'card_giftcard';
    return 'category';
  }

  // Converter String para IconData
  static IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'shopping_cart':
        return Icons.shopping_cart;
      case 'restaurant':
        return Icons.restaurant;
      case 'local_gas_station':
        return Icons.local_gas_station;
      case 'home':
        return Icons.home;
      case 'directions_car':
        return Icons.directions_car;
      case 'school':
        return Icons.school;
      case 'health_and_safety':
        return Icons.health_and_safety;
      case 'fitness_center':
        return Icons.fitness_center;
      case 'theater_comedy':
        return Icons.theater_comedy;
      case 'airplane_ticket':
        return Icons.airplane_ticket;
      case 'phone_android':
        return Icons.phone_android;
      case 'pets':
        return Icons.pets;
      case 'checkroom':
        return Icons.checkroom;
      case 'attach_money':
        return Icons.attach_money;
      case 'card_giftcard':
        return Icons.card_giftcard;
      default:
        return Icons.category;
    }
  }
}
