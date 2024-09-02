abstract class BackupDataRepository {
  Future<String?> getBackupData();
  Future<String?> restoreBackupData();
}
