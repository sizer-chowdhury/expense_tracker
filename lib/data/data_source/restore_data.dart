import 'dart:io';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';

class DownloadGoogleDrive {
  final AuthClient _authClient;

  DownloadGoogleDrive(this._authClient);

  Future<void> downloadFileFromGoogleDrive(
    String fileId,
    String localPath,
  ) async {
    final driveApi = drive.DriveApi(_authClient);

    try {
      // Create a request to get the file content
      final media = await driveApi.files
          .get(fileId, downloadOptions: drive.DownloadOptions.fullMedia);

      // Handle the response as a stream of data
      final file = File(localPath);
      final sink = file.openWrite();

      // Ensure media is a Stream
      if (media is drive.Media) {
        await for (var chunk in media.stream) {
          sink.add(chunk);
        }
      } else {
        throw Exception('Expected media to be of type drive.Media');
      }

      await sink.flush();
      await sink.close();

      print('File downloaded to: $localPath');
    } catch (error) {
      print('Error downloading file: $error');
    }
  }
}
