abstract class BackupDataRepository {
  Future<void> getBackupData();
  Future<void> restoreBackupData();
}
