from app import app, db
from models import Viaje
from datetime import datetime, timedelta
import random

def limpiar_datos():
    with app.app_context():
        db.drop_all()
        db.create_all()
        print("Base de datos limpiada")

def insertar_datos_prueba():
    with app.app_context():
        viajes_chile = [
            {
                'origen': 'Santiago',
                'destino': 'Valparaíso',
                'fecha': datetime(2025, 11, 15).date(),
                'kilometros': 120,
                'duracion_horas': 1.5,
                'litros_combustible': 10,
                'costo_combustible': 12000,
                'costo_peajes': 3000,
                'notas': 'Viaje familiar al puerto, excelente clima'
            },
            {
                'origen': 'Santiago',
                'destino': 'Viña del Mar',
                'fecha': datetime(2025, 11, 20).date(),
                'kilometros': 125,
                'duracion_horas': 1.7,
                'litros_combustible': 11,
                'costo_combustible': 13200,
                'costo_peajes': 3000,
                'notas': 'Visita a la playa en fin de semana largo'
            },
            {
                'origen': 'Santiago',
                'destino': 'La Serena',
                'fecha': datetime(2025, 10, 5).date(),
                'kilometros': 470,
                'duracion_horas': 5.5,
                'litros_combustible': 38,
                'costo_combustible': 45600,
                'costo_peajes': 8500,
                'notas': 'Vacaciones de primavera, ruta por autopista'
            },
            {
                'origen': 'Santiago',
                'destino': 'Concepción',
                'fecha': datetime(2025, 9, 12).date(),
                'kilometros': 515,
                'duracion_horas': 6.0,
                'litros_combustible': 42,
                'costo_combustible': 50400,
                'costo_peajes': 9000,
                'notas': 'Viaje de negocios, ruta completa por autopista'
            },
            {
                'origen': 'Santiago',
                'destino': 'Rancagua',
                'fecha': datetime(2025, 12, 1).date(),
                'kilometros': 87,
                'duracion_horas': 1.0,
                'litros_combustible': 7,
                'costo_combustible': 8400,
                'costo_peajes': 2000,
                'notas': 'Visita familiar de fin de semana'
            },
            {
                'origen': 'Santiago',
                'destino': 'Talca',
                'fecha': datetime(2025, 8, 22).date(),
                'kilometros': 255,
                'duracion_horas': 3.0,
                'litros_combustible': 21,
                'costo_combustible': 25200,
                'costo_peajes': 5500,
                'notas': 'Visita a viñedos de la región del Maule'
            },
            {
                'origen': 'Valparaíso',
                'destino': 'Santiago',
                'fecha': datetime(2025, 11, 16).date(),
                'kilometros': 120,
                'duracion_horas': 1.6,
                'litros_combustible': 10.5,
                'costo_combustible': 12600,
                'costo_peajes': 3000,
                'notas': 'Regreso a casa, algo de tráfico'
            },
            {
                'origen': 'Santiago',
                'destino': 'Puerto Varas',
                'fecha': datetime(2025, 7, 10).date(),
                'kilometros': 1015,
                'duracion_horas': 12.0,
                'litros_combustible': 85,
                'costo_combustible': 102000,
                'costo_peajes': 15000,
                'notas': 'Viaje largo de invierno al sur, paisajes increíbles'
            },
            {
                'origen': 'Santiago',
                'destino': 'San Felipe',
                'fecha': datetime(2025, 11, 28).date(),
                'kilometros': 92,
                'duracion_horas': 1.3,
                'litros_combustible': 8,
                'costo_combustible': 9600,
                'costo_peajes': 1500,
                'notas': 'Paseo por el valle del Aconcagua'
            },
            {
                'origen': 'Concepción',
                'destino': 'Temuco',
                'fecha': datetime(2025, 9, 14).date(),
                'kilometros': 285,
                'duracion_horas': 3.5,
                'litros_combustible': 24,
                'costo_combustible': 28800,
                'costo_peajes': 4500,
                'notas': 'Continuación del viaje de negocios al sur'
            },
            {
                'origen': 'Santiago',
                'destino': 'Pucón',
                'fecha': datetime(2025, 6, 18).date(),
                'kilometros': 780,
                'duracion_horas': 9.0,
                'litros_combustible': 65,
                'costo_combustible': 78000,
                'costo_peajes': 12000,
                'notas': 'Vacaciones de invierno, ruta escénica por el sur'
            },
            {
                'origen': 'Santiago',
                'destino': 'Antofagasta',
                'fecha': datetime(2025, 5, 3).date(),
                'kilometros': 1365,
                'duracion_horas': 16.5,
                'litros_combustible': 115,
                'costo_combustible': 138000,
                'costo_peajes': 8000,
                'notas': 'Viaje épico al norte grande, ruta por el desierto'
            }
        ]
        
        for viaje_data in viajes_chile:
            viaje = Viaje(**viaje_data)
            db.session.add(viaje)
        
        db.session.commit()
        print(f"Se insertaron {len(viajes_chile)} viajes de prueba")
        print("\nViajes creados:")
        
        viajes = Viaje.query.all()
        for v in viajes:
            print(f"- {v.origen} -> {v.destino} ({v.kilometros} km)")

if __name__ == '__main__':
    print("Iniciando carga de datos de prueba...")
    limpiar_datos()
    insertar_datos_prueba()
    print("\nDatos de prueba insertados exitosamente!")
