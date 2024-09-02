import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'drive_event.dart';
import 'drive_state.dart';
import '../../../../config/service_locator.dart';
import '../../../../domain/use_case/backup_data_use_case.dart';

class DriveBloc extends Bloc<DriveEvent, DriveState> {
  DriveBloc() : super(DriveInitState()) {
    on<DriveUploadEvent>(_driveUploadBackup);
    on<DriveDownloadEvent>(_driveDownloadBackup);
  }

  FutureOr<void> _driveUploadBackup(
    DriveUploadEvent event,
    Emitter emit,
  ) async {
    emit(DriveUploadLoading());
    String? res = await sl<BackupDataUseCase>().getBackupData();
    if (res == null) {
      emit(DriveUploadSuccess(successMessage: 'Data uploaded successfully'));
    } else {
      emit(DriveUploadFailed(errorMessage: res));
    }
  }

  FutureOr<void> _driveDownloadBackup(
    DriveDownloadEvent event,
    Emitter<DriveState> emit,
  ) async {
    emit(DriveDownloading());
    String? res = await sl<BackupDataUseCase>().restoreBackupData();
    if (res == null) {
      emit(DriveDownloadSuccess(successMessage: 'Data restored successfully'));
    } else {
      emit(DriveDownloadFailed(errorMessage: res));
    }
  }
}
