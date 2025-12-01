import 'package:flutter/material.dart';
import 'tela_dashboard.dart';
import 'tela_graficos.dart';
import 'tela_adicionar_transacao.dart';
import 'tela_relatorios.dart';
import 'tela_perfil.dart';

class TelaNavegacaoPrincipal extends StatefulWidget {
  const TelaNavegacaoPrincipal({super.key});

  @override
  State<TelaNavegacaoPrincipal> createState() => _TelaNavegacaoPrincipalState();
}

class _TelaNavegacaoPrincipalState extends State<TelaNavegacaoPrincipal> {
  int _indiceAtual = 0;

  final List<Widget> _telas = const [
    TelaDashboard(),
    TelaGraficos(),
    SizedBox.shrink(), // Placeholder para o botão +
    TelaRelatorios(),
    TelaPerfil(),
  ];

  void _aoTrocarTela(int indice) {
    if (indice == 2) {
      // Botão + no centro
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const TelaAdicionarTransacao()),
      );
    } else {
      setState(() => _indiceAtual = indice);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _telas[_indiceAtual],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _indiceAtual == 2 ? 0 : _indiceAtual,
          onTap: _aoTrocarTela,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFFFDD835),
          unselectedItemColor: Colors.grey,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Início',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              activeIcon: Icon(Icons.bar_chart),
              label: 'Gráficos',
            ),
            BottomNavigationBarItem(
              icon: CircleAvatar(
                radius: 24,
                backgroundColor: Color(0xFFFDD835),
                child: Icon(Icons.add, color: Colors.black87, size: 32),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.description_outlined),
              activeIcon: Icon(Icons.description),
              label: 'Relatórios',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Eu',
            ),
          ],
        ),
      ),
    );
  }
}
