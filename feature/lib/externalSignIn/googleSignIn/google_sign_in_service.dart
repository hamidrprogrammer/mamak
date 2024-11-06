import 'package:feature/externalSignIn/model/external_sign_in_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'id', 'displayName', 'serverAuthCode'],
  );

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  GoogleSignInAccount? get currentUser => _googleSignIn.currentUser;

  Future<ExternalSignInModel?> getUserData() async {
    if (!(await isAuthorized)) return null;
    await _handleSignIn();
    return ExternalSignInModel(
        name: currentUser?.displayName ?? '',
        email: currentUser?.email ?? '',
        code: currentUser?.serverAuthCode ?? '');
  }

  // Sign out from Google
  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }

  Stream<GoogleSignInAccount?> get onCurrentUserChanged =>
      _googleSignIn.onCurrentUserChanged;

  Future<bool> get isAuthorized async =>
      await _googleSignIn.canAccessScopes(_googleSignIn.scopes);
}
