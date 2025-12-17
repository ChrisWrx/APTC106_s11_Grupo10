# RutaLog - Backend API REST

Backend desarrollado en Flask para la aplicacion RutaLog - Sistema de gestion de viajes en auto.

## Tecnologias

- Python 3.8+
- Flask
- SQLAlchemy
- SQLite
- Flask-CORS

## Estructura del Proyecto

```
backend/
├── app.py              # Aplicacion principal con endpoints
├── models.py           # Modelos de base de datos
├── requirements.txt    # Dependencias del proyecto
├── README.md          # Este archivo
└── rutalog.db         # Base de datos SQLite (se genera automaticamente)
```

## Instalacion

### 1. Crear entorno virtual

```bash
python -m venv venv
```

### 2. Activar entorno virtual

Windows PowerShell:
```powershell
.\venv\Scripts\Activate.ps1
```

Windows CMD:
```cmd
venv\Scripts\activate.bat
```

### 3. Instalar dependencias

```bash
pip install -r requirements.txt
```

## Ejecucion

```bash
python app.py
```

El servidor estara disponible en: `http://localhost:5000`

## Endpoints de la API

### Verificar salud de la API
```
GET /api/salud
```

### Obtener todos los viajes
```
GET /api/viajes
```

### Obtener un viaje especifico
```
GET /api/viajes/{id}
```

### Crear un nuevo viaje
```
POST /api/viajes
Content-Type: application/json

{
  "origen": "Santiago",
  "destino": "Valparaiso",
  "fecha": "2025-12-09",
  "kilometros": 120,
  "duracion_horas": 1.5,
  "litros_combustible": 10,
  "costo_combustible": 12000,
  "costo_peajes": 3000,
  "notas": "Viaje familiar",
  "foto_url": ""
}
```

### Actualizar un viaje
```
PUT /api/viajes/{id}
Content-Type: application/json

{
  "origen": "Santiago",
  "kilometros": 125
}
```

### Eliminar un viaje
```
DELETE /api/viajes/{id}
```

### Obtener estadisticas generales
```
GET /api/estadisticas
```

## Modelo de Datos

### Viaje

| Campo | Tipo | Descripcion |
|-------|------|-------------|
| id | String (GUID) | Identificador unico autogenerado |
| origen | String | Ciudad o lugar de origen |
| destino | String | Ciudad o lugar de destino |
| fecha | Date | Fecha del viaje |
| kilometros | Float | Distancia recorrida en km |
| duracion_horas | Float | Duracion del viaje en horas |
| litros_combustible | Float | Litros de combustible consumidos |
| costo_combustible | Float | Costo del combustible |
| costo_peajes | Float | Costo de peajes |
| notas | Text | Observaciones adicionales |
| foto_url | String | URL de foto del viaje |
| created_at | DateTime | Fecha de creacion del registro |

## Respuestas de la API

Todas las respuestas tienen el formato:

```json
{
  "exito": true/false,
  "mensaje": "Mensaje descriptivo",
  "viaje": { objeto viaje },
  "viajes": [ array de viajes ],
  "estadisticas": { objeto estadisticas }
}
```

## Codigos de Estado HTTP

- 200: Operacion exitosa
- 201: Recurso creado exitosamente
- 400: Error en los datos enviados
- 404: Recurso no encontrado
- 500: Error interno del servidor

## Desarrollo

Para desarrollo con recarga automatica:

```bash
set FLASK_ENV=development
python app.py
```

## Base de Datos

La base de datos SQLite se crea automaticamente al iniciar la aplicacion por primera vez.
El archivo se llama `rutalog.db` y se encuentra en el directorio backend.

## CORS

CORS esta habilitado para permitir peticiones desde cualquier origen durante el desarrollo.
