# Corrección del flujo de fotos — 1.0.10 (13)

Reporte: al pulsar cámara o galería, antes de aparecer el selector del sistema, la sección de célula quedaba gris. El dispositivo del reporte no está conectado a este entorno; no se ha capturado su excepción original.

## Cambios

- La operación se reserva desde antes del aviso de fotos. Esto impide dobles aperturas y evita el refresco de CommunityShell al reanudarse la app durante consentimiento/permisos.
- La lectura del consentimiento y su escritura tienen espera limitada. Si leer falla se vuelve a pedir consentimiento explícito; si guardar esa aceptación falla, se permite continuar con la acción ya aceptada.
- Todos los resultados del flujo liberan pickingPhoto, incluidos cancelar, denegar permisos, fallar y agotar el plazo. Los errores muestran una explicación y permiten reintentar.
- El selector nativo tiene un plazo máximo de dos minutos; la lectura/preparación de imagen, treinta segundos. Una respuesta tardía no cambia la reunión.
- Procesamiento de imágenes en un módulo puro: no accede a WidgetsBinding ni localización desde un isolate. Tamaño máximo, orientación, eliminación de EXIF y compresión existentes se conservan.
- Recuperación de datos perdidos se invoca únicamente en Android, la plataforma que ofrece esa API.
- La foto queda fuera de los apartados colapsables. Tomar foto ocupa la izquierda y Elegir de galería la derecha. Se conservan vista previa, deshacer, guardar reunión, recuperación y reporte de foto.

## Evidencia

- 99 pruebas en la suite completa aprobadas; 10 pruebas del flujo de fotos repetidas con Figtree y verificaciones del regreso desde el sistema.
- Cobertura del aviso en temas iOS/Android, almacenamiento fallido o sin respuesta, cancelación, selección, permisos denegados, selector sin respuesta, retorno tardío y errores de imagen en un isolate.
- flutter analyze --no-pub: sin incidencias.
- scripts/check_ios_configuration.py: configuración válida.
- APK Android release generado; firma v2, identificador, versión y número de compilación verificados.
- foto-visible-galeria-derecha.png es una captura de widgets Flutter con datos ficticios.

Las pruebas usan respuestas simuladas del selector nativo. No había teléfonos conectados; queda pendiente confirmar el síntoma exacto del reporte en dispositivos físicos. Esta corrección no se ha enviado a las tiendas.
