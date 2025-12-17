import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/viaje.dart';
import '../models/estadisticas.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:5000/api';

  Future<List<Viaje>> obtenerViajes() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/viajes'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['exito'] == true) {
          final List<dynamic> viajesJson = data['viajes'];
          return viajesJson.map((json) => Viaje.fromJson(json)).toList();
        }
      }
      throw Exception('Error al obtener viajes');
    } catch (e) {
      throw Exception('Error de conexion: $e');
    }
  }

  Future<Viaje> obtenerViaje(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/viajes/$id'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['exito'] == true) {
          return Viaje.fromJson(data['viaje']);
        }
      }
      throw Exception('Error al obtener viaje');
    } catch (e) {
      throw Exception('Error de conexion: $e');
    }
  }

  Future<Viaje> crearViaje(Viaje viaje) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/viajes'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(viaje.toJson()),
      );
      
      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data['exito'] == true) {
          return Viaje.fromJson(data['viaje']);
        }
      }
      throw Exception('Error al crear viaje');
    } catch (e) {
      throw Exception('Error de conexion: $e');
    }
  }

  Future<Viaje> actualizarViaje(String id, Map<String, dynamic> datos) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/viajes/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(datos),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['exito'] == true) {
          return Viaje.fromJson(data['viaje']);
        }
      }
      throw Exception('Error al actualizar viaje');
    } catch (e) {
      throw Exception('Error de conexion: $e');
    }
  }

  Future<bool> eliminarViaje(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/viajes/$id'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['exito'] == true;
      }
      return false;
    } catch (e) {
      throw Exception('Error de conexion: $e');
    }
  }

  Future<Estadisticas> obtenerEstadisticas() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/estadisticas'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['exito'] == true) {
          return Estadisticas.fromJson(data['estadisticas']);
        }
      }
      throw Exception('Error al obtener estadisticas');
    } catch (e) {
      throw Exception('Error de conexion: $e');
    }
  }

  Future<String?> subirImagen(File imagen) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/upload'));
      request.files.add(await http.MultipartFile.fromPath('imagen', imagen.path));
      
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data['exito'] == true) {
          return baseUrl.replaceFirst('/api', '') + data['url'];
        }
      }
      throw Exception('Error al subir imagen');
    } catch (e) {
      throw Exception('Error al subir imagen: $e');
    }
  }
}
