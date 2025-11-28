import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../dominio/entidades/transacao.dart';
import '../bloc/categoria/categoria_bloc.dart';
import '../bloc/categoria/categoria_state.dart';
import '../bloc/transacao/transacao_bloc.dart';
import '../bloc/transacao/transacao_event.dart';

class TelaAdicionarTransacao extends StatefulWidget {
  const TelaAdicionarTransacao({super.key});

  @override
  State<TelaAdicionarTransacao> createState() => _TelaAdicionarTransacaoState();
}

class _TelaAdicionarTransacaoState extends State<TelaAdicionarTransacao> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _valorController = TextEditingController();
  final _descricaoController = TextEditingController();
  
  TipoTransacao _tipo = TipoTransacao.despesa;
  String? _categoriaId;
  DateTime _data = DateTime.now();

  @override
  void dispose() {
    _tituloController.dispose();
    _valorController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  void _salvar() {
    if (_formKey.currentState!.validate() && _categoriaId != null) {
      final valor = double.parse(_valorController.text.replaceAll(',', '.'));
      
      // Gera ID único
      final id = 'txn_${DateTime.now().millisecondsSinceEpoch}';
      final agora = DateTime.now();
      
      final transacao = Transacao(
        id: id,
        titulo: _tituloController.text,
        valor: valor,
        categoriaId: _categoriaId!,
        tipo: _tipo,
        data: _data,
        descricao: _descricaoController.text.isEmpty ? null : _descricaoController.text,
        criadoEm: agora,
        atualizadoEm: agora,
      );
      
      context.read<TransacaoBloc>().add(
        CriarTransacao(transacao),
      );
      
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transação adicionada com sucesso!')),
      );
    } else if (_categoriaId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione uma categoria')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Transação'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Tipo: Receita ou Despesa
            SegmentedButton<TipoTransacao>(
              segments: const [
                ButtonSegment(
                  value: TipoTransacao.receita,
                  label: Text('Receita'),
                  icon: Icon(Icons.arrow_upward, color: Colors.green),
                ),
                ButtonSegment(
                  value: TipoTransacao.despesa,
                  label: Text('Despesa'),
                  icon: Icon(Icons.arrow_downward, color: Colors.red),
                ),
              ],
              selected: {_tipo},
              onSelectionChanged: (Set<TipoTransacao> newSelection) {
                setState(() {
                  _tipo = newSelection.first;
                  _categoriaId = null; // Reset categoria ao mudar tipo
                });
              },
            ),
            const SizedBox(height: 16),
            
            // Título
            TextFormField(
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) => value?.isEmpty ?? true ? 'Campo obrigatório' : null,
            ),
            const SizedBox(height: 16),
            
            // Valor
            TextFormField(
              controller: _valorController,
              decoration: const InputDecoration(
                labelText: 'Valor',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
                prefixText: 'R\$ ',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Campo obrigatório';
                if (double.tryParse(value!.replaceAll(',', '.')) == null) {
                  return 'Valor inválido';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Categoria
            BlocBuilder<CategoriaBloc, CategoriaState>(
              builder: (context, state) {
                if (state is CategoriaCarregada) {
                  final categoriasFiltradas = state.categorias.where((cat) {
                    final c = cat as dynamic;
                    return c.tipo.toString() == 'TipoCategoria.${_tipo.name}';
                  }).toList();
                  
                  return DropdownButtonFormField<String>(
                    value: _categoriaId,
                    decoration: const InputDecoration(
                      labelText: 'Categoria',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.category),
                    ),
                    items: categoriasFiltradas.map((cat) {
                      final c = cat as dynamic;
                      return DropdownMenuItem<String>(
                        value: c.id as String,
                        child: Text('${c.icone} ${c.nome}'),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _categoriaId = value),
                    validator: (value) => value == null ? 'Selecione uma categoria' : null,
                  );
                }
                return const CircularProgressIndicator();
              },
            ),
            const SizedBox(height: 16),
            
            // Data
            InkWell(
              onTap: () async {
                final data = await showDatePicker(
                  context: context,
                  initialDate: _data,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (data != null) setState(() => _data = data);
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Data',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                child: Text('${_data.day}/${_data.month}/${_data.year}'),
              ),
            ),
            const SizedBox(height: 16),
            
            // Descrição (opcional)
            TextFormField(
              controller: _descricaoController,
              decoration: const InputDecoration(
                labelText: 'Descrição (opcional)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.notes),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            
            // Botões
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _salvar,
                    child: const Text('Salvar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
