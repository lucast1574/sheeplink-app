"""Build editable, platform-specific store artwork using genuine app captures.

Requires fonttools (Figtree text is outlined for portable SVG output).
Rasterize the SVGs with render-store-campaign.cjs.
"""
from pathlib import Path
import base64
import json
from fontTools.ttLib import TTFont
from fontTools.varLib.instancer import instantiateVariableFont
from fontTools.pens.svgPathPen import SVGPathPen

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'store/campaign-2026-11'
FOREST, DEEP, LEAF, PAPER, INK, WHITE = '#164f3b', '#103c2e', '#c8dbac', '#f8faf5', '#203c31', '#ffffff'
font = TTFont(ROOT / 'assets/fonts/Figtree.ttf')
fonts = {w: instantiateVariableFont(font, {'wght': w}, inplace=False) for w in (500, 700)}

def text(value, x, y, size, color, weight=700, center=False):
    f = fonts[weight]; glyphs = f.getGlyphSet(); cmap = f.getBestCmap()
    scale = size / f['head'].unitsPerEm
    width = sum(f['hmtx'][cmap[ord(c)]][0] for c in value) * scale
    if center: x -= width / 2
    paths = []; offset = 0
    for c in value:
        name = cmap[ord(c)]; pen = SVGPathPen(glyphs); glyphs[name].draw(pen)
        paths.append(f'<path transform="translate({offset} 0)" d="{pen.getCommands()}"/>')
        offset += f['hmtx'][name][0]
    return f'<g fill="{color}" transform="translate({x} {y}) scale({scale} {-scale})">{"".join(paths)}</g>'

def uri(path):
    mime = 'image/svg+xml' if path.suffix == '.svg' else ('image/jpeg' if path.suffix == '.jpg' else 'image/png')
    return f'data:{mime};base64,' + base64.b64encode(path.read_bytes()).decode()

def image(path, x, y, w, h, fit='xMidYMid meet', extra=''):
    return f'<image x="{x}" y="{y}" width="{w}" height="{h}" href="{uri(path)}" preserveAspectRatio="{fit}" {extra}/>'

slides = [
    ('01-bienvenida', 'BIENVENIDO A SHEEPLINK', ['Tu comunidad,', 'más cerca.'], ['Un espacio para cuidar y organizar', 'la vida de tu iglesia.'], None, FOREST),
    ('02-hoy', 'LO IMPORTANTE, A LA MANO', ['Empieza el día', 'con claridad.'], ['Cumpleaños, reuniones y servicio.', 'Lo que necesitas, en un mismo lugar.'], '01-hoy', FOREST),
    ('03-asistencia', 'CADA PERSONA CUENTA', ['Acompaña a', 'tu célula.'], ['Consulta sus integrantes y registra', 'la asistencia de cada reunión.'], '02-asistencia', PAPER),
    ('04-semana', 'UNA COMUNIDAD PRESENTE', ['Dale espacio', 'a cada encuentro.'], ['Organiza la reunión de tu célula', 'y guarda la foto de la semana.'], '03-semana', LEAF),
    ('05-servicio', 'TU LUGAR EN LA COMUNIDAD', ['Prepárate para', 'servir.'], ['Consulta tus ministerios, funciones', 'y próximas asignaciones.'], '04-perfil', DEEP),
    ('06-comunidad', 'HECHO PARA TU COMUNIDAD', ['Más tiempo para', 'estar cerca.'], ['Una herramienta para los líderes', 'y equipos de tu iglesia.'], None, FOREST),
]
formats = {'iphone': (1206,2622,'ios', ROOT/'store/ios/es-MX'), 'ipad':(2064,2752,'ios-ipad',ROOT/'store/ios/es-MX'), 'android':(1080,1920,'play',ROOT/'artifacts')}
manifest = []
for platform,(width,height,prefix,captures) in formats.items():
    folder = OUT/platform; folder.mkdir(parents=True,exist_ok=True)
    H = height/width*1206; tablet = platform == 'ipad'; compact = platform == 'android'
    for index,(name,label,title,body,capture,bg) in enumerate(slides):
        dark = bg in (FOREST,DEEP); fg = PAPER if dark else INK; subtle = LEAF if dark else FOREST
        s = [f'<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="{width}" height="{height}" viewBox="0 0 1206 {H}"><rect width="1206" height="{H}" fill="{bg}"/>']
        if capture is None:
            s += [text('BIENVENIDO A' if index == 0 else label,603,H*.09,27,LEAF,500,True),image(ROOT/'../sheeplink-landing/public/brand/sheeplink-logo-white.svg',203 if tablet else 170,H*(.12 if tablet else .14),800 if tablet else 866,180 if tablet else 236)]
            for j,line in enumerate(title): s.append(text(line,603,H*.33+j*104,94,PAPER,700,True))
            for j,line in enumerate(body): s.append(text(line,603,H*.45+j*43,32,LEAF,500,True))
            y = H*.53
            s.append(f'<defs><clipPath id="art"><rect x="40" y="{y}" width="1126" height="{H-y-40}" rx="56"/></clipPath></defs>')
            s.append(image(OUT/('assets/community.png' if index == 0 else 'assets/planning.png'),40,y,1126,H-y-40,'xMidYMid slice','clip-path="url(#art)"'))
        else:
            top = 94 if compact or tablet else 128; fs = 78 if tablet else 96; leading = fs*1.05
            s.append(text(label,92,top,25,subtle,500))
            for j,line in enumerate(title): s.append(text(line,86,top+130+j*leading,fs,fg))
            by = top+130+leading+88
            for j,line in enumerate(body): s.append(text(line,92,by+j*43,31,fg,500))
            y = by+112; available = H-y-120
            source = captures/f'{prefix}-{capture}{".png" if platform == "android" else ".jpg"}'
            # Genuine screenshots, proportionally scaled, with no invented controls.
            ratio = (2064/2752) if tablet else ((1080/1920) if compact else (1206/2622))
            sh = available; sw = sh*ratio; x=(1206-sw)/2
            s += [f'<rect x="{x-16}" y="{y-16}" width="{sw+32}" height="{sh+32}" rx="{36 if tablet else 64}" fill="{INK}"/>',f'<defs><clipPath id="screen"><rect x="{x}" y="{y}" width="{sw}" height="{sh}" rx="{25 if tablet else 48}"/></clipPath></defs>',image(source,x,y,sw,sh,extra='clip-path="url(#screen)"')]
            s.append(text('SHEEPLINK',92,H-43,22,subtle,700))
            for k in range(len(slides)): s.append(f'<circle cx="{970+k*26}" cy="{H-52}" r="{6 if k==index else 3}" fill="{subtle}"/>')
        s.append('</svg>'); (folder/f'{name}.svg').write_text(''.join(s),encoding='utf-8')
        manifest.append({'platform':platform,'file':name+'.png','width':width,'height':height,'title':' '.join(title),'genuineCapture':str(source.relative_to(ROOT)) if capture else None})
(OUT/'manifest.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(f'{len(manifest)} editable SVG compositions generated.')
