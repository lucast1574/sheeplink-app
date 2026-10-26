import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract interface class GoogleIdentity {
  /// A cancelled account picker returns null without creating a backend session.
  Future<String?> firebaseIdToken();
}

class FirebaseGoogleIdentity implements GoogleIdentity {
  Future<void>? _initialization;

  @override
  Future<String?> firebaseIdToken() async {
    await Firebase.initializeApp();
    final google = GoogleSignIn.instance;
    await (_initialization ??= google.initialize());
    try {
      final account = await google.authenticate();
      final googleToken = account.authentication.idToken;
      if (googleToken == null) {
        throw StateError('Google did not return an identity.');
      }
      final result = await FirebaseAuth.instance.signInWithCredential(
        GoogleAuthProvider.credential(idToken: googleToken),
      );
      final token = await result.user?.getIdToken();
      if (token == null) {
        throw StateError('Firebase did not return an identity.');
      }
      return token;
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) return null;
      rethrow;
    } finally {
      // SheepLink owns the session cookie. Do not keep a second Firebase session.
      await FirebaseAuth.instance.signOut();
      await google.signOut();
    }
  }
}
