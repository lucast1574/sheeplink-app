# Mi célula: tres espacios de trabajo

Implementación para 1.0.9 (12). Mantiene los servicios y permisos existentes.

## Organización

- Asistencia: fecha del encuentro, marcas individuales, quitar una marca, marcar pendientes como ausentes, tema con su guardado independiente y foto semanal con todas sus acciones originales.
- Planificador: fecha, preparar próxima célula, título editable, actividades desplegables con responsable y descripción, selección de actividades de la reunión y configuración de las habituales. Mantiene orden, participantes de otras células, versiones y validación del API.
- Integrantes: lista, búsqueda con limpieza explícita y alta de registros de miembros. El alta no crea usuarios ni envía invitaciones. Nombre obligatorio y correo, edad y cumpleaños opcionales. Los permisos siguen decidiendo qué acciones se muestran.
- La célula se cambia desde su nombre en la cabecera cuando hay varias disponibles.

## Salidas y conservación de datos

- Las tres pestañas y Mi célula permanecen montadas al cambiar de tarea o de navegación principal. Se conservan asistencia, tema, planificador y la búsqueda.
- Cambiar fecha, célula o refrescar requiere confirmación si hay cambios. Cancelar un selector no confirma ni descarta borradores.
- Fecha: un solo panel con calendario, navegación de semanas, preparar próxima célula, aplicar, cancelar y cierre visible. Escape, atrás, arrastre y toque fuera conservan la fecha actual.
- Responsables: selector existente con cierre visible, cancelación y Sin asignar. Actividades: selección de borrador; cancelar mantiene lo anterior y Aplicar actualiza la selección.
- Campos: Listo, toque fuera y arrastre quitan el teclado. Cambiar de pestaña desenfoca. Los apartados desplegables también desenfocan al abrir/cerrar.
- Integrante: atrás y Cancelar protegen cambios. Los campos opcionales conservan valores al plegarse; una validación inválida vuelve a abrir el apartado y lleva al error.
- Guardar queda fijo en pantallas con espacio suficiente. En áreas muy bajas (horizontal con teclado/texto grande), la acción entra en el contenido desplazable para mantener accesibles campos y salidas, sin solapamientos.
- Los errores de red conservan los formularios para reintentar. El tema también participa en el aviso de cambios sin guardar y en la protección frente al refresco al volver del segundo plano.

## Validación

- flutter test --no-pub: 87 pruebas aprobadas.
- flutter analyze --no-pub: sin incidencias.
- python scripts/check_ios_configuration.py: configuración válida.
- Capturas de widgets Flutter reales, con datos ficticios: asistencia.png, planificador.png e integrantes.png.
- Pruebas con 320×640, 390×844, 844×390 y 1024×768; texto a 1.5 y teclado simulado.
- Se mantienen es/en/pt y sus mensajes generados.

Las pruebas de interfaz usan Flutter Test con repositorios simulados. No equivalen a una sesión en un iPhone o Android físico ni a una aprobación de las tiendas. Esta implementación no envía una nueva versión a App Store Connect ni Google Play.
