import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class GoogleDriveAuth {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'https://www.googleapis.com/auth/drive',
      'https://www.googleapis.com/auth/drive.appdata',
    ],
  );

  Future<GoogleSignInAccount?> _signIn() async {
    try {
      var res = await _googleSignIn.signIn();
      print('client id: $res');

      return res;
    } catch (error) {
      print('Error signing in: $error');
      return null;
    }
  }

  Future<AuthClient?> getAuthClient() async {
    final account = await _signIn();
    if (account == null) return null;

    final authentication = await account.authentication;
    final accessToken = authentication.accessToken;

    final authClient = authenticatedClient(
      http.Client(),
      AccessCredentials(
        AccessToken(
          'Bearer',
          accessToken!,
          DateTime.now().toUtc(),
        ),
        null,
        [
          'https://www.googleapis.com/auth/drive.file',
          'https://www.googleapis.com/auth/drive.appdata',
        ],
      ),
    );

    return authClient;
  }
}
