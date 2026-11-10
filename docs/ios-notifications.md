# Notificaciones iOS

Revisión del 10 de noviembre de 2026:

- Firebase: proyecto `sheeplink`, app iOS `app.sheeplink.sheeplink`, Cloud Messaging V1 habilitado.
- Firebase tiene una clave APNs de producción. En Apple Developer la misma clave está activa, pertenece al equipo `9BZKHZM3ZB` y autoriza exactamente el tema `app.sheeplink.sheeplink`.
- No hay clave de desarrollo en Firebase. La versión de App Store utiliza producción; una futura prueba con firma de desarrollo necesitará la configuración sandbox correspondiente.
- El IPA de la versión publicada 1.0.2 (4) contiene el perfil de distribución con `aps-environment=production`, identidad correcta y vencimiento en noviembre de 2027. Incluye `remote-notification` y no desactiva el proxy de Firebase.

La siguiente versión preparada en el código es 1.0.3 (5). Solicita permiso al activar los avisos, permite volver a ofrecer la invitación a quienes la descartaron antes, registra APNs explícitamente y espera su token antes de registrar la instalación Firebase. El servidor recibe `targetType=fid` explícito. Perfil permite reintentar la activación y distingue el éxito de sincronización del modo de recordatorios locales.

Se actualizó `firebase_messaging` a 17.0.1, que corrige mensajes de iOS descartados al arrancar o entregados más de una vez. Fuente: https://pub.dev/packages/firebase_messaging/changelog

## Validación pendiente con la nueva versión

Esta revisión no demuestra recepción en un iPhone. La configuración no incorpora las correcciones al binario 1.0.2 ya publicado. Después de distribuir la actualización:

1. Instalar la nueva versión e iniciar sesión.
2. Activar notificaciones y aceptar el permiso de iOS. Si se había denegado, habilitarlas en Ajustes de iOS.
3. Comprobar que el servidor guardó la instalación de esa cuenta.
4. Enviar un aviso dirigido únicamente a la cuenta de prueba y comprobar recepción en primer plano, segundo plano y con la app cerrada; comprobar también la apertura al tocarlo.
5. Desactivar los avisos y comprobar la revocación del registro del dispositivo.

No guardar tokens de dispositivos, claves APNs ni credenciales Firebase en documentación, logs o Git.
