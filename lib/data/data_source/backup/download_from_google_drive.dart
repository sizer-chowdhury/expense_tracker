import 'dart:io';
import 'package:expense_tracker/data/data_source/backup/google_drive_auth.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:path_provider/path_provider.dart';

class DownloadFromGoogleDrive {
  Future<String?> downloadFileFromGoogleDrive() async {
    try {
      final authClient = await GoogleDriveAuth().getAuthClient();
      if (authClient == null) return 'no auth client found';
      final driveApi = drive.DriveApi(authClient);
      final directory = await getApplicationDocumentsDirectory();
      final localFilePath = '${directory.path}/downloaded_data.json';
      final fileList = await driveApi.files.list(q: "name = 'data.json'");
      drive.File? exFile;

      if (fileList.files != null && fileList.files!.isNotEmpty) {
        print('drive files list length: ${fileList.files!.length}');
        exFile = fileList.files!.first;
      }

      final media = await driveApi.files
          .get((exFile?.id)!, downloadOptions: drive.DownloadOptions.fullMedia);

      final file = File(localFilePath);
      final sink = file.openWrite();

      if (media is drive.Media) {
        await for (var chunk in media.stream) {
          sink.add(chunk);
        }
      } else {
        throw Exception('Expected media to be of type drive.Media');
      }

      await sink.flush();
      await sink.close();

      print('File downloaded to: $localFilePath');
      return null;
    } catch (error) {
      return 'Error downloading file: $error';
    }
  }
}
