# Verificación local — 22 de octubre de 2026

- Formato y flutter analyze: sin incidencias.
- flutter test: nueve pruebas de lógica e interfaz aprobadas.
- Prueba nativa Android: inicialización Firebase, programación de un cumpleaños local y recepción real de FCM en primer plano aprobadas en el emulador Pixel_10.
- Firebase: Android e iOS registrados en sheeplink; SHA-1 debug y release visibles en consola; Cloud Messaging V1 habilitado.
- API de producción: login y /cells respondieron correctamente con la cuenta de revisión guardada; esa cuenta tiene cero células. /notifications/config devolvió enabled=true. No se escribieron asistencias de producción. El flujo de guardado se comprobó con el repositorio aislado de pruebas.
- Capturas de Hoy, Mi célula y Perfil en artifacts/. Usan integrantes ficticios exclusivamente de la suite.
- iOS: fuentes y configuración preparadas; pendiente APNs y compilación/prueba en macOS.

El envío técnico se dirigió exclusivamente a la instalación temporal del emulador, con texto de prueba. No se enviaron notificaciones a usuarios reales.
- APK final con icono oficial: compilado, firma SHA-1 verificada con apksigner y arranque de la versión release comprobado en el emulador Android.

## Acceso con Google

Se añaden cuatro pruebas: intercambio de identidad con la sesión del backend, cancelación sin solicitud al backend, rechazo de cuenta y botón de Google sin validación obligatoria de correo/contraseña. Suite de unidad/widgets: 13 pruebas aprobadas. Análisis estático sin incidencias. Captura de la pantalla inicial en artifacts/login-google-mobile.png. No se ha completado un inicio de sesión con una cuenta Google real.


## Reuniones semanales, perfil y servicio

- Flutter: 22 pruebas aprobadas y análisis estático limpio. Se verifica invitación de notificaciones sin repetición, permisos de siervo, guardado parcial con reintento, fotos comprimidas sin EXIF, fechas semanales y recordatorios confirmados/restringidos/cancelados y horarios nocturnos.
- Backend: 165 pruebas aprobadas, compilación y arquitectura válidas. Casos nuevos verifican semanas, fotos históricas privadas y aislamiento de células e iglesias.
- Web: compilación, arquitectura y 21 pruebas unitarias aprobadas. El historial semanal se integra en el reporte de asistencia existente.
- El chequeo global de formato del backend detecta archivos preexistentes; los archivos modificados se formatearon individualmente.
- Sin escrituras en datos reales de asistencia. Los nuevos endpoints semanales y la vista web todavía requieren publicación para usarse contra producción.

- Web pastoral: dos pruebas de navegador aprobadas (escritorio y móvil), con consulta semanal, variación y foto privada; Escape cierra el visor.
- Perfil: cabecera visual, avatar con iniciales como respaldo y cámara/galería. La foto personalizada tiene prioridad sobre Google; el backend obtiene la URL de Google exclusivamente de la identidad firmada y acepta hosts googleusercontent.com por HTTPS. El cliente descarga esa imagen sin cookies de SheepLink. No se realizó un Google login real ni se cambió la foto del usuario en producción.


## Corrección de sesión y foto Google

26 pruebas móviles aprobadas. Se agregan regresiones de cierre de sesión cuando falla la limpieza de avisos, salida offline con eliminación de cookies y foto guardada, recuperación de foto de Google tras restaurar sesión y rechazo de foto cuando el servidor rechaza la identidad. El móvil conserva por usuario en almacenamiento seguro la URL picture del token únicamente después de que /auth/google lo acepta; prioriza siempre el avatar personalizado devuelto por el servidor. Una sesión antigua requiere volver a entrar por Google una vez para obtener esa foto.

Validación manual posterior en Android: cierre de sesión real volvió al login; nuevo acceso con la cuenta Google existente completado; avatar Google visible en el perfil. No se cambió la foto del usuario ni se escribieron asistencias.

## Preparación Play — 22 de octubre de 2026

29 pruebas Flutter aprobadas y análisis estático sin incidencias. Incluye consentimiento de fotos por usuario, rechazo del consentimiento, validación y envío de reportes, y captura de ficha con datos ficticios.

AAB firmado 1.0.0+1 aceptado por Play y publicado en prueba interna activa. Bundletool valida el bundle; min24/target36/compile36 confirmados desde su manifiesto, PAGE_ALIGNMENT_16K y ocho bibliotecas arm64/x86_64 verificadas por ELF. Sin prueba de ejecución 16 KB todavía. Huellas de firma Play SHA-1 y SHA-256 registradas y visibles en Firebase.

Backend 29bbf07, frontend 869d5b3 y landing 1dc7482 desplegados. Endpoints privados semanales probados únicamente en la iglesia de demostración del revisor: cuatro integrantes ficticios, dos semanas y seis asignaciones. Cuenta de revisión verificada; credenciales entregadas por el formulario Acceso a la app sin copiarlas al repositorio. No se enviaron reportes de prueba a soporte.

Ficha con icono oficial, imagen 1024x500 y cuatro capturas 1080x1920 reales de widgets Flutter con datos ficticios. IARC completado y seguridad de datos guardada. El canal interno no implica aprobación ni publicación pública.

Play confirmó «14 cambios enviados a revisión»: ficha, declaraciones y Alpha 1.0.0 para Perú/Colombia. Comprobaciones automáticas todavía en curso al entregar. No se ha recibido aprobación de Google. La lista cerrada tiene solo el correo del propietario y faltan al menos 12 inscritos reales durante 14 días.
