# RutaLog - Frontend Flutter

Aplicacion movil desarrollada en Flutter para el registro y gestion de viajes en auto.

## Tecnologias

- Flutter 3.0+
- Dart
- HTTP para consumo de API REST
- fl_chart para graficos
- intl para formateo de fechas

## Estructura del Proyecto

```
frontend/
├── lib/
│   ├── main.dart
│   ├── models/
│   │   ├── viaje.dart
│   │   └── estadisticas.dart
│   ├── services/
│   │   └── api_service.dart
│   └── screens/
│       ├── splash_screen.dart
│       ├── home_screen.dart
│       ├── viajes_list_screen.dart
│       ├── viaje_detail_screen.dart
│       ├── viaje_form_screen.dart
│       └── estadisticas_screen.dart
└── pubspec.yaml
```

## Instalacion

### Requisitos previos
- Flutter SDK instalado
- Android Studio o VS Code con extensiones de Flutter
- Emulador Android o dispositivo fisico

### Pasos

1. Instalar dependencias:
```bash
flutter pub get
```

2. Verificar configuracion:
```bash
flutter doctor
```

3. Ejecutar la aplicacion:
```bash
flutter run
```

## Configuracion del Backend

La aplicacion se conecta al backend Flask en:
```
http://localhost:5000
```

Asegurate de que el backend este corriendo antes de iniciar la app.

## Pantallas

1. **Splash Screen** - Pantalla de inicio con logo
2. **Home/Dashboard** - Estadisticas generales y ultimos viajes
3. **Lista de Viajes** - Todos los viajes registrados
4. **Detalle de Viaje** - Informacion completa de un viaje
5. **Formulario** - Crear o editar viaje
6. **Estadisticas** - Graficos y analisis detallados

## Funcionalidades

- Ver estadisticas generales de viajes
- Listar todos los viajes
- Ver detalle completo de cada viaje
- Crear nuevos viajes
- Editar viajes existentes
- Eliminar viajes
- Ver estadisticas con graficos
- Calculos automaticos de consumo y costos

## Paleta de Colores

- Primario: #1E3A8A (Azul oscuro)
- Secundario: #F97316 (Naranja)
- Exito: #10B981 (Verde)
- Fondo: #F3F4F6 (Gris claro)
