# SheepLink móvil

Aplicación Flutter para Android e iOS, enfocada en líderes de célula.

- **Hoy**: acceso directo a asistencia y próximos cumpleaños.
- **Mi célula**: integrantes activos, presente/ausente explícitos, fecha, selección de célula cuando corresponde y guardado real en la API.
- **Perfil**: notificaciones y cierre de sesión.

La app usa los permisos y el alcance devueltos por el servidor. Conserva las marcas en memoria si falla el guardado y solicita confirmación antes de descartarlas. No incluye registros de demostración en producción.

## Desarrollo

Requiere Flutter 3.44.5 / Dart 3.12.2 o compatible.

```sh
flutter pub get
flutter run
```

La API predeterminada es `https://dashboard-sheeplink.nexode.app/api`. Para un entorno diferente:

```sh
flutter run --dart-define=API_URL=https://tu-servidor.example/api
```

La sesión usa cookies persistidas mediante almacenamiento seguro del sistema. Nunca se guardan contraseñas. La tipografía Figtree y el símbolo oficial se incluyen localmente con su licencia.

## Notificaciones y Firebase

Proyecto existente: `sheeplink`. Android e iOS registrados como `app.sheeplink.sheeplink`. Los archivos de configuración de cliente están incluidos; no contienen credenciales administrativas.

FCM usa el registro actual mediante `register()` y `onRegistered` con Firebase Installation IDs. El contrato `/notifications/devices` conserva su propiedad `token` por compatibilidad con el backend existente; su valor es el identificador registrado. No se mezclan las APIs nuevas y antiguas de registro.

La activación es voluntaria desde Perfil. Los avisos push se muestran en primer plano mediante un canal Android de importancia alta; el sistema entrega los avisos con la app en segundo plano. Pulsarlos abre Hoy. Los cumpleaños usan notificaciones **locales**, no un job del servidor: se programan a las 9:00 de la zona horaria de la célula con datos sincronizados al abrir, actualizar o cambiar de célula. El horizonte es de 30 días y hasta 60 avisos próximos. No requieren conexión una vez programados, pero cambios posteriores del roster se reflejan en la siguiente sincronización. Android puede retrasarlos por ahorro de batería; no se solicitan alarmas exactas. El 29 de febrero se observa el 28 en años no bisiestos.

En iOS están añadidos el plist, los modos de segundo plano y el entitlement de notificaciones. **Falta cargar una clave APNs del equipo Apple en Firebase y validar con macOS/Xcode y un dispositivo Apple.** No se afirma que push iOS esté probado.

## Firma Android

SHA-1 debug registrada en Firebase:
`D9:E5:F2:5E:85:A9:F5:BC:92:8A:F6:76:F6:D2:33:1A:BD:AC:43:5D`

SHA-1 release registrada en Firebase:
`6F:99:D3:39:DD:E1:E2:5D:71:65:95:9B:79:0C:BA:ED:FF:20:7A:81`

El keystore release está fuera del proyecto, en `%USERPROFILE%/.codex/secrets/sheeplink-release.jks`. Su configuración se guarda cifrada con DPAPI para el usuario de Windows. La compilación release no usa la firma debug:

```sh
python scripts/build_release.py
```

El script descifra los datos solo para el proceso de compilación. No imprime contraseñas. Para otros sistemas se usan las variables `SHEEPLINK_STORE_FILE`, `SHEEPLINK_STORE_PASSWORD`, `SHEEPLINK_KEY_ALIAS` y `SHEEPLINK_KEY_PASSWORD` con el keystore correspondiente. Si se adopta Play App Signing, registrar también la huella del certificado que firme Google Play.

## Validación

```sh
dart format --output=none --set-exit-if-changed lib test integration_test
flutter analyze
flutter test
python scripts/build_release.py
```

Las pruebas de widgets generan capturas en `artifacts/` usando cuentas e integrantes aislados de prueba.

