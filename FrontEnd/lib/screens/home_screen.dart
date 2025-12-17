import 'package:flutter/material.dart';
import '../models/viaje.dart';
import '../models/estadisticas.dart';
import '../services/api_service.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  Estadisticas? _estadisticas;
  List<Viaje> _ultimosViajes = [];
  bool _isLoading = true;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    try {
      final stats = await _apiService.obtenerEstadisticas();
      final viajes = await _apiService.obtenerViajes();
      setState(() {
        _estadisticas = stats;
        _ultimosViajes = viajes.take(3).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    
    if (index == 1) {
      Navigator.pushNamed(context, '/viajes');
    } else if (index == 2) {
      Navigator.pushNamed(context, '/estadisticas');
    } else if (index == 3) {
      Navigator.pushNamed(context, '/ajustes');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _cargarDatos,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bienvenido de nuevo',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const Text(
                                'Mis Estadísticas',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                            ],
                          ),
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: const Color(0xFF1E3A8A).withOpacity(0.1),
                            child: const Icon(
                              Icons.person,
                              color: Color(0xFF1E3A8A),
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.1,
                        children: [
                          _buildStatCard(
                            'TOTAL\nRECORRIDO',
                            '${NumberFormat('#,###').format(_estadisticas?.totalKilometros ?? 0)} km',
                            Icons.straighten,
                            const Color(0xFFDBEAFE),
                            const Color(0xFF1E3A8A),
                          ),
                          _buildStatCard(
                            'TOTAL GASTADO',
                            '\$ ${NumberFormat('#,###').format(_estadisticas?.totalGastado ?? 0)}',
                            Icons.attach_money,
                            const Color(0xFFD1FAE5),
                            const Color(0xFF059669),
                          ),
                          _buildStatCard(
                            'CONSUMO PROM.',
                            '${_estadisticas?.consumoPromedio.toStringAsFixed(1) ?? 0} L/100km',
                            Icons.local_gas_station,
                            const Color(0xFFFED7AA),
                            const Color(0xFFEA580C),
                          ),
                          _buildStatCard(
                            'VIAJES',
                            '${_estadisticas?.totalViajes ?? 0}',
                            Icons.map,
                            const Color(0xFFE9D5FF),
                            const Color(0xFF7C3AED),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Últimos Viajes',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pushNamed(context, '/viajes'),
                            child: const Text(
                              'Ver todo',
                              style: TextStyle(
                                color: Color(0xFF1E3A8A),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ..._ultimosViajes.map((viaje) => _buildViajeCard(viaje)),
                    ],
                  ),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/nuevo-viaje');
          _cargarDatos();
        },
        child: const Icon(Icons.add, size: 32),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF1E3A8A),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
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
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color bgColor, Color iconColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? const Color(0xFF94A3B8) : Colors.grey[600],
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1E3A8A),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildViajeCard(Viaje viaje) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFDBEAFE),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.route,
            color: Color(0xFF1E3A8A),
            size: 24,
          ),
        ),
        title: Text(
          '${viaje.origen} → ${viaje.destino}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              DateFormat('dd MMM yyyy', 'es').format(viaje.fecha),
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
            const SizedBox(height: 4),
            Text(
              '${viaje.kilometros.toStringAsFixed(0)} km | ${viaje.duracionHoras}',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${viaje.costoTotal.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF10B981),
              ),
            ),
            Text(
              'Personal',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/detalle-viaje',
            arguments: {'viaje': viaje},
          ).then((_) => _cargarDatos());
        },
      ),
    );
  }
}
