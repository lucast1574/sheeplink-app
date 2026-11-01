"""Validate the identity shared by Xcode, Firebase, Google and the release assets."""
from pathlib import Path
import json
import plistlib
import re
import struct

ROOT = Path(__file__).resolve().parents[1]
RUNNER = ROOT / "ios/Runner"


def validate():
    info = plistlib.loads((RUNNER / "Info.plist").read_bytes())
    firebase = plistlib.loads((RUNNER / "GoogleService-Info.plist").read_bytes())
    entitlements = plistlib.loads((RUNNER / "Runner.entitlements").read_bytes())
    privacy = plistlib.loads((RUNNER / "PrivacyInfo.xcprivacy").read_bytes())
    project = (ROOT / "ios/Runner.xcodeproj/project.pbxproj").read_text()
    assert firebase["BUNDLE_ID"] == "app.sheeplink.sheeplink", "Unexpected Firebase bundle ID"
    bundle_ids = re.findall(r"PRODUCT_BUNDLE_IDENTIFIER = ([^;]+);", project)
    assert bundle_ids and all(x.startswith(firebase["BUNDLE_ID"]) for x in bundle_ids)
    assert info["GIDClientID"] == firebase["CLIENT_ID"], "Google iOS client mismatch"
    assert info["GIDServerClientID"].endswith(".apps.googleusercontent.com")
    schemes = [x for group in info["CFBundleURLTypes"] for x in group["CFBundleURLSchemes"]]
    assert firebase["REVERSED_CLIENT_ID"] in schemes, "Google return URL scheme missing"
    assert info["FirebaseMessagingInstallationIdEnabled"] is True
    assert info["FirebaseMessagingAutoInitEnabled"] is False
    assert info.get("FirebaseAppDelegateProxyEnabled", True) is True, "FCM requires swizzling"
    assert {"fetch", "remote-notification"} <= set(info["UIBackgroundModes"])
    assert entitlements["aps-environment"] == "development", "Xcode sets production during distribution export"
    assert entitlements["keychain-access-groups"], "Secure storage needs Keychain entitlement"
    targets = re.findall(r"IPHONEOS_DEPLOYMENT_TARGET = ([^;]+);", project)
    assert targets and all(float(x) >= 15.0 for x in targets), "Firebase requires iOS 15+"
    assert "DEVELOPMENT_TEAM = 9BZKHZM3ZB;" in project
    assert project.count("PrivacyInfo.xcprivacy in Resources */,") == 1
    assert privacy["NSPrivacyTracking"] is False
    icons = RUNNER / "Assets.xcassets/AppIcon.appiconset"
    entries = json.loads((icons / "Contents.json").read_text())["images"]
    marketing = [x for x in entries if x.get("idiom") == "ios-marketing"]
    assert marketing, "App Store icon missing"
    for entry in entries:
        image = icons / entry["filename"]
        header = image.read_bytes()[:33]
        assert header[:8] == b"\x89PNG\r\n\x1a\n", f"Invalid icon: {image.name}"
        if entry in marketing:
            assert struct.unpack(">II", header[16:24]) == (1024, 1024)
            assert header[25] == 2, "App Store icon must be RGB without an alpha channel"
    print("iOS identity, Firebase, Google return URL, APNs, Keychain and privacy assets: valid")


if __name__ == "__main__":
    validate()
