import 'package:google_sign_in/google_sign_in.dart';

class LoginApi {
  static final _googleSignIn = GoogleSignIn();
  static Future<GoogleSignInAccount?> loginWithGoogle() =>
      _googleSignIn.signIn();
  static Future signOut() => _googleSignIn.signOut();
}
