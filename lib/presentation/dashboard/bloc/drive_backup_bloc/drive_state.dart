import 'package:equatable/equatable.dart';

class DriveState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DriveInitState extends DriveState {}

class DriveStateLoading extends DriveState {}

class DriveStateSuccess extends DriveState {
  final String successMessage;
  DriveStateSuccess({required this.successMessage});
  @override
  List<Object?> get props => [successMessage];
}

class DriveStateFailed extends DriveState {
  final String errorMessage;
  DriveStateFailed({required this.errorMessage});
  @override
  List<Object?> get props => [errorMessage];
}
