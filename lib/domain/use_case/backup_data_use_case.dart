import 'package:expense_tracker/domain/repository/backup_data_repository.dart';

class BackupDataUseCase {
  final BackupDataRepository backupDataRepository;
  BackupDataUseCase(this.backupDataRepository);

  Future<void> getBackupData() async {
    await backupDataRepository.getBackupData();
  }

  Future<void> restoreBackupData() async {
    await backupDataRepository.restoreBackupData();
  }
}
