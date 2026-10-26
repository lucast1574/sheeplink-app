const fs=require('node:fs');const path=require('node:path');
let sharp;try{sharp=require('sharp')}catch{sharp=require(path.join(process.env.USERPROFILE,'.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/sharp'))}
const root=path.resolve(__dirname,'..'),out=path.join(root,'store','es-419');fs.mkdirSync(out,{recursive:true});
(async()=>{
 await sharp(path.join(root,'assets/brand/app-icon.png')).resize(512,512).png().toFile(path.join(out,'icon-512.png'));
 const mark=fs.readFileSync(path.join(root,'assets/brand/mark-white.svg'),'utf8').replace(/<\?xml[^>]*>/,'');
 const inner=mark.replace(/<svg[^>]*>/,'').replace('</svg>','');
 const feature=`<svg xmlns="http://www.w3.org/2000/svg" width="1024" height="500" viewBox="0 0 1024 500"><rect width="1024" height="500" fill="#164f3b"/><path d="M780 35c-170 70-210 340-60 405m170-405c-170 70-210 340-60 405" fill="none" stroke="#c8dbac" stroke-opacity=".13" stroke-width="2"/><g color="#c8dbac" transform="translate(705 125) scale(.28)">${inner}</g><text x="90" y="138" font-family="Figtree,Arial" font-size="24" font-weight="600" letter-spacing="2" fill="#c8dbac">SHEEPLINK</text><text x="85" y="236" font-family="Figtree,Arial" font-size="66" font-weight="600" fill="#f8faf5">Tu comunidad,</text><text x="85" y="310" font-family="Figtree,Arial" font-size="66" font-weight="600" fill="#f8faf5">más cerca.</text><text x="90" y="386" font-family="Figtree,Arial" font-size="22" fill="#dce7d5">Asistencia, cumpleaños y servicio.</text></svg>`;
 await sharp(Buffer.from(feature)).flatten({background:'#164f3b'}).removeAlpha().png().toFile(path.join(out,'feature-1024x500.png'));
 for(const name of ['01-hoy','02-asistencia','03-semana','04-perfil'])await sharp(path.join(root,'artifacts',`play-${name}.png`)).resize(1080,1920).flatten({background:'#f8faf5'}).removeAlpha().png().toFile(path.join(out,`screenshot-${name}.png`));
 console.log('Store artwork generated: 512 icon, 1024x500 feature graphic, four 1080x1920 UI screenshots.');
})();
