import 'package:expense_tracker/data/data_source/backup/google_drive_auth.dart';
import 'package:expense_tracker/data/data_source/backup/backup_data_handler.dart';
import 'package:expense_tracker/data/data_source/backup/download_from_google_drive.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';
import 'dart:io';
import 'package:googleapis/drive/v3.dart' as drive;

class UploadGoogleDrive {
  Future<String?> uploadFileToGoogleDrive(File jsonFile) async {
    try {
      final authClient = await GoogleDriveAuth().getAuthClient();
      if (authClient == null) {
        return 'No auth client found';
      }

      final driveApi = drive.DriveApi(authClient);

      final media = drive.Media(jsonFile.openRead(), jsonFile.lengthSync());

      final fileList = await driveApi.files.list(q: "name = 'data.json'");
      drive.File? exFile;

      if (fileList.files != null && fileList.files!.isNotEmpty) {
        exFile = fileList.files!.first;
      }
      if (exFile != null) {
        final updatedFile = await driveApi.files.update(
          drive.File(),
          exFile.id!,
          uploadMedia: media,
        );
        print('File updated: ${updatedFile.id}');
      } else {
        final driveFile = drive.File()
          ..name = 'data.json'
          ..parents = ['appDataFolder'];
        exFile = await driveApi.files.create(driveFile, uploadMedia: media);
      }
      return null;
    } catch (error) {
      return 'Error uploading file: $error';
    }
  }
}
