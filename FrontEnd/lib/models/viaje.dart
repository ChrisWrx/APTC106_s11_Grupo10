class Viaje {
  final String id;
  final String origen;
  final String destino;
  final DateTime fecha;
  final double kilometros;
  final String duracionHoras;
  final double litrosCombustible;
  final double costoCombustible;
  final double costoPeajes;
  final double costoTotal;
  final double consumoPromedio;
  final String notas;
  final String fotoUrl;
  final DateTime createdAt;

  Viaje({
    required this.id,
    required this.origen,
    required this.destino,
    required this.fecha,
    required this.kilometros,
    required this.duracionHoras,
    required this.litrosCombustible,
    required this.costoCombustible,
    required this.costoPeajes,
    required this.costoTotal,
    required this.consumoPromedio,
    required this.notas,
    required this.fotoUrl,
    required this.createdAt,
  });

  factory Viaje.fromJson(Map<String, dynamic> json) {
    return Viaje(
      id: json['id'],
      origen: json['origen'],
      destino: json['destino'],
      fecha: DateTime.parse(json['fecha']),
      kilometros: (json['kilometros'] as num).toDouble(),
      duracionHoras: json['duracion_horas']?.toString() ?? '0h',
      litrosCombustible: (json['litros_combustible'] as num).toDouble(),
      costoCombustible: (json['costo_combustible'] as num).toDouble(),
      costoPeajes: (json['costo_peajes'] as num).toDouble(),
      costoTotal: (json['costo_total'] as num).toDouble(),
      consumoPromedio: (json['consumo_promedio'] as num).toDouble(),
      notas: json['notas'] ?? '',
      fotoUrl: json['foto_url'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'origen': origen,
      'destino': destino,
      'fecha': fecha.toIso8601String().split('T')[0],
      'kilometros': kilometros,
      'duracion_horas': duracionHoras,
      'litros_combustible': litrosCombustible,
      'costo_combustible': costoCombustible,
      'costo_peajes': costoPeajes,
      'notas': notas,
      'foto_url': fotoUrl,
    };
  }
}
