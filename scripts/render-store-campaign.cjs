const fs=require('node:fs'),path=require('node:path');
let sharp;try{sharp=require('sharp')}catch{sharp=require(path.join(process.env.USERPROFILE,'.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/sharp'))}
const root=path.resolve(__dirname,'../store/campaign-2026-11');
(async()=>{
 const preview=[];
 for(const platform of ['iphone','ipad','android']){
  for(const name of fs.readdirSync(path.join(root,platform)).filter(n=>n.endsWith('.svg'))){
   const source=path.join(root,platform,name),target=source.replace(/\.svg$/,'.png');
   await sharp(source,{limitInputPixels:false}).flatten({background:'#f8faf5'}).removeAlpha().png().toFile(target);
   const meta=await sharp(target).metadata();if(meta.hasAlpha||meta.height<=meta.width)throw Error('Invalid store image '+target);
   if(platform==='iphone')preview.push(await sharp(target).resize(241,524).png().toBuffer());
  }
 }
 await sharp({create:{width:10+preview.length*247,height:544,channels:3,background:'#f8faf5'}}).composite(preview.map((input,i)=>({input,left:10+i*247,top:10}))).png().toFile(path.join(root,'preview-iphone.png'));
 console.log('Portrait PNGs verified, plus contact sheet.');
})();
