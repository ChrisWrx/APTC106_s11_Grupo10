from flask import Flask, request, jsonify, send_from_directory
from flask_cors import CORS
from models import db, Viaje
from datetime import datetime
from sqlalchemy import func
import requests  # type: ignore
import os
from werkzeug.utils import secure_filename
import uuid

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///rutalog.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['UPLOAD_FOLDER'] = os.path.join(os.path.dirname(__file__), 'uploads')
app.config['MAX_CONTENT_LENGTH'] = 16 * 1024 * 1024  # 16MB max
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif', 'webp'}
CORS(app, resources={r"/api/*": {"origins": "*", "methods": ["GET", "POST", "PUT", "DELETE", "OPTIONS"]}})

# Crear carpeta de uploads si no existe
os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)

# Google Maps API Key
GOOGLE_MAPS_API_KEY = 'AIzaSyCvlnI4fNwxAQwqwbDCzkQwSCg6POPXLJA'

db.init_app(app)

with app.app_context():
    db.create_all()

@app.route('/api/viajes', methods=['GET'])
def obtener_viajes():
    try:
        viajes = Viaje.query.order_by(Viaje.fecha.desc()).all()
        return jsonify({
            'exito': True,
            'viajes': [viaje.to_dict() for viaje in viajes]
        }), 200
    except Exception as e:
        return jsonify({
            'exito': False,
            'mensaje': f'Error al obtener viajes: {str(e)}'
        }), 500

@app.route('/api/viajes/<string:viaje_id>', methods=['GET'])
def obtener_viaje(viaje_id):
    try:
        viaje = Viaje.query.get(viaje_id)
        if not viaje:
            return jsonify({
                'exito': False,
                'mensaje': 'Viaje no encontrado'
            }), 404
        
        return jsonify({
            'exito': True,
            'viaje': viaje.to_dict()
        }), 200
    except Exception as e:
        return jsonify({
            'exito': False,
            'mensaje': f'Error al obtener viaje: {str(e)}'
        }), 500

@app.route('/api/viajes', methods=['POST'])
def crear_viaje():
    try:
        datos = request.get_json()
        
        if not datos.get('origen') or not datos.get('destino'):
            return jsonify({
                'exito': False,
                'mensaje': 'Origen y destino son obligatorios'
            }), 400
        
        fecha_str = datos.get('fecha')
        fecha = datetime.strptime(fecha_str, '%Y-%m-%d').date() if fecha_str else datetime.now().date()
        
        nuevo_viaje = Viaje(
            origen=datos.get('origen'),
            destino=datos.get('destino'),
            fecha=fecha,
            kilometros=float(datos.get('kilometros', 0)),
            duracion_horas=datos.get('duracion_horas', '0h'),
            litros_combustible=float(datos.get('litros_combustible', 0)),
            costo_combustible=float(datos.get('costo_combustible', 0)),
            costo_peajes=float(datos.get('costo_peajes', 0)),
            notas=datos.get('notas', ''),
            foto_url=datos.get('foto_url', '')
        )
        
        db.session.add(nuevo_viaje)
        db.session.commit()
        
        return jsonify({
            'exito': True,
            'mensaje': 'Viaje creado exitosamente',
            'viaje': nuevo_viaje.to_dict()
        }), 201
    except Exception as e:
        db.session.rollback()
        return jsonify({
            'exito': False,
            'mensaje': f'Error al crear viaje: {str(e)}'
        }), 500

@app.route('/api/viajes/<string:viaje_id>', methods=['PUT'])
def actualizar_viaje(viaje_id):
    try:
        viaje = Viaje.query.get(viaje_id)
        if not viaje:
            return jsonify({
                'exito': False,
                'mensaje': 'Viaje no encontrado'
            }), 404
        
        datos = request.get_json()
        
        if datos.get('origen'):
            viaje.origen = datos.get('origen')
        if datos.get('destino'):
            viaje.destino = datos.get('destino')
        if datos.get('fecha'):
            viaje.fecha = datetime.strptime(datos.get('fecha'), '%Y-%m-%d').date()
        if datos.get('kilometros') is not None:
            viaje.kilometros = float(datos.get('kilometros'))
        if datos.get('duracion_horas') is not None:
            viaje.duracion_horas = datos.get('duracion_horas')
        if datos.get('litros_combustible') is not None:
            viaje.litros_combustible = float(datos.get('litros_combustible'))
        if datos.get('costo_combustible') is not None:
            viaje.costo_combustible = float(datos.get('costo_combustible'))
        if datos.get('costo_peajes') is not None:
            viaje.costo_peajes = float(datos.get('costo_peajes'))
        if 'notas' in datos:
            viaje.notas = datos.get('notas')
        if 'foto_url' in datos:
            viaje.foto_url = datos.get('foto_url')
        
        db.session.commit()
        
        return jsonify({
            'exito': True,
            'mensaje': 'Viaje actualizado exitosamente',
            'viaje': viaje.to_dict()
        }), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({
            'exito': False,
            'mensaje': f'Error al actualizar viaje: {str(e)}'
        }), 500

