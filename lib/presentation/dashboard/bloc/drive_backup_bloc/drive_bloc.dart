import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'drive_event.dart';
import 'drive_state.dart';
import '../../../../config/service_locator.dart';
import '../../../../domain/use_case/backup_data_use_case.dart';

class DriveBloc extends Bloc<DriveEvent, DriveState> {
  DriveBloc() : super(DriveInitState()) {
    on<DriveUploadEvent>(_driveBackup);
  }

  FutureOr<void> _driveBackup(DriveEvent event, Emitter emit) async {
    emit(DriveStateLoading());
    String? res = await sl<BackupDataUseCase>().getBackupData();
    if (res == null) {
      emit(DriveStateSuccess(successMessage: 'Data uploaded successfully'));
    } else {
      emit(DriveStateFailed(errorMessage: 'Something went wrong'));
    }
  }
}
