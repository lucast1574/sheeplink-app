"""Restore SheepLink's app resources after the Linux Flutter wrapper build."""
import pathlib
import plistlib
import shutil
import sys

root = pathlib.Path(__file__).resolve().parents[1]
bundle = pathlib.Path(sys.argv[1]).resolve()
info = plistlib.loads((bundle / "Info.plist").read_bytes())
firebase = plistlib.loads((root / "ios/Runner/GoogleService-Info.plist").read_bytes())
source = plistlib.loads((root / "ios/Runner/Info.plist").read_bytes())
if info.get("CFBundleIdentifier") != firebase["BUNDLE_ID"]:
    raise SystemExit("The built app does not match SheepLink's Firebase bundle.")
if info.get("GIDClientID") != firebase["CLIENT_ID"]:
    raise SystemExit("The built app has a different Google iOS client.")
if info.get("GIDServerClientID") != source["GIDServerClientID"]:
    raise SystemExit("The built app has a different Google server client.")
schemes = [scheme for item in info.get("CFBundleURLTypes", [])
           for scheme in item.get("CFBundleURLSchemes", [])]
if firebase["REVERSED_CLIENT_ID"] not in schemes:
    raise SystemExit("The built app is missing Google's return URL scheme.")
if "remote-notification" not in info.get("UIBackgroundModes", []):
    raise SystemExit("The built app is missing the remote notification background mode.")
for name in ("GoogleService-Info.plist", "PrivacyInfo.xcprivacy"):
    source_path = root / "ios/Runner" / name
    shutil.copy2(source_path, bundle / name)
    if (bundle / name).read_bytes() != source_path.read_bytes():
        raise SystemExit(f"The built app is missing {name}.")
print("Linux bundle: Firebase configuration, Google callback and privacy manifest verified.")
