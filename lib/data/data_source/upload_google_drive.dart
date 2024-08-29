import 'package:expense_tracker/data/data_source/backup_data_handler.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';
import 'dart:io';
import 'package:googleapis/drive/v3.dart' as drive;

class UploadGoogleDrive {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['https://www.googleapis.com/auth/drive.file'],
  );

  Future<GoogleSignInAccount?> _signIn() async {
    try {
      return await _googleSignIn.signIn();
    } catch (error) {
      print('Error signing in: $error');
      return null;
    }
  }

  Future<AuthClient?> _getAuthClient() async {
    final account = await _signIn();
    if (account == null) return null;

    final authentication = await account.authentication;
    final accessToken = authentication.accessToken;

    final authClient = authenticatedClient(
      http.Client(),
      AccessCredentials(
        AccessToken('Bearer', accessToken!,
            DateTime.now().add(Duration(seconds: 3600))),
        null,
        ['https://www.googleapis.com/auth/drive.file'],
      ),
    );

    return authClient;
  }

  Future<void> uploadFileToGoogleDrive(File jsonFile) async {
    final authClient = await _getAuthClient();
    if (authClient == null) return;

    final driveApi = drive.DriveApi(authClient);

    final media = drive.Media(jsonFile.openRead(), jsonFile.lengthSync());
    final driveFile = drive.File()
      ..name = 'data.json'
      ..parents = ['appDataFolder'];

    try {
      final result = await driveApi.files.create(driveFile, uploadMedia: media);
      print('File uploaded: ${result.id}');
    } catch (error) {
      print('Error uploading file: $error');
    }
  }

  Future<void> uploadJsonExample() async {
    final jsonFile = File(BackupDataHandler.vpath!);
    await uploadFileToGoogleDrive(jsonFile);
  }
}
