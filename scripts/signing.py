import ctypes
import json
from pathlib import Path

class Blob(ctypes.Structure):
    _fields_=[('size',ctypes.c_ulong),('data',ctypes.POINTER(ctypes.c_byte))]

def transform(value,protect=False):
    buffer=ctypes.create_string_buffer(value)
    source=Blob(len(value),ctypes.cast(buffer,ctypes.POINTER(ctypes.c_byte)))
    target=Blob()
    library=ctypes.WinDLL('crypt32',use_last_error=True)
    if protect:
        ok=library.CryptProtectData(ctypes.byref(source),'SheepLink signing',None,None,None,1,ctypes.byref(target))
    else:
        ok=library.CryptUnprotectData(ctypes.byref(source),None,None,None,None,1,ctypes.byref(target))
    if not ok: raise ctypes.WinError(ctypes.get_last_error())
    try: return ctypes.string_at(target.data,target.size)
    finally: ctypes.windll.kernel32.LocalFree(target.data)

def configuration():
    return json.loads(transform((Path.home()/'.codex/secrets/sheeplink-android-signing.dpapi').read_bytes()))
