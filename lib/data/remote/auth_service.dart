import 'package:expenses4/core/constants/app_constants.dart';
import 'package:expenses4/core/shared_references/auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ClsAuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  static Future<void> initialize() async {
    await _googleSignIn.initialize(
      serverClientId:
          '42888525627-ppb6b3tdl5ors8vjub5jc4a4akfurqbj.apps.googleusercontent.com',
    );

    int? currentUserID = await ClsAuthData.getUserID();
    AppConstants.currentUserID = currentUserID ?? -1;

    String? currentUserEmail = await ClsAuthData.getEmailUser();
    AppConstants.currentUserEmail = currentUserEmail;
  }

  static Future<GoogleSignInAccount?> signIn() async {
    try {
      final account = await GoogleSignIn.instance.authenticate();
      return account;
    } catch (e, s) {
      print('ERROR: $e ==================================');
      print('STACK: $s ===================================2');
      return null;
    }
  }

  static Future<void> signOut() async {
    try {
      await _googleSignIn.disconnect();
    } catch (e) {
      print('Google Sign-Out Error: $e');
    }
  }
}
