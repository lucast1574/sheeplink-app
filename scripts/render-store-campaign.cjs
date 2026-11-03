const fs=require('node:fs'),path=require('node:path');
let sharp;try{sharp=require('sharp')}catch{sharp=require(path.join(process.env.USERPROFILE,'.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/sharp'))}
const root=path.resolve(__dirname,'../store/campaign-2026-11');
(async()=>{
 for(const platform of ['iphone','ipad','android']){
  const preview=[];
  for(const name of fs.readdirSync(path.join(root,platform)).filter(n=>n.endsWith('.svg'))){
   const source=path.join(root,platform,name),target=source.replace(/\.svg$/,'.png');
   await sharp(source,{limitInputPixels:false}).flatten({background:'#f8faf5'}).removeAlpha().png().toFile(target);
   const meta=await sharp(target).metadata();if(meta.hasAlpha||meta.height<=meta.width)throw Error('Invalid store image '+target);
   preview.push(await sharp(target).resize({height:524}).png().toBuffer());
  }
  let left=10;const composite=[];
  for(const input of preview){const m=await sharp(input).metadata();composite.push({input,left,top:10});left+=m.width+6;}
  await sharp({create:{width:left+4,height:544,channels:3,background:'#f8faf5'}}).composite(composite).png().toFile(path.join(root,`preview-${platform}.png`));
 }
 console.log('Portrait PNGs verified, plus contact sheet.');
})();
