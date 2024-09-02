import 'package:equatable/equatable.dart';

class DriveState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DriveInitState extends DriveState {}

class DriveUploadLoading extends DriveState {}

class DriveDownloading extends DriveState {}

class DriveUploadSuccess extends DriveState {
  final String successMessage;
  DriveUploadSuccess({required this.successMessage});
  @override
  List<Object?> get props => [successMessage];
}

class DriveUploadFailed extends DriveState {
  final String errorMessage;
  DriveUploadFailed({required this.errorMessage});
  @override
  List<Object?> get props => [errorMessage];
}

class DriveDownloadSuccess extends DriveState {
  final String successMessage;
  DriveDownloadSuccess({required this.successMessage});
  @override
  List<Object?> get props => [successMessage];
}

class DriveDownloadFailed extends DriveState {
  final String errorMessage;
  DriveDownloadFailed({required this.errorMessage});
  @override
  List<Object?> get props => [errorMessage];
}
