import 'package:flutter/material.dart';
import '../models/viaje.dart';
import '../services/api_service.dart';
import '../services/location_service.dart';
import 'package:intl/intl.dart';
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import 'dart:convert';

class ViajeFormScreen extends StatefulWidget {
  final Viaje? viaje;

  const ViajeFormScreen({super.key, this.viaje});

  @override
  State<ViajeFormScreen> createState() => _ViajeFormScreenState();
}

class _ViajeFormScreenState extends State<ViajeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  late TextEditingController _origenController;
  late TextEditingController _destinoController;
  late TextEditingController _kilometrosController;
  late TextEditingController _duracionController;
  late TextEditingController _litrosController;
  late TextEditingController _costoController;
  late TextEditingController _peajesController;
  late TextEditingController _notasController;

  DateTime _fechaIda = DateTime.now();
  DateTime? _fechaRegreso;
  bool _isLoading = false;
  
  String _origenSeleccionado = '';
  String _destinoSeleccionado = '';
  List<Map<String, String>> _origenSugerencias = [];
  List<Map<String, String>> _destinoSugerencias = [];
  bool _mostrarOrigenSugerencias = false;
  bool _mostrarDestinoSugerencias = false;
  
  String? _imagenUrl;
  String? _imagenNombre;
  html.File? _imagenArchivo;

  @override
  void initState() {
    super.initState();
    _origenController = TextEditingController(text: widget.viaje?.origen ?? '');
    _destinoController = TextEditingController(text: widget.viaje?.destino ?? '');
    _kilometrosController = TextEditingController(
      text: widget.viaje?.kilometros.toString() ?? '',
    );
    _duracionController = TextEditingController(
      text: widget.viaje?.duracionHoras ?? '',
    );
    _litrosController = TextEditingController(
      text: widget.viaje?.litrosCombustible.toString() ?? '',
    );
    _costoController = TextEditingController(
      text: widget.viaje?.costoCombustible.toString() ?? '',
    );
    _peajesController = TextEditingController(
      text: widget.viaje?.costoPeajes.toString() ?? '',
    );
    _notasController = TextEditingController(text: widget.viaje?.notas ?? '');
    
    if (widget.viaje != null) {
      _fechaIda = widget.viaje!.fecha;
      if (widget.viaje!.fotoUrl.isNotEmpty) {
        _imagenUrl = widget.viaje!.fotoUrl;
      }
    }
  }

  Future<void> _selectFechaIda(BuildContext context) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaIda,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: isDark 
              ? const ColorScheme.dark(
                  primary: Color(0xFF3B82F6),
                  surface: Color(0xFF1E293B),
                  onSurface: Colors.white,
                )
              : const ColorScheme.light(
                  primary: Color(0xFF1E3A8A),
                ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _fechaIda) {
      setState(() {
        _fechaIda = picked;
        // Si la fecha de regreso es anterior a la nueva fecha de ida, resetearla
        if (_fechaRegreso != null && _fechaRegreso!.isBefore(_fechaIda)) {
          _fechaRegreso = null;
        }
      });
    }
  }

  Future<void> _selectFechaRegreso(BuildContext context) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaRegreso ?? _fechaIda.add(const Duration(days: 1)),
      firstDate: _fechaIda,
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: isDark 
              ? const ColorScheme.dark(
                  primary: Color(0xFF3B82F6),
                  surface: Color(0xFF1E293B),
                  onSurface: Colors.white,
                )
              : const ColorScheme.light(
                  primary: Color(0xFF1E3A8A),
                ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _fechaRegreso) {
      setState(() {
        _fechaRegreso = picked;
      });
    }
  }

  Future<void> _calcularAutomaticamente() async {
    if (_origenSeleccionado.isNotEmpty && _destinoSeleccionado.isNotEmpty) {
      // Validar que no sean iguales
      if (_origenSeleccionado == _destinoSeleccionado) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('El origen y destino no pueden ser iguales'),
            backgroundColor: Colors.red,
          ),
        );
        _destinoController.clear();
        _destinoSeleccionado = '';
        _kilometrosController.clear();
        setState(() {});
        return;
      }
      
      // Mostrar indicador de carga
      _kilometrosController.text = 'Calculando...';
      _duracionController.text = 'Calculando...';
      setState(() {});
      
      // Calcular kilómetros y duración usando Google Maps API
      final resultado = await LocationService.calculateDistanceAndDuration(_origenSeleccionado, _destinoSeleccionado);
      final km = resultado['distancia_km'] as double;
      final duracionSegundos = resultado['duracion_segundos'] as int;
      
      // Validar distancia mínima de 100 metros (0.1 km)
      if (km < 0.1) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('La distancia mínima debe ser de 100 metros'),
            backgroundColor: Colors.orange,
          ),
        );
        _destinoController.clear();
        _destinoSeleccionado = '';
        _kilometrosController.clear();
        _duracionController.clear();
        setState(() {});
        return;
      }
      
      _kilometrosController.text = km.toStringAsFixed(1);
      _duracionController.text = LocationService.formatDuration(duracionSegundos);
      
      // Calcular combustible estimado
      final litrosEstimados = LocationService.estimateFuelLiters(km);
      _litrosController.text = litrosEstimados.toString();
      
      setState(() {});
    }
  }

  Future<void> _buscarOrigen(String query) async {
    if (query.isEmpty) {
      setState(() {
        _origenSugerencias = [];
        _mostrarOrigenSugerencias = false;
      });
      return;
    }
    
    final sugerencias = await LocationService.searchLocations(query);
    setState(() {
      _origenSugerencias = sugerencias;
      _mostrarOrigenSugerencias = sugerencias.isNotEmpty;
    });
  }

  Future<void> _buscarDestino(String query) async {
    if (query.isEmpty) {
      setState(() {
        _destinoSugerencias = [];
        _mostrarDestinoSugerencias = false;
      });
      return;
    }
    
    final sugerencias = await LocationService.searchLocations(query);
    setState(() {
      _destinoSugerencias = sugerencias;
      _mostrarDestinoSugerencias = sugerencias.isNotEmpty;
    });
  }

  void _seleccionarOrigen(Map<String, String> ubicacion) {
    // Mostrar formato completo: "Dirección, Comuna"
    _origenController.text = ubicacion['display']!;
    _origenSeleccionado = ubicacion['place_id']!; // Guardar place_id de Google Maps
    setState(() {
      _mostrarOrigenSugerencias = false;
    });
    _calcularAutomaticamente();
  }

  void _seleccionarDestino(Map<String, String> ubicacion) {
    // Mostrar formato completo: "Dirección, Comuna"
    _destinoController.text = ubicacion['display']!;
    _destinoSeleccionado = ubicacion['place_id']!; // Guardar place_id de Google Maps
    setState(() {
      _mostrarDestinoSugerencias = false;
    });
    _calcularAutomaticamente();
  }

  void _seleccionarImagen() {
    final html.FileUploadInputElement input = html.FileUploadInputElement()
      ..accept = 'image/*';
    
    input.onChange.listen((event) {
      final files = input.files;
      if (files!.isEmpty) return;
      
      final file = files[0];
      final reader = html.FileReader();
      
      reader.onLoadEnd.listen((event) {
        setState(() {
          _imagenArchivo = file;
          _imagenUrl = reader.result as String;
          _imagenNombre = file.name;
        });
      });
      
      reader.readAsDataUrl(file);
    });
    
    input.click();
  }

  Future<String?> _subirImagenAlServidor() async {
    if (_imagenArchivo == null) return null;

    try {
      final uri = Uri.parse('${ApiService.baseUrl}/upload');
      final request = http.MultipartRequest('POST', uri);
      
      final reader = html.FileReader();
      reader.readAsArrayBuffer(_imagenArchivo!);
      await reader.onLoad.first;
      final bytes = reader.result as List<int>;
      
      request.files.add(http.MultipartFile.fromBytes(
        'imagen',
        bytes,
        filename: _imagenArchivo!.name,
      ));
      
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['exito'] == true && data['url'] != null) {
          return 'http://localhost:5000${data['url']}';
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> _guardarViaje() async {
    if (!_formKey.currentState!.validate()) return;
    
    // Validar campos obligatorios
    if (_costoController.text.isEmpty || _peajesController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.info, color: Colors.lightBlue, size: 48),
          title: const Text('Campos obligatorios'),
          content: const Text('Los campos de Costo de Combustible y Peajes son obligatorios.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
      return;
    }
    
    // Validar que si hay fecha de regreso, sea posterior a la fecha de ida
    if (_fechaRegreso != null && _fechaRegreso!.isBefore(_fechaIda)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La fecha de regreso debe ser posterior a la fecha de ida'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      String? fotoUrl = '';
      
      if (_imagenArchivo != null) {
        fotoUrl = await _subirImagenAlServidor();
      }

      if (widget.viaje == null) {
        
        final nuevoViaje = Viaje(
          id: '',
          origen: _origenController.text,
          destino: _destinoController.text,
          fecha: _fechaIda,
          kilometros: double.parse(_kilometrosController.text),
          duracionHoras: _duracionController.text,
          litrosCombustible: double.parse(_litrosController.text),
          costoCombustible: double.parse(_costoController.text),
          costoPeajes: double.parse(_peajesController.text),
          costoTotal: 0,
          consumoPromedio: 0,
          notas: _notasController.text,
          fotoUrl: fotoUrl ?? '',
          createdAt: DateTime.now(),
        );
        
        await _apiService.crearViaje(nuevoViaje);
      } else {
        
        final datosActualizar = {
          'origen': _origenController.text,
          'destino': _destinoController.text,
          'fecha': DateFormat('yyyy-MM-dd').format(_fechaIda),
          'kilometros': double.parse(_kilometrosController.text),
          'duracion_horas': _duracionController.text,
          'litros_combustible': double.parse(_litrosController.text),
          'costo_combustible': double.parse(_costoController.text),
          'costo_peajes': double.parse(_peajesController.text),
          'notas': _notasController.text,
        };
        
        if (fotoUrl != null && fotoUrl.isNotEmpty) {
          datosActualizar['foto_url'] = fotoUrl;
        } else if (_imagenUrl != null && _imagenUrl!.isNotEmpty && widget.viaje?.fotoUrl != null) {
          datosActualizar['foto_url'] = widget.viaje!.fotoUrl;
        }
        
        await _apiService.actualizarViaje(widget.viaje!.id, datosActualizar);
      }

      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/viajes', (route) => false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.viaje == null
                  ? 'Viaje creado exitosamente'
                  : 'Viaje actualizado exitosamente',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.viaje == null ? 'Nuevo Viaje' : 'Editar Viaje'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'DETALLES DE LA RUTA',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF94A3B8) : Colors.grey,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 16),
              _buildAutocompleteField(
                controller: _origenController,
                label: 'Origen',
                hint: 'Buscar ciudad o dirección',
                icon: Icons.trip_origin,
                sugerencias: _origenSugerencias,
                mostrarSugerencias: _mostrarOrigenSugerencias,
                onChanged: _buscarOrigen,
                onSeleccionar: _seleccionarOrigen,
              ),
              const SizedBox(height: 16),
              _buildAutocompleteField(
                controller: _destinoController,
                label: 'Destino',
                hint: 'Buscar ciudad o dirección',
                icon: Icons.flag,
                sugerencias: _destinoSugerencias,
                mostrarSugerencias: _mostrarDestinoSugerencias,
                onChanged: _buscarDestino,
                onSeleccionar: _seleccionarDestino,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildDateField(
                      label: 'Fecha de Ida',
                      selectedDate: _fechaIda,
                      onTap: () => _selectFechaIda(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDateField(
                      label: 'Fecha de Regreso',
                      selectedDate: _fechaRegreso,
                      onTap: () => _selectFechaRegreso(context),
                      isOptional: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _duracionController,
                label: 'Duración del Viaje',
                hint: 'Auto-calculado',
                icon: Icons.access_time,
                readOnly: true,
              ),
              const SizedBox(height: 24),
              Text(
                'MÉTRICAS Y COSTOS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF94A3B8) : Colors.grey,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _kilometrosController,
                      label: 'Kilómetros',
                      hint: 'Auto-calculado',
                      icon: Icons.straighten,
                      suffix: 'km',
                      keyboardType: TextInputType.number,
                      readOnly: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _litrosController,
                      label: 'Combustible',
                      hint: '0.0',
                      icon: Icons.local_gas_station,
                      suffix: 'L',
                      keyboardType: TextInputType.number,
                      readOnly: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _costoController,
                      label: 'Otros Gastos',
                      hint: '0.00',
                      icon: Icons.attach_money,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      onlyNumbers: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _peajesController,
                      label: 'Peajes',
                      hint: '0.00',
                      icon: Icons.toll,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      onlyNumbers: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'EXTRAS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF94A3B8) : Colors.grey,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 16),
              _buildTextArea(
                controller: _notasController,
                label: 'Notas',
                hint: 'Detalles adicionales del viaje...',
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _seleccionarImagen,
                child: Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF334155) : Colors.grey[300]!,
                      style: BorderStyle.solid,
                      width: 2,
                    ),
                  ),
                  child: _imagenUrl != null
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                _imagenUrl!,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: CircleAvatar(
                                backgroundColor: Colors.red,
                                radius: 16,
                                child: IconButton(
                                  icon: const Icon(Icons.close, size: 16, color: Colors.white),
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    setState(() {
                                      _imagenUrl = null;
                                      _imagenNombre = null;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo,
                              size: 48,
                              color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF64748B) : Colors.grey[400],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Agregar foto',
                              style: TextStyle(
                                color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF94A3B8) : Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            if (_imagenNombre != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                _imagenNombre!,
                                style: TextStyle(
                                  color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF94A3B8) : Colors.grey[500],
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _guardarViaje,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3A8A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Guardar Viaje',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
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

  Widget _buildAutocompleteField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required List<Map<String, String>> sugerencias,
    required bool mostrarSugerencias,
    required Function(String) onChanged,
    required Function(Map<String, String>) onSeleccionar,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
          child: TextFormField(
            controller: controller,
            onChanged: onChanged,
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(color: isDark ? const Color(0xFF94A3B8) : Colors.grey[700]),
              hintText: hint,
              hintStyle: TextStyle(color: isDark ? const Color(0xFF64748B) : Colors.grey[400]),
              prefixIcon: Icon(icon, color: const Color(0xFF3B82F6)),
              suffixIcon: const Icon(Icons.search, size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '$label es obligatorio';
              }
              return null;
            },
          ),
        ),
        if (mostrarSugerencias)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sugerencias.length,
              itemBuilder: (context, index) {
                final sugerencia = sugerencias[index];
                return ListTile(
                  dense: true,
                  leading: Icon(
                    Icons.location_on,
                    color: const Color(0xFF3B82F6),
                    size: 20,
                  ),
                  title: Text(
                    sugerencia['lugar']!,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    sugerencia['comuna']!,
                    style: TextStyle(
                      color: isDark ? const Color(0xFF94A3B8) : Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  onTap: () => onSeleccionar(sugerencia),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? suffix,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    bool readOnly = false,
    int? maxLength,
    bool onlyNumbers = false,
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
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        readOnly: readOnly,
        maxLength: maxLength,
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
        onChanged: onlyNumbers ? (value) {
          if (value.isNotEmpty && !RegExp(r'^\d+$').hasMatch(value)) {
            controller.text = value.replaceAll(RegExp(r'[^\d]'), '');
            controller.selection = TextSelection.fromPosition(
              TextPosition(offset: controller.text.length),
            );
          }
        } : null,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: isDark ? const Color(0xFF94A3B8) : Colors.grey[700]),
          hintText: hint,
          hintStyle: TextStyle(color: isDark ? const Color(0xFF64748B) : Colors.grey[400]),
          suffixText: suffix,
          suffixStyle: TextStyle(color: isDark ? const Color(0xFF94A3B8) : Colors.grey[600]),
          prefixIcon: Icon(icon, color: const Color(0xFF3B82F6)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          counterText: '',
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? selectedDate,
    required VoidCallback onTap,
    bool isOptional = false,
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
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: isOptional ? '$label (Opcional)' : label,
            labelStyle: TextStyle(color: isDark ? const Color(0xFF94A3B8) : Colors.grey[700]),
            prefixIcon: const Icon(
              Icons.calendar_today,
              color: Color(0xFF3B82F6),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          ),
          child: Text(
            selectedDate != null 
              ? DateFormat('dd/MM/yyyy').format(selectedDate) 
              : (isOptional ? 'Sin fecha' : 'Seleccionar fecha'),
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextArea({
    required TextEditingController controller,
    required String label,
    required String hint,
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
      child: TextFormField(
        controller: controller,
        maxLines: 4,
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: isDark ? const Color(0xFF94A3B8) : Colors.grey[700]),
          hintText: hint,
          hintStyle: TextStyle(color: isDark ? const Color(0xFF64748B) : Colors.grey[400]),
          alignLabelWithHint: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _origenController.dispose();
    _destinoController.dispose();
    _kilometrosController.dispose();
    _duracionController.dispose();
    _litrosController.dispose();
    _costoController.dispose();
    _peajesController.dispose();
    _notasController.dispose();
    super.dispose();
  }
}
