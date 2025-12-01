import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Importações dos BLoCs
import 'apresentacao/bloc/transacao/transacao_bloc.dart';
import 'apresentacao/bloc/categoria/categoria_bloc.dart';
import 'apresentacao/bloc/filtro/filtro_bloc.dart';
import 'apresentacao/bloc/relatorio/relatorio_bloc.dart';
import 'apresentacao/bloc/tema/tema_bloc.dart';
import 'apresentacao/bloc/tema/tema_state.dart';

// Importações dos Repositórios
import 'dados/repositorios/repositorio_transacao_impl.dart';
import 'dados/repositorios/repositorio_categoria_impl.dart';
import 'dados/repositorios/repositorio_relatorio_impl.dart';

// Importações das Fontes de Dados
import 'dados/fontes_dados/banco_dados_local.dart';
import 'dados/fontes_dados/transacao_data_source_local.dart';
import 'dados/fontes_dados/categoria_data_source_local.dart';

// Importação das Telas
import 'apresentacao/telas/tela_navegacao_principal.dart';

// Importação dos dados de teste
import 'dados/utils/dados_teste.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o banco de dados local
  final bancoDados = BancoDadosLocal();
  await bancoDados.database; // Garante que o banco está inicializado

  // Popular banco com dados de teste (apenas na primeira execução)
  await _popularBancoComDadosTeste(bancoDados);

  runApp(DashboardFinanceiroApp(bancoDados: bancoDados));
}

/// Popula o banco com dados de teste realistas
Future<void> _popularBancoComDadosTeste(BancoDadosLocal bancoDados) async {
  final db = await bancoDados.database;

  // Verifica se já existem transações
  final resultado = await db.query('transacoes', limit: 1);
  if (resultado.isNotEmpty) {
    print('✅ Banco já possui dados');
    return; // Já tem dados, não precisa popular novamente
  }

  print('🔄 Populando banco com dados de teste...');

  // Gera transações de teste dos últimos 3 meses
  final transacoesTeste = DadosTeste.gerarTransacoesTeste();

  // Insere as transações no banco
  for (final transacao in transacoesTeste) {
    await db.insert('transacoes', {
      'id': transacao.id,
      'titulo': transacao.titulo,
      'valor': transacao.valor,
      'categoria_id': transacao.categoriaId,
      'data': transacao.data.toIso8601String(),
      'tipo': transacao.tipo.toString().split('.').last,
      'descricao': transacao.descricao,
      'criado_em': transacao.criadoEm.toIso8601String(),
      'atualizado_em': transacao.atualizadoEm.toIso8601String(),
    });
  }

  print('✅ ${transacoesTeste.length} transações inseridas com sucesso!');
}

class DashboardFinanceiroApp extends StatefulWidget {
  final BancoDadosLocal bancoDados;

  const DashboardFinanceiroApp({super.key, required this.bancoDados});

  @override
  State<DashboardFinanceiroApp> createState() => _DashboardFinanceiroAppState();
}

class _DashboardFinanceiroAppState extends State<DashboardFinanceiroApp> {
  @override
  Widget build(BuildContext context) {
    // Inicializa as fontes de dados locais
    final transacaoDataSourceLocal = TransacaoDataSourceLocal(
      widget.bancoDados,
    );
    final categoriaDataSourceLocal = CategoriaDataSourceLocal(
      widget.bancoDados,
    );

    // Inicializa os repositórios
    final repositorioTransacao = RepositorioTransacaoImpl(
      transacaoDataSourceLocal,
    );

    final repositorioCategoria = RepositorioCategoriaImpl(
      categoriaDataSourceLocal,
    );

    final repositorioRelatorio = RepositorioRelatorioImpl(repositorioTransacao);

    return MultiBlocProvider(
      providers: [
        // BLoC de Tema
        BlocProvider(create: (context) => TemaBloc()),
        // BLoC de Transações
        BlocProvider(create: (context) => TransacaoBloc(repositorioTransacao)),
        // BLoC de Categorias
        BlocProvider(create: (context) => CategoriaBloc(repositorioCategoria)),
        // BLoC de Filtros
        BlocProvider(create: (context) => FiltroBloc()),
        // BLoC de Relatórios
        BlocProvider(create: (context) => RelatorioBloc(repositorioRelatorio)),
      ],
      child: BlocBuilder<TemaBloc, TemaState>(
        builder: (context, temaState) {
          return MaterialApp(
            title: 'Dashboard Financeiro',
            debugShowCheckedModeBanner: false,
            themeMode: temaState.modoTema,
            // Tema Claro
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFFFDD835),
                brightness: Brightness.light,
              ),
              useMaterial3: true,
              cardTheme: CardThemeData(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              appBarTheme: const AppBarTheme(
                centerTitle: true,
                elevation: 0,
                backgroundColor: Color(0xFFFDD835),
                foregroundColor: Colors.black87,
              ),
            ),
            // Tema Escuro
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFFFDD835),
                brightness: Brightness.dark,
              ),
              scaffoldBackgroundColor: const Color(0xFF121212),
              useMaterial3: true,
              cardTheme: CardThemeData(
                elevation: 2,
                color: const Color(0xFF1E1E1E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              appBarTheme: const AppBarTheme(
                centerTitle: true,
                elevation: 0,
                backgroundColor: Color(0xFF121212),
                foregroundColor: Color(0xFFFDD835),
              ),
            ),
            home: const TelaNavegacaoPrincipal(),
          );
        },
      ),
    );
  }
}
