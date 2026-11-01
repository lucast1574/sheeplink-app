# Google Sign-In iOS compatibility patch

Runtime source copied from google_sign_in_ios 6.3.8, published by flutter.dev under the included BSD license. Dart and Swift implementation are unchanged.

Firebase Apple SDK 13 requires GTMSessionFetcher 4 or 5 and AppCheckCore 12. The upstream Flutter package still requires GoogleSignIn 9.x, whose SwiftPM constraints are incompatible. This copy pins the official GoogleSignIn 10.1.0 release and matches its iOS 15/macOS 12 deployment minimums in both native manifests. Remove the override when an upstream Flutter package supports that release.

Sources:
- https://pub.dev/packages/google_sign_in_ios/versions/6.3.8
- https://github.com/google/GoogleSignIn-iOS/blob/10.1.0/CHANGELOG.md
- https://firebase.google.com/support/release-notes/ios
