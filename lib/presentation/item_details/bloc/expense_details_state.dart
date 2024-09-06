import 'package:equatable/equatable.dart';
import 'package:expense_tracker/domain/entity/expense_details_entity.dart';

class ExpenseDetailsState extends Equatable {
  const ExpenseDetailsState();

  @override
  List<Object?> get props => [];
}

class FetchExpense extends ExpenseDetailsState {}

class FetchExpenseError extends ExpenseDetailsState {
  final String errorMessage;

  const FetchExpenseError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

class FetchExpenseSuccess extends ExpenseDetailsState {
  final List<ExpenseDetailsEntity>? list;
  final int? totalPrice;

  const FetchExpenseSuccess({
    required this.list,
    this.totalPrice = 0,
  });

  @override
  List<Object?> get props => [list, totalPrice];
}

class AddExpense extends ExpenseDetailsState {}

class AddExpenseError extends ExpenseDetailsState {
  final String errorMessage;

  const AddExpenseError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

class AddExpenseSuccess extends ExpenseDetailsState {
  final String successMessage;

  const AddExpenseSuccess({
    required this.successMessage
  });

  @override
  List<Object?> get props => [successMessage];
}
