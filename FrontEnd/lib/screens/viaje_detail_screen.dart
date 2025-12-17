import 'package:flutter/material.dart';
import '../models/viaje.dart';
import '../services/api_service.dart';
import 'package:intl/intl.dart';

class ViajeDetailScreen extends StatelessWidget {
  final Viaje viaje;

  const ViajeDetailScreen({super.key, required this.viaje});

  Future<void> _eliminarViaje(BuildContext context) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.lightBlue),
            SizedBox(width: 12),
            Text('Confirmar'),
          ],
        ),
        content: Text(
          '¿Estás seguro de eliminar este viaje?\n\n${viaje.origen} → ${viaje.destino}\n${DateFormat('dd MMM yyyy').format(viaje.fecha)}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar == true && context.mounted) {
      try {
        await ApiService().eliminarViaje(viaje.id);
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(context, '/viajes', (route) => false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Viaje eliminado exitosamente')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al eliminar: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1F2937);
    final labelColor = isDark ? const Color(0xFF94A3B8) : Colors.grey;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Viaje'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/editar-viaje',
                arguments: {'viaje': viaje},
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _eliminarViaje(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.grey[300],
                    image: viaje.fotoUrl.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(viaje.fotoUrl),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.3),
                            BlendMode.darken,
                          ),
                        )
                      : null,
                  ),
                  child: viaje.fotoUrl.isEmpty
                    ? Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 64,
                          color: isDark ? const Color(0xFF475569) : Colors.grey[400],
                        ),
                      )
                    : null,
                ),
                Positioned(
                  left: 20,
                  bottom: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'COMPLETADO',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${viaje.origen} → ${viaje.destino}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black45,
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            DateFormat('dd MMM, yyyy').format(viaje.fecha),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              shadows: [
                                Shadow(
                                  color: Colors.black45,
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          context,
                          'ORIGEN',
                          viaje.origen,
                          Icons.trip_origin,
                          const Color(0xFF1E3A8A),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoCard(
                          context,
                          'DESTINO',
                          viaje.destino,
                          Icons.flag,
                          const Color(0xFF1E3A8A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          context,
                          'DISTANCIA',
                          '${viaje.kilometros.toStringAsFixed(0)} km',
                          Icons.straighten,
                          const Color(0xFF1E3A8A),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoCard(
                          context,
                          'DURACIÓN',
                          viaje.duracionHoras,
                          Icons.access_time,
                          const Color(0xFF1E3A8A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    context,
                    'Costos',
                    Icons.attach_money,
                    [
                      _buildCostoRow(
                        context,
                        'Combustible',
                        viaje.litrosCombustible,
                        Icons.local_gas_station,
                        isLiters: true,
                      ),
                      _buildCostoRow(
                        context,
                        'Otros Gastos',
                        viaje.costoCombustible,
                        Icons.shopping_bag,
                      ),
                      _buildCostoRow(
                        context,
                        'Peajes',
                        viaje.costoPeajes,
                        Icons.toll,
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'TOTAL ESTIMADO',
                            style: TextStyle(
                              fontSize: 12,
                              color: labelColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '\$${NumberFormat('#,###').format(viaje.costoTotal)}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3B82F6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    context,
                    'Rendimiento',
                    Icons.speed,
                    [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD1FAE5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.eco,
                              color: Color(0xFF059669),
                              size: 32,
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'CONSUMO PROMEDIO',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF059669),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '${viaje.consumoPromedio.toStringAsFixed(1)} km/L',
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF059669),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (viaje.notas.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _buildSection(
                      context,
                      'Notas',
                      Icons.note,
                      [
                        Text(
                          viaje.notas,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? const Color(0xFF94A3B8) : Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 1,
      onTap: (index) {
        if (index == 0) {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        } else if (index == 1) {
          Navigator.pushNamedAndRemoveUntil(context, '/viajes', (route) => false);
        } else if (index == 2) {
          Navigator.pushNamedAndRemoveUntil(context, '/estadisticas', (route) => false);
        } else if (index == 3) {
          Navigator.pushNamedAndRemoveUntil(context, '/ajustes', (route) => false);
        }
      },
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

  Widget _buildInfoCard(BuildContext context, String label, String value, IconData icon, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1F2937);
    final labelColor = isDark ? const Color(0xFF94A3B8) : Colors.grey;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: const Color(0xFF3B82F6)),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: labelColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, IconData icon, List<Widget> children) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1F2937);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF3B82F6)),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildCostoRow(BuildContext context, String label, double monto, IconData icon, {bool isLiters = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1F2937);
    final iconColor = isDark ? const Color(0xFF94A3B8) : Colors.grey[600];
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 15, color: textColor),
            ),
          ),
          Text(
            isLiters 
              ? '${monto.toStringAsFixed(2)} L'
              : '\$${NumberFormat('#,###').format(monto)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
