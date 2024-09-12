import 'package:expense_tracker/data/data_source/backup/backup_data_handler.dart';

import '../../domain/repository/backup_data_repository.dart';

class BackupDataRepositoryImp implements BackupDataRepository {
  final BackupDataHandler backupDataHandler;
  BackupDataRepositoryImp(this.backupDataHandler);
  @override
  Future<String?> getBackupData() async {
    return await backupDataHandler.getBackupData();
  }

  @override
  Future<String?> restoreBackupData() {
    return backupDataHandler.restoreBackupData();
  }
}
