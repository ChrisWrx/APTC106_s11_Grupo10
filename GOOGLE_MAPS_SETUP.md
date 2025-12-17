# Configuración de Google Maps API

## ¿Por qué usar Google Maps API?

La API de Google Maps proporciona:
- ✅ **Autocompletado preciso** de direcciones reales en Chile
- ✅ **Cálculo exacto de distancias** entre ubicaciones
- ✅ **Detección automática** de calles, comunas y regiones
- ✅ **Datos actualizados** constantemente

## Pasos para obtener tu API Key GRATIS

### 1. Crear cuenta en Google Cloud Console

1. Ve a [Google Cloud Console](https://console.cloud.google.com/)
2. Inicia sesión con tu cuenta de Google
3. Acepta los términos y condiciones

### 2. Crear un nuevo proyecto

1. Haz clic en el selector de proyectos (arriba a la izquierda)
2. Haz clic en **"Nuevo Proyecto"**
3. Nombra tu proyecto: `RutaLog` o `APTC106-Grupo10`
4. Haz clic en **"Crear"**

### 3. Habilitar las APIs necesarias

1. En el menú lateral, ve a **"APIs y servicios" > "Biblioteca"**
2. Busca y habilita estas 3 APIs:
   - **Places API** (para autocompletado)
   - **Distance Matrix API** (para cálculo de distancias)
   - **Geocoding API** (para obtener coordenadas)

### 4. Crear credenciales (API Key)

1. Ve a **"APIs y servicios" > "Credenciales"**
2. Haz clic en **"Crear credenciales" > "Clave de API"**
3. Se generará tu API Key (algo como: `AIzaSyDxxx...`)
4. **¡COPIA esta clave!**

### 5. Configurar la API Key en el proyecto

1. Abre el archivo: `frontend/lib/services/location_service.dart`
2. Busca la línea que dice:
   ```dart
   static const String _apiKey = 'TU_API_KEY_AQUI';
   ```
3. Reemplaza `'TU_API_KEY_AQUI'` con tu API Key:
   ```dart
   static const String _apiKey = 'AIzaSyDxxx...'; // Tu clave aquí
   ```
4. **Guarda el archivo**

### 6. (Opcional) Restringir la API Key

Para mayor seguridad:

1. En Google Cloud Console, ve a **"Credenciales"**
2. Haz clic en tu API Key
3. En **"Restricciones de API"**, selecciona:
   - Places API
   - Distance Matrix API
   - Geocoding API
4. En **"Restricciones de aplicación"**, puedes dejarla sin restricciones para desarrollo

## Cuota gratuita

Google ofrece **$200 USD de crédito mensual GRATIS**:
- Places Autocomplete: ~2,800 solicitudes/mes gratis
- Distance Matrix: ~40,000 elementos/mes gratis
- Geocoding: ~40,000 solicitudes/mes gratis

**Esto es más que suficiente para tu proyecto académico** ✅

## Verificar que funciona

1. Ejecuta la aplicación: `flutter run -d chrome`
2. Ve a "Nuevo Viaje"
3. Escribe en "Origen": `Serrano 1313`
4. Deberías ver sugerencias reales de Google Maps con direcciones exactas
5. Selecciona origen y destino, y verás el cálculo automático de kilómetros

## Solución de problemas

### Error: "API key not valid"
- Verifica que copiaste la clave completa
- Asegúrate de que las APIs estén habilitadas

### No aparecen sugerencias
- Revisa la consola del navegador (F12) para ver errores
- Verifica tu conexión a internet
- Confirma que Places API esté habilitada

### Cálculo de kilómetros no funciona
- Verifica que Distance Matrix API esté habilitada
- Revisa que guardaste el archivo después de pegar la API Key

## Recursos adicionales

- [Documentación oficial de Google Maps Platform](https://developers.google.com/maps)
- [Precios de Google Maps API](https://cloud.google.com/maps-platform/pricing)
- [Guía de Places API](https://developers.google.com/maps/documentation/places/web-service/overview)

---

**¿Necesitas ayuda?** Consulta con tu profesor o compañeros del grupo.