@app.route('/api/viajes/<string:viaje_id>', methods=['DELETE'])
def eliminar_viaje(viaje_id):
    try:
        viaje = Viaje.query.get(viaje_id)
        if not viaje:
            return jsonify({
                'exito': False,
                'mensaje': 'Viaje no encontrado'
            }), 404
        
        db.session.delete(viaje)
        db.session.commit()
        
        return jsonify({
            'exito': True,
            'mensaje': 'Viaje eliminado exitosamente'
        }), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({
            'exito': False,
            'mensaje': f'Error al eliminar viaje: {str(e)}'
        }), 500

@app.route('/api/estadisticas', methods=['GET'])
def obtener_estadisticas():
    try:
        viajes = Viaje.query.all()
        
        if not viajes:
            return jsonify({
                'exito': True,
                'estadisticas': {
                    'total_viajes': 0,
                    'total_kilometros': 0,
                    'total_gastado': 0,
                    'consumo_promedio': 0,
                    'viaje_mas_largo': None,
                    'viaje_mas_costoso': None
                }
            }), 200
        
        total_kilometros = sum(v.kilometros for v in viajes)
        total_gastado = sum(v.costo_combustible + v.costo_peajes for v in viajes)
        total_litros = sum(v.litros_combustible for v in viajes)
        consumo_promedio = round(total_kilometros / total_litros, 2) if total_litros > 0 else 0
        
        viaje_mas_largo = max(viajes, key=lambda v: v.kilometros)
        viaje_mas_costoso = max(viajes, key=lambda v: v.costo_combustible + v.costo_peajes)
        
        return jsonify({
            'exito': True,
            'estadisticas': {
                'total_viajes': len(viajes),
                'total_kilometros': round(total_kilometros, 2),
                'total_gastado': round(total_gastado, 2),
                'consumo_promedio': consumo_promedio,
                'viaje_mas_largo': {
                    'origen': viaje_mas_largo.origen,
                    'destino': viaje_mas_largo.destino,
                    'kilometros': viaje_mas_largo.kilometros
                },
                'viaje_mas_costoso': {
                    'origen': viaje_mas_costoso.origen,
                    'destino': viaje_mas_costoso.destino,
                    'costo_total': viaje_mas_costoso.costo_combustible + viaje_mas_costoso.costo_peajes
                }
            }
        }), 200
    except Exception as e:
        return jsonify({
            'exito': False,
            'mensaje': f'Error al obtener estadisticas: {str(e)}'
        }), 500

@app.route('/api/salud', methods=['GET'])
def salud():
    return jsonify({
        'exito': True,
        'mensaje': 'API RutaLog funcionando correctamente'
    }), 200

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@app.route('/api/upload', methods=['POST'])
def upload_image():
    try:
        if 'imagen' not in request.files:
            return jsonify({
                'exito': False,
                'mensaje': 'No se envió ninguna imagen'
            }), 400
        
        file = request.files['imagen']
        
        if file.filename == '':
            return jsonify({
                'exito': False,
                'mensaje': 'No se seleccionó ningún archivo'
            }), 400
        
        if not allowed_file(file.filename):
            return jsonify({
                'exito': False,
                'mensaje': 'Tipo de archivo no permitido. Use: png, jpg, jpeg, gif, webp'
            }), 400
        
        extension = file.filename.rsplit('.', 1)[1].lower()
        filename = f"{uuid.uuid4()}.{extension}"
        filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
        
        file.save(filepath)
        
        image_url = f"/api/uploads/{filename}"
        
        return jsonify({
            'exito': True,
            'mensaje': 'Imagen subida exitosamente',
            'url': image_url
        }), 201
    except Exception as e:
        return jsonify({
            'exito': False,
            'mensaje': f'Error al subir imagen: {str(e)}'
        }), 500

@app.route('/api/uploads/<filename>', methods=['GET'])
def get_uploaded_file(filename):
    try:
        return send_from_directory(app.config['UPLOAD_FOLDER'], filename)
    except Exception as e:
        return jsonify({
            'exito': False,
            'mensaje': f'Error al obtener imagen: {str(e)}'
        }), 404

@app.route('/api/google/autocomplete', methods=['GET'])
def google_autocomplete():
    try:
        query = request.args.get('query', '')
        if not query:
            return jsonify({'predictions': []}), 200
        
        url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json'
        params = {
            'input': query,
            'components': 'country:cl',
            'language': 'es',
            'key': GOOGLE_MAPS_API_KEY
        }
        
        response = requests.get(url, params=params)
        data = response.json()
        
        return jsonify(data), 200
    except Exception as e:
        return jsonify({
            'status': 'ERROR',
            'error_message': str(e)
        }), 500

@app.route('/api/google/distance', methods=['GET'])
def google_distance():
    try:
        origen_place_id = request.args.get('origen')
        destino_place_id = request.args.get('destino')
        
        if not origen_place_id or not destino_place_id:
            return jsonify({
                'status': 'INVALID_REQUEST',
                'error_message': 'Se requieren origen y destino'
            }), 400
        
        url = 'https://maps.googleapis.com/maps/api/distancematrix/json'
        params = {
            'origins': f'place_id:{origen_place_id}',
            'destinations': f'place_id:{destino_place_id}',
            'units': 'metric',
            'key': GOOGLE_MAPS_API_KEY
        }
        
        response = requests.get(url, params=params)
        data = response.json()
        
        return jsonify(data), 200
    except Exception as e:
        return jsonify({
            'status': 'ERROR',
            'error_message': str(e)
        }), 500

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
