import base64,json,pathlib,subprocess,sys,time,urllib.request
from signing import transform
adb=str(pathlib.Path.home()/'AppData/Local/Android/Sdk/platform-tools/adb.exe')
# Only the dedicated test file on the local emulator is read. Never log its token.
result=subprocess.run([adb,'-s','emulator-5554','exec-out','run-as','app.sheeplink.sheeplink','cat','code_cache/sheeplink-fcm-smoke.token'],capture_output=True)
if result.returncode: raise SystemExit('The native notification test is not ready yet.')
token=result.stdout.decode().strip()
if not (20<=len(token)<=200 and all(c.isalnum() or c in '-_:' for c in token)): raise SystemExit('No valid test identifier was found; no push was sent.')
account=json.loads(transform((pathlib.Path.home()/'.codex/secrets/sheeplink-fcm.dpapi').read_bytes()))
def enc(value):return base64.urlsafe_b64encode(json.dumps(value,separators=(',',':')).encode()).decode().rstrip('=')
now=int(time.time())
unsigned=enc({'alg':'RS256','typ':'JWT'})+'.'+enc({'iss':account['client_email'],'scope':'https://www.googleapis.com/auth/firebase.messaging','aud':account['token_uri'],'iat':now,'exp':now+3600})
command="$data=[Console]::In.ReadToEnd()|ConvertFrom-Json; $rsa=[System.Security.Cryptography.RSA]::Create(); $rsa.ImportFromPem($data.key); $sig=$rsa.SignData([Text.Encoding]::UTF8.GetBytes($data.value),[System.Security.Cryptography.HashAlgorithmName]::SHA256,[System.Security.Cryptography.RSASignaturePadding]::Pkcs1); [Console]::Out.Write([Convert]::ToBase64String($sig)); $rsa.Dispose()"
signed=subprocess.run(['pwsh','-NoProfile','-Command',command],input=json.dumps({'key':account['private_key'],'value':unsigned}),capture_output=True,text=True,check=True).stdout.strip()
assertion=unsigned+'.'+signed.replace('+','-').replace('/','_').rstrip('=')
import urllib.parse
body=urllib.parse.urlencode({'grant_type':'urn:ietf:params:oauth:grant-type:jwt-bearer','assertion':assertion}).encode()
with urllib.request.urlopen(urllib.request.Request(account['token_uri'],data=body),timeout=30) as response: access=json.load(response)['access_token']
payload={'message':{'fid':token,'notification':{'title':'SheepLink · prueba técnica','body':'Los avisos de tu comunidad están listos.'},'data':{'url':'/','type':'test'},'android':{'priority':'high','notification':{'channel_id':'sheeplink_care','icon':'ic_notification','visibility':'PRIVATE'}}}}
request=urllib.request.Request('https://fcm.googleapis.com/v1/projects/sheeplink/messages:send',data=json.dumps(payload).encode(),headers={'Authorization':'Bearer '+access,'Content-Type':'application/json'})
try:
 with urllib.request.urlopen(request,timeout=30) as response:
  data=json.load(response);print('FCM accepted a test notification for the local emulator:',bool(data.get('name')))
except urllib.error.HTTPError as error:
 details=json.loads(error.read()).get('error',{});print('FCM returned HTTP',error.code,'status',details.get('status'),'codes',[item.get('errorCode') for item in details.get('details',[])]);raise SystemExit(1)

