import uuid
from datetime import datetime
from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

class Viaje(db.Model):
    __tablename__ = 'viajes'
    
    id = db.Column(db.String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    origen = db.Column(db.String(200), nullable=False)
    destino = db.Column(db.String(200), nullable=False)
    fecha = db.Column(db.Date, nullable=False)
    kilometros = db.Column(db.Float, nullable=False)
    duracion_horas = db.Column(db.String(50), nullable=False)
    litros_combustible = db.Column(db.Float, nullable=False)
    costo_combustible = db.Column(db.Float, nullable=False)
    costo_peajes = db.Column(db.Float, nullable=False, default=0)
    notas = db.Column(db.Text, nullable=True)
    foto_url = db.Column(db.String(500), nullable=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    
    def to_dict(self):
        return {
            'id': self.id,
            'origen': self.origen,
            'destino': self.destino,
            'fecha': self.fecha.isoformat() if self.fecha else None,
            'kilometros': self.kilometros,
            'duracion_horas': self.duracion_horas,
            'litros_combustible': self.litros_combustible,
            'costo_combustible': self.costo_combustible,
            'costo_peajes': self.costo_peajes,
            'costo_total': self.costo_combustible + self.costo_peajes,
            'consumo_promedio': round(self.kilometros / self.litros_combustible, 2) if self.litros_combustible > 0 else 0,
            'notas': self.notas,
            'foto_url': self.foto_url,
            'created_at': self.created_at.isoformat() if self.created_at else None
        }
    
    def __repr__(self):
        return f'<Viaje {self.origen} -> {self.destino}>'
