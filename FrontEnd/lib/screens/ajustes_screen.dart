import 'package:flutter/material.dart';
import '../main.dart';

class AjustesScreen extends StatefulWidget {
  const AjustesScreen({super.key});

  @override
  State<AjustesScreen> createState() => _AjustesScreenState();
}

class _AjustesScreenState extends State<AjustesScreen> {
  int _selectedIndex = 3;
  bool _notificaciones = false;

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/viajes');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/estadisticas');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'APARIENCIA',
            style: TextStyle(
              fontSize: 13,
              color: themeProvider.isDark ? const Color(0xFF94A3B8) : Colors.grey,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          _buildConfigCard(
            icon: themeProvider.isDark ? Icons.light_mode : Icons.dark_mode,
            iconColor: themeProvider.isDark ? const Color(0xFFFFA726) : const Color(0xFF5B63D3),
            iconBgColor: themeProvider.isDark ? const Color(0xFF2C3E50) : const Color(0xFFE8E9F3),
            titulo: 'Modo Oscuro',
            trailing: Switch(
              value: themeProvider.isDark,
              onChanged: (value) {
                themeProvider.toggleTheme();
                setState(() {});
              },
              activeColor: const Color(0xFF3B82F6),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'GENERAL',
            style: TextStyle(
              fontSize: 13,
              color: themeProvider.isDark ? const Color(0xFF94A3B8) : Colors.grey,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          _buildConfigCard(
            icon: Icons.notifications,
            iconColor: themeProvider.isDark ? const Color(0xFF60A5FA) : const Color(0xFF5B63D3),
            iconBgColor: themeProvider.isDark ? const Color(0xFF2C3E50) : const Color(0xFFE8E9F3),
            titulo: 'Notificaciones',
            trailing: Switch(
              value: _notificaciones,
              onChanged: (value) {
                setState(() => _notificaciones = value);
              },
              activeColor: const Color(0xFF1E3A8A),
            ),
          ),
          const SizedBox(height: 12),
          _buildConfigCard(
            icon: Icons.straighten,
            iconColor: themeProvider.isDark ? const Color(0xFF60A5FA) : const Color(0xFF5B63D3),
            iconBgColor: themeProvider.isDark ? const Color(0xFF2C3E50) : const Color(0xFFE8E9F3),
            titulo: 'Unidades de Medida',
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: const Text('Unidades de Medida'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: const Text('Kilómetros (km)'),
                        leading: Radio(value: 1, groupValue: 1, onChanged: (v) {}),
                      ),
                      ListTile(
                        title: const Text('Millas (mi)'),
                        leading: Radio(value: 2, groupValue: 1, onChanged: (v) {}),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cerrar'),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            'INFORMACIÓN',
            style: TextStyle(
              fontSize: 13,
              color: themeProvider.isDark ? const Color(0xFF94A3B8) : Colors.grey,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          _buildConfigCard(
            icon: Icons.info,
            iconColor: themeProvider.isDark ? const Color(0xFF60A5FA) : const Color(0xFF5B63D3),
            iconBgColor: themeProvider.isDark ? const Color(0xFF2C3E50) : const Color(0xFFE8E9F3),
            titulo: 'Acerca de RutaLog',
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: const Row(
                    children: [
                      Icon(Icons.directions_car, color: Color(0xFF1E3A8A)),
                      SizedBox(width: 12),
                      Text('RutaLog'),
                    ],
                  ),
                  content: const Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Versión 1.0.2',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tu diario de viajes en carretera',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Desarrollado con Flutter y Flask',
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cerrar'),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            'CUENTA',
            style: TextStyle(
              fontSize: 13,
              color: themeProvider.isDark ? const Color(0xFF94A3B8) : Colors.grey,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          _buildConfigCard(
            icon: Icons.logout,
            iconColor: Colors.red,
            iconBgColor: const Color(0xFFFEE2E2),
            titulo: 'Cerrar Sesión',
            titleColor: Colors.red,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: const Text('Cerrar Sesión'),
                  content: const Text(
                    '¿Estás seguro de que deseas cerrar sesión?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Sesión cerrada'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Cerrar Sesión'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildConfigCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String titulo,
    Color? titleColor,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: iconBgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        title: Text(
          titulo,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: titleColor ?? Colors.black,
          ),
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF1E3A8A),
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Mapa',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.directions_car),
          label: 'Vehiculos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Ajustes',
        ),
      ],
    );
  }
}
