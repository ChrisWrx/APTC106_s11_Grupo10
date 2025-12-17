class Estadisticas {
  final int totalViajes;
  final double totalKilometros;
  final double totalGastado;
  final double consumoPromedio;
  final ViajeDestacado? viajeMasLargo;
  final ViajeDestacado? viajeMasCostoso;

  Estadisticas({
    required this.totalViajes,
    required this.totalKilometros,
    required this.totalGastado,
    required this.consumoPromedio,
    this.viajeMasLargo,
    this.viajeMasCostoso,
  });

  factory Estadisticas.fromJson(Map<String, dynamic> json) {
    return Estadisticas(
      totalViajes: json['total_viajes'],
      totalKilometros: (json['total_kilometros'] as num).toDouble(),
      totalGastado: (json['total_gastado'] as num).toDouble(),
      consumoPromedio: (json['consumo_promedio'] as num).toDouble(),
      viajeMasLargo: json['viaje_mas_largo'] != null 
          ? ViajeDestacado.fromJson(json['viaje_mas_largo'])
          : null,
      viajeMasCostoso: json['viaje_mas_costoso'] != null
          ? ViajeDestacado.fromJson(json['viaje_mas_costoso'])
          : null,
    );
  }
}

class ViajeDestacado {
  final String origen;
  final String destino;
  final double? kilometros;
  final double? costoTotal;

  ViajeDestacado({
    required this.origen,
    required this.destino,
    this.kilometros,
    this.costoTotal,
  });

  factory ViajeDestacado.fromJson(Map<String, dynamic> json) {
    return ViajeDestacado(
      origen: json['origen'],
      destino: json['destino'],
      kilometros: json['kilometros'] != null 
          ? (json['kilometros'] as num).toDouble()
          : null,
      costoTotal: json['costo_total'] != null
          ? (json['costo_total'] as num).toDouble()
          : null,
    );
  }
}
