# SheepLink · recorrido para las tiendas

Seis composiciones verticales en español: bienvenida, hoy, asistencia, reunión semanal, servicio y comunidad. Logo oficial intacto; Figtree de assets/fonts; paleta de la landing y la app. Las cuatro pantallas de producto son capturas Flutter existentes con datos ficticios, sin inventar controles ni funciones. Las dos ilustraciones editoriales se generaron con la herramienta integrada image_gen.

## Entregables

- iphone: 6 PNG RGB de 1206 × 2622.
- ipad: 6 PNG RGB de 2064 × 2752, con capturas nativas de iPad.
- android: 6 PNG RGB de 1080 × 1920, con capturas Android.
- SVG autocontenidos por plataforma, texto trazado para conservar Figtree sin instalar fuentes.
- assets: ilustraciones fuente.
- preview-iphone.png: vista general.
- manifest.json: dimensiones y procedencia de cada pantalla.

Orden: 01 bienvenida, 02 hoy, 03 asistencia, 04 semana, 05 servicio, 06 comunidad. No son pantallas de onboarding dentro de la app: son piezas para la ficha de la tienda.

## Regeneración

Desde la raíz de sheeplink-app:

    python -m pip install fonttools
    python scripts/render-store-campaign.py
    node scripts/render-store-campaign.cjs

El segundo script requiere sharp. Los originales de las capturas no se modifican. El archivo de fuente Figtree y los recursos originales deben seguir en sus rutas del repositorio.

## Dirección y prompts de ilustración

1. Comunidad: ilustración editorial premium de papel recortado con textura, siete adultos latinoamericanos de edades diversas reunidos en un patio con jardín; conversación, bienvenida y cuidado comunitario. Verdes bosque #164f3b, profundo #103c2e, hoja #c8dbac, papel #f8faf5, tinta #203c31, blanco y tonos de piel naturales. Sin texto, marcas, pantallas ni estereotipos religiosos.
2. Preparación: mismo lenguaje de papel recortado, tres voluntarios latinoamericanos organizando un encuentro alrededor de una mesa con planificador vacío, cuaderno, tazas y planta. Misma paleta y restricciones; sin texto, UI ni promesas ficticias.

La generación raster se hizo con image_gen integrado, no con una API o CLI externa. El logo y la tipografía se montan desde los archivos oficiales, no se generan con IA.

## Estado en Apple

Cargadas como borradores en la Biblioteca de componentes. No se ha cambiado la ficha pública ni enviado otra versión de la app. Para iPad usar las portadas con nombre ipad-01-bienvenida-final.png e ipad-06-comunidad-final.png; las portadas originales anteriores de iPad quedaron como borradores superados, sin aplicar. Android está preparado localmente para la futura publicación.
