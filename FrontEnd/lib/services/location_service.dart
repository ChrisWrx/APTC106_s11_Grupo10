import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationService {
  // URL del backend Flask que actúa como proxy para Google Maps API
  // Esto soluciona el problema de CORS en Flutter Web
  static const String _backendUrl = 'http://localhost:5000';
  
  // Buscar ubicaciones usando Google Places Autocomplete API a través del backend
  static Future<List<Map<String, String>>> searchLocations(String query) async {
    if (query.isEmpty) return [];
    
    try {
      final url = Uri.parse(
        '$_backendUrl/api/google/autocomplete?query=${Uri.encodeComponent(query)}'
      );
      
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final predictions = data['predictions'] as List;
        
        return predictions.take(5).map<Map<String, String>>((prediction) {
          final description = prediction['description'] as String;
          final placeId = prediction['place_id'] as String;
          
          // Extraer dirección y comuna del description
          final parts = description.split(',');
          final lugar = parts.isNotEmpty ? parts[0].trim() : description;
          final comuna = parts.length > 1 ? parts[1].trim() : '';
          
          return {
            'lugar': lugar,
            'comuna': comuna,
            'display': description,
            'place_id': placeId,
          };
        }).toList();
      }
    } catch (e) {
      print('Error al buscar ubicaciones en Google Maps: $e');
      return [];
    }
    
    return [];
  }

  // Calcular distancia y duración usando Google Distance Matrix API a través del backend
  static Future<Map<String, dynamic>> calculateDistanceAndDuration(String origenPlaceId, String destinoPlaceId) async {
    try {
      final url = Uri.parse(
        '$_backendUrl/api/google/distance?origen=$origenPlaceId&destino=$destinoPlaceId'
      );
      
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final elements = data['rows'][0]['elements'][0];
        
        if (elements['status'] == 'OK') {
          final distanceInMeters = elements['distance']['value'] as int;
          final durationInSeconds = elements['duration']['value'] as int;
          
          return {
            'distancia_km': distanceInMeters / 1000.0,
            'duracion_segundos': durationInSeconds,
            'duracion_texto': elements['duration']['text'], // "1 hour 23 mins" o similar
          };
        }
      }
    } catch (e) {
      print('Error al calcular distancia en Google Maps: $e');
      return {'distancia_km': 0.0, 'duracion_segundos': 0, 'duracion_texto': '0 min'};
    }
    
    return {'distancia_km': 0.0, 'duracion_segundos': 0, 'duracion_texto': '0 min'};
  }

  // Calcular distancia (método legacy para compatibilidad)
  static Future<double> calculateDistance(String origenPlaceId, String destinoPlaceId) async {
    final result = await calculateDistanceAndDuration(origenPlaceId, destinoPlaceId);
    return result['distancia_km'] as double;
  }

  // Estimar litros de combustible (consumo promedio 12 km/L)
  static double estimateFuelLiters(double kilometers, {double consumo = 12.0}) {
    if (kilometers == 0) return 0.0;
    return double.parse((kilometers / consumo).toStringAsFixed(2));
  }

  // Convertir segundos a formato "Xh Ym"
  static String formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    
    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h';
    } else {
      return '${minutes}m';
    }
  }
}
