import os
from pathlib import Path
import shutil
import subprocess
import sys
from signing import configuration

config=configuration()
environment=os.environ.copy()
for field,key in [('storeFile','SHEEPLINK_STORE_FILE'),('storePassword','SHEEPLINK_STORE_PASSWORD'),('keyAlias','SHEEPLINK_KEY_ALIAS'),('keyPassword','SHEEPLINK_KEY_PASSWORD')]:
    environment[key]=config[field]
flutter=shutil.which('flutter') or r'C:\flutter\flutter\bin\flutter.bat'
arguments=sys.argv[1:]
artifact='appbundle' if '--bundle' in arguments else 'apk'
arguments=[value for value in arguments if value!='--bundle']
result=subprocess.run([flutter,'build',artifact,'--release',*arguments],cwd=Path(__file__).resolve().parents[1],env=environment)
raise SystemExit(result.returncode)
