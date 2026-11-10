# Desarrollo móvil SheepLink

- Todo campo de texto debe permitir salir: toque fuera, arrastre del scroll, acción Listo del teclado y botón visible para ocultarlo. Desenfocar antes de cambiar de pestaña o navegar. Nunca bloquear atrás o los gestos por un teclado abierto.
- Formularios largos: scroll con viewInsets, controles accesibles sobre el teclado y borradores protegidos al volver.
- Navegación secundaria con Navigator y AppBar atrás; conservar gesto iOS y botón/gesto Android. No cerrar la app para volver de una pantalla secundaria.
- No solicitar cámara o galería al iniciar: pedir acceso al usar la función; comunicar denegaciones y cómo habilitarlas en Ajustes. El selector de fotos de iOS puede funcionar sin acceso global a la fototeca.
