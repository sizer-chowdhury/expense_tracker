import 'package:expense_tracker/domain/repository/backup_data_repository.dart';

class BackupDataUseCase {
  final BackupDataRepository backupDataRepository;
  BackupDataUseCase(this.backupDataRepository);

  Future<String?> getBackupData() async {
    var res = await backupDataRepository.getBackupData();
    print('in use case: $res');
    return res;
  }
}
