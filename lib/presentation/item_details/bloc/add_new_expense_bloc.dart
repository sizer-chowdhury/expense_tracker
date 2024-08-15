import 'package:expense_tracker/config/service_locator.dart';
import 'package:expense_tracker/domain/use_case/add_new_expense_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'add_new_expense_event.dart';
import 'add_new_expense_state.dart';

class AddNewExpenseBloc extends Bloc<AddNewExpenseEvent, AddNewExpenseState> {
  AddNewExpenseBloc() : super(const AddNewExpenseState()) {
    on<AddNewExpense>(_addNewExpense);
  }

  void _addNewExpense(
      AddNewExpense event, Emitter<AddNewExpenseState> emit) async {
    String? response = await sl<AddNewExpenseUseCase>().addNewExpense(
      description: event.description,
      price: event.price,
    );
  }
}
