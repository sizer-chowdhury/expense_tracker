import 'package:equatable/equatable.dart';
import '../../../domain/entity/expense_details_entity.dart';

class ItemState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialFetchInit extends ItemState {}

class InitialFetchFailed extends ItemState {
  final String errorMessage;
  InitialFetchFailed({required this.errorMessage});
  @override
  List<Object?> get props => [errorMessage];
}

class InitialFetchSuccess extends ItemState {
  final List<ExpenseDetailsEntity>? list;

  InitialFetchSuccess({required this.list});

  @override
  List<Object?> get props => [list];
}
