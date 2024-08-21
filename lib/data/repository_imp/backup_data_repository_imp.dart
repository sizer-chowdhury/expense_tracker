import 'package:expense_tracker/data/data_source/backup_data_handler.dart';

import '../../domain/repository/backup_data_repository.dart';

class BackupDataRepositoryImp implements BackupDataRepository {
  final BackupDataHandler backupDataHandler;
  BackupDataRepositoryImp(this.backupDataHandler);
  @override
  Future<void> getBackupData() async {
    await backupDataHandler.getBackupData();
  }

  @override
  Future<void> restoreBackupData() async {
    await backupDataHandler.restoreBackupData();
  }
}