La prueba nativa de FCM está separada porque requiere un emulador Google Play, permiso de notificaciones y envío real desde el proyecto autorizado:

```sh
flutter test integration_test/notifications_test.dart -d emulator-5554
# En otra terminal, cuando la prueba haya registrado su instalación:
python scripts/send_smoke_push.py
```

El envío usa únicamente el identificador temporal de la prueba en el emulador local y la credencial FCM ya guardada fuera del repositorio. No registra un dispositivo en una cuenta real ni envía avisos a integrantes. El identificador no se imprime.

Consulta `docs/architecture.md` para las reglas de organización.

## Icono de la app

El launcher usa el símbolo vectorial oficial de SheepLink sobre verde bosque. Incluye variantes Android tradicionales, adaptativa y monocromática, y todos los tamaños iOS. La configuración reproducible está en flutter_launcher_icons.yaml.

```sh
node scripts/generate-icons.cjs
dart run flutter_launcher_icons
```

El script de arte requiere sharp o el runtime local de Codex. No redibuja el logotipo; compone el vector oficial con margen seguro. El icono pequeño de las notificaciones también usa el símbolo oficial como vector monocromático.

## Acceso con Google

La pantalla inicial ofrece Continuar con Google con selector nativo. El adaptador intercambia la identidad Google por un ID token Firebase y lo envía a POST /auth/google. El backend conserva la autorización sobre la cuenta, la iglesia y los permisos; no se crean cuentas SheepLink desde el cliente. Cancelar el selector no muestra errores. La sesión Firebase temporal se cierra al obtener la identidad: la sesión de SheepLink sigue usando su cookie segura.

Android usa los clientes OAuth de google-services.json y las SHA-1 debug/release ya registradas. iOS incluye GIDClientID, GIDServerClientID y el esquema de retorno correspondiente al plist existente. El acceso de una persona real requiere una cuenta Google asociada a una cuenta SheepLink activa. No se automatiza la introducción de credenciales Google durante las pruebas.


### Reunión semanal y servicio

Mi célula permite navegar semanas, marcar asistencia y adjuntar una foto de cámara o galería. El día habitual es sugerido; la fecha real puede ser cualquier día de esa semana, hasta hoy. El historial y sus fotos privadas se consultan desde la web pastoral (Células → Asistencia). Una semana sin datos no cuenta como ausencia. Backend y web publicados y verificados en producción el 22 de octubre de 2026.

Hoy muestra los turnos personales; Perfil incluye datos, roles, ministerios y preferencias de cumpleaños/servicio. La invitación al entrar puede aplazarse. Los recordatorios se actualizan al abrir la app; iOS continúa pendiente de APNs y validación en macOS.

## Google Play Android — 22 de octubre de 2026

Versión 1.0.0+1, minSdk 24, compile/targetSdk 36, AGP 9.0.1, Gradle 9.1.0 y Java 17. Build firmado: `python scripts/build_release.py --bundle`. Las claves permanecen fuera del repositorio y no se deben regenerar para una actualización.

AAB: `build/app/outputs/bundle/release/app-release.aab`. Validación bundletool 1.18.3 aprobada; empaquetado y ocho bibliotecas nativas de 64 bits alineados a 16 KB. No equivale a una prueba de ejecución en un dispositivo de 16 KB.

Canal interno activo: https://play.google.com/apps/internaltest/4699493667805671464 . Usar la cuenta Google agregada como probador y aceptar participar. Firebase tiene las huellas debug, upload y firma de Google Play; SHA-1/SHA-256 públicas de distribución en `store/release-audit.json`.

Ficha es-419 y recursos en `store/es-419/`; acceso de revisión permanente entregado a Google, con credenciales protegidas fuera del repositorio. IARC y seguridad de datos completados. La publicación pública requiere revisión y acceso a producción tras una prueba cerrada con al menos 12 inscritos durante 14 días consecutivos; añadir correos reales autorizados, no cuentas ficticias.
