import json, pathlib, secrets, subprocess, sys
from signing import transform as _transform
root=pathlib.Path.home()/'.codex/secrets'
meta=root/'sheeplink-android-signing.dpapi'
key=root/'sheeplink-release.jks'
tool=r'C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe'
if not meta.exists():
    password=secrets.token_urlsafe(36)
    import os
    os.environ['SHEEPLINK_SIGN_PASSWORD']=password
    subprocess.run([tool,'-genkeypair','-keystore',str(key),'-alias','sheeplink','-keyalg','RSA','-keysize','3072','-validity','10000','-storepass:env','SHEEPLINK_SIGN_PASSWORD','-keypass:env','SHEEPLINK_SIGN_PASSWORD','-dname','CN=SheepLink, O=SheepLink, C=CO'],check=True,capture_output=True)
    meta.write_bytes(_transform(json.dumps({'storeFile':str(key),'storePassword':password,'keyPassword':password,'keyAlias':'sheeplink'}).encode(),True))
config=json.loads(_transform(meta.read_bytes(),False))
import os
os.environ['SHEEPLINK_SIGN_PASSWORD']=config['storePassword']
for name,path,alias,pw in [('release',config['storeFile'],config['keyAlias'],None),('debug',str(pathlib.Path.home()/'.android/debug.keystore'),'androiddebugkey','android')]:
    args=[tool,'-list','-v','-keystore',path,'-alias',alias]
    args+=['-storepass',pw] if pw else ['-storepass:env','SHEEPLINK_SIGN_PASSWORD']
    result=subprocess.run(args,capture_output=True,text=True,check=True)
    print(name)
    for line in result.stdout.splitlines():
        if 'SHA1:' in line or 'SHA256:' in line: print(line.strip())
