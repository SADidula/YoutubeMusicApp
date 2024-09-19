import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/youtube/v3.dart';

class UserController {
  static final googleSignIn = GoogleSignIn(
    scopes: <String>[YouTubeApi.youtubeScope],
  );

  static Future<GoogleSignInAccount?> loginWithGoogle() =>
      googleSignIn.signIn();
}
