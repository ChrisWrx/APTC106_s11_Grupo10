from app import app, db
from models import Viaje

with app.app_context():
    # Eliminar todos los viajes
    num_deleted = Viaje.query.delete()
    db.session.commit()
    print(f"✓ Se eliminaron {num_deleted} viajes de la base de datos")
    print("✓ Base de datos limpiada exitosamente")
