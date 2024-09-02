import 'package:expense_tracker/domain/repository/backup_data_repository.dart';

class BackupDataUseCase {
  final BackupDataRepository backupDataRepository;
  BackupDataUseCase(this.backupDataRepository);

  Future<String?> getBackupData() async {
    return await backupDataRepository.getBackupData();
  }

  Future<String?> restoreBackupData() async {
    return await backupDataRepository.restoreBackupData();
  }
}
