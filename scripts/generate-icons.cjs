const fs = require('node:fs');
const path = require('node:path');
// Use a local sharp installation, or the runtime bundled with Codex on this machine.
let sharp;
try { sharp = require('sharp'); }
catch { sharp = require(path.join(process.env.USERPROFILE, '.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/sharp')); }
const root = path.resolve(__dirname, '..');
const source = path.join(root, 'assets/brand/mark-white.svg');
async function icon(name, ratio, background) {
 const canvas=1024;
 const symbol=await sharp(source).resize(Math.round(canvas*ratio)).png().toBuffer();
 await sharp({create:{width:canvas,height:canvas,channels:4,background}})
   .composite([{input:symbol,gravity:'centre'}]).png().toFile(path.join(root,'assets/brand',name));
}
(async()=>{
 await icon('app-icon.png', .76, '#164f3b');
 await icon('app-icon-foreground.png', .56, '#00000000');
 console.log('Generated launcher artwork from the official SheepLink vector.');
})();
