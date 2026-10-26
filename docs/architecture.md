# Organización Flutter

Se mantiene la organización híbrida de la skill oficial de Flutter:
https://github.com/flutter/agent-plugins/blob/main/skills/flutter-apply-architecture-best-practices/SKILL.md

- `app/`: composición y selección entre acceso y comunidad.
- `domain/models/`: modelos de sesión, célula e integrante; regla pura de próximo cumpleaños.
- `data/services/`: transporte HTTP, cookies seguras y adaptador de notificaciones Firebase/locales.
- `data/repositories/`: contrato de acceso a datos y adaptador a la API existente.
- `ui/core/`: tema, iconos SVG y feedback compartido.
- `ui/features/`: acceso, comunidad y perfil; vistas separadas del ViewModel de asistencia.

La entrada compone las dependencias por constructor. Las vistas no hacen solicitudes HTTP. CommunityViewModel coordina carga, borrador y guardado; la API sigue validando permisos y pertenencia a iglesia/célula. NotificationService encapsula efectos de plataforma. Las reglas puras de cumpleaños no dependen de Firebase ni Flutter.

SOLID: contrato de repositorio sustituible en pruebas; presentación separada de transporte y efectos. KISS: ChangeNotifier/Listenable del SDK, sin contenedor global, generadores ni casos de uso vacíos. DRY: tema, estados visuales, iconos y contratos compartidos; sin replicar los módulos administrativos del frontend en el menú móvil.

Fuentes revisadas: los clones vecinos de `lucast1574/sheeplink-landing`, `CarlloAndre/iglesia-frontend` y `CarlloAndre/iglesia-backend`. La API existente maneja `/auth/login`, `/auth/me`, `/auth/logout`, `/cells`, `/members`, `/attendances` y `/notifications/devices`. El cliente conserva las cookies HttpOnly y envía X-Requested-With. No se modifica el backend ni se publica un despliegue con este trabajo.

Documentación Firebase vigente consultada:
https://firebase.google.com/docs/cloud-messaging/flutter/get-started
https://firebase.google.com/docs/cloud-messaging/flutter/receive-messages

Estilo de código: https://dart.dev/effective-dart. Archivos snake_case, tipos UpperCamelCase, miembros lowerCamelCase, null safety, modelos inmutables, format y flutter_lints. Las pruebas cubren permisos, asistencia incompleta, guardado fallido, limpieza de sesión, calendario y navegación a tamaño móvil.


## Semana y reunión

La identidad es célula + lunes de la semana, con índice único por iglesia/célula/semana. La fecha real es independiente de meetingDay (día habitual configurable). Se elige una fecha pasada o actual dentro de lunes-domingo antes del primer guardado; queda anclada para que reintentos no creen otra reunión. La foto se prepara fuera del hilo UI, elimina EXIF, se limita a 1280 px/500 KB y se almacena en S3 privado, no en MongoDB. Solo se accede mediante sesión y alcance autorizado. Cada semana tiene su propia referencia.

La asistencia mantiene el contrato existente. Si el segundo paso (metadatos/foto) falla, el modelo conserva el borrador y explica que la asistencia sí se guardó. No representa una transacción entre ambas peticiones. Los registros diarios anteriores se conservan y el reporte indica que sus totales son presencias registradas. Las semanas sin datos se excluyen del porcentaje: no se infiere cancelación ni ausencia. No existe todavía un estado explícito de reunión cancelada ni historial de cambios del día habitual.

## Avisos y servicio

El perfil personal se obtiene de /personal incluso sin permisos de gestión de células. Los turnos se leen del calendario real; solo los confirmados y sin restricciones generan avisos locales. Plan único ordenado de hasta 60 avisos/31 días: cumpleaños a las 09:00, servicio a las 19:00 del día anterior y dos horas antes (como mínimo medianoche del mismo día). Se actualiza al abrir/refrescar; cambios remotos no cancelan un aviso local hasta sincronizar. Se usa programación inexacta de Android, sujeta al ahorro de batería. Preferencias por tipo e invitación inicial persistida, con opción Ahora no. FCM permanece para avisos del servidor.


## Avatar

La sesión incluye photoUrl. El cambio de foto reutiliza PATCH /personal/profile y el mismo preparador de imágenes de las reuniones. Las fotos privadas usan el cliente autenticado; Google utiliza un cliente aislado sin cookies ni redirecciones. La URL procede del claim picture del token Firebase verificado y se restringe a HTTPS en subdominios googleusercontent.com. La foto elegida por el usuario tiene prioridad; la URL de Google se actualiza en cada acceso de Google sin sobrescribirla.
