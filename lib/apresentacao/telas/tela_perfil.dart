import 'package:flutter/material.dart';
import 'tela_gerenciar_categorias.dart';

class TelaPerfil extends StatelessWidget {
  const TelaPerfil({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA);
    final textColor = isDark ? const Color(0xFFFDD835) : const Color(0xFF212121);
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // Logo no topo
            const SizedBox(height: 20),
            Center(
              child: Image.asset(
                'assets/images/logo.png',
                height: 60,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 40),
            CircleAvatar(
              radius: 50,
              backgroundColor: cardColor,
              child: const Icon(Icons.person, size: 60, color: Color(0xFFFDD835)),
            ),
            const SizedBox(height: 16),
            Text(
              'Login',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
            ),
            Text(
              'Faça login. É mais emocionante!',
              style: TextStyle(fontSize: 14, color: isDark ? Colors.white70 : Colors.grey[600]),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildMenuItem(
                      context: context,
                      icon: Icons.category,
                      title: 'Gerenciar Categorias',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const TelaGerenciarCategorias()),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.settings,
                      title: 'Configurações',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Configurações em desenvolvimento')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final itemColor = isDark ? const Color(0xFF2A2A2A) : Colors.grey[50]!;
    final textColor = isDark ? Colors.white : const Color(0xFF212121);
    
    return Card(
      elevation: 0,
      color: itemColor,
      child: ListTile(
        textColor: textColor,
        iconColor: const Color(0xFFFDD835),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFFDD835),
          child: Icon(icon, color: Colors.black87),
        ),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
