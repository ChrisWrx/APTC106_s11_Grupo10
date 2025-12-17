# RutaLog - Sistema de Gestión de Viajes en Auto

Aplicación completa para el registro, seguimiento y análisis de viajes en automóvil, desarrollada con arquitectura cliente-servidor.

## Descripción del Proyecto

RutaLog permite a los usuarios registrar sus viajes en automóvil, gestionar información detallada como costos de combustible y peajes, calcular el consumo promedio del vehículo, y visualizar estadísticas mediante gráficos interactivos. La aplicación cuenta con integración de Google Maps para autocompletar direcciones y calcular distancias automáticamente.

## Tecnologías Utilizadas

### Backend
- Python 3.8+
- Flask 2.3+
- Flask-CORS
- Flask-SQLAlchemy
- SQLite
- Google Maps API

### Frontend
- Flutter 3.0+
- Dart
- HTTP Package
- fl_chart (gráficos)
- intl (internacionalización)

## Estructura del Proyecto

```
APTC106_s9_Grupo10/
├── BackEnd/
│   ├── app.py
│   ├── models.py
│   ├── requirements.txt
│   ├── seed_data.py
│   ├── instance/
│   └── uploads/
├── FrontEnd/
│   ├── lib/
│   │   ├── main.dart
│   │   ├── models/
│   │   ├── screens/
│   │   └── services/
│   ├── pubspec.yaml
│   └── build/
├── GOOGLE_MAPS_SETUP.md
└── README.md
```

## Instalación y Configuración

### Backend (API REST)

1. Navegar a la carpeta del backend:
```bash
cd BackEnd
```

2. Crear entorno virtual:
```bash
python -m venv venv
```

3. Activar entorno virtual:

Windows PowerShell:
```powershell
.\venv\Scripts\Activate.ps1
```

Windows CMD:
```cmd
venv\Scripts\activate.bat
```

4. Instalar dependencias:
```bash
pip install -r requirements.txt
```

5. Ejecutar el servidor:
```bash
python app.py
```

El servidor estará disponible en: `http://localhost:5000`

### Frontend (Aplicación Móvil)

1. Navegar a la carpeta del frontend:
```bash
cd FrontEnd
```

2. Instalar dependencias:
```bash
flutter pub get
```

3. Verificar configuración de Flutter:
```bash
flutter doctor
```

4. Ejecutar la aplicación:

En emulador:
```bash
flutter run
```

En dispositivo específico:
```bash
flutter devices
flutter run -d <device-id>
```

## Funcionalidades Principales

### Gestión de Viajes
- Crear, editar y eliminar viajes
- Registro de origen y destino con autocompletado
- Cálculo automático de distancias
- Almacenamiento de costos de combustible y peajes
- Adjuntar fotos a los viajes
- Agregar notas personalizadas

### Estadísticas y Análisis
- Total de kilómetros recorridos
- Total de gastos acumulados
- Consumo promedio del vehículo (L/100km)
- Gráficos de kilómetros por mes
- Gráficos de gastos en el tiempo
- Viajes destacados (más largo, más costoso)

### Interfaz de Usuario
- Tema claro y oscuro
- Diseño intuitivo y responsive
- Navegación fluida entre secciones
- Feedback visual inmediato

## Endpoints de la API

### Viajes
- `GET /api/viajes` - Obtener todos los viajes
- `GET /api/viajes/:id` - Obtener un viaje específico
- `POST /api/viajes` - Crear nuevo viaje
- `PUT /api/viajes/:id` - Actualizar viaje
- `DELETE /api/viajes/:id` - Eliminar viaje

### Estadísticas
- `GET /api/estadisticas` - Obtener estadísticas generales

### Imágenes
- `POST /api/upload` - Subir imagen
- `GET /api/uploads/:filename` - Obtener imagen

### Google Maps
- `GET /api/google/autocomplete` - Autocompletar direcciones
- `GET /api/google/distance` - Calcular distancia entre puntos

### Health Check
- `GET /api/salud` - Verificar estado del servidor

## Configuración de Google Maps API

Para utilizar las funcionalidades de autocompletado y cálculo de distancias, es necesario configurar una API Key de Google Maps. Consultar el archivo `GOOGLE_MAPS_SETUP.md` para instrucciones detalladas.

## Modelo de Datos

### Viaje
- `id`: UUID único
- `origen`: Dirección de origen
- `destino`: Dirección de destino
- `fecha`: Fecha del viaje
- `kilometros`: Distancia recorrida
- `duracion_horas`: Duración del viaje
- `litros_combustible`: Litros consumidos
- `costo_combustible`: Gasto en combustible
- `costo_peajes`: Gasto en peajes
- `notas`: Observaciones opcionales
- `foto_url`: URL de la imagen
- `created_at`: Timestamp de creación

## Requisitos del Sistema

### Backend
- Python 3.8 o superior
- pip (gestor de paquetes Python)
- 50 MB de espacio libre

### Frontend
- Flutter SDK 3.0 o superior
- Android Studio o VS Code
- Emulador Android / iOS o dispositivo físico
- 500 MB de espacio libre

