import 'package:equatable/equatable.dart';

class AddNewExpenseEvent extends Equatable {
  const AddNewExpenseEvent();

  @override
  List<Object?> get props => [];
}

class AddNewExpense extends AddNewExpenseEvent {
  final String description;
  final int price;

  const AddNewExpense({
    required this.description,
    required this.price,
  });

  @override
  List<Object?> get props => [description, price];
}
