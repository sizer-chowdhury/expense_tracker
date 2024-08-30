import 'package:expense_tracker/data/data_source/backup_data_handler.dart';
import 'package:expense_tracker/data/data_source/restore_data.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';
import 'dart:io';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:path_provider/path_provider.dart';

class UploadGoogleDrive {
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

  Future<AuthClient?> _getAuthClient() async {
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

  Future<void> uploadFileToGoogleDrive(File jsonFile) async {
    final authClient = await _getAuthClient();
    if (authClient == null) {
      print('Failed to authenticate client.');
      return;
    }

    final driveApi = drive.DriveApi(authClient);

    final media = drive.Media(jsonFile.openRead(), jsonFile.lengthSync());
    final driveFile = drive.File()
      ..name = 'data.json'
      ..parents = ['appDataFolder'];

    try {
      final result = await driveApi.files.create(driveFile, uploadMedia: media);
      print('File uploaded: ${result.id}');
      print('File name: ${result.name}');
      print('File mime type: ${result.mimeType}');
      final gDrive = DownloadGoogleDrive(authClient);
      final directory = await getApplicationDocumentsDirectory();
      final localFilePath = '${directory.path}/downloaded_data.json';
      gDrive.downloadFileFromGoogleDrive(result.id!, localFilePath);
      print(directory.path);
      BackupDataHandler().restoreBackupData();
    } catch (error) {
      print('Error uploading file: $error');
    }
  }

  Future<void> uploadJsonExample() async {
    final jsonFile = File(BackupDataHandler.filePath!);
    await uploadFileToGoogleDrive(jsonFile);
  }
}
