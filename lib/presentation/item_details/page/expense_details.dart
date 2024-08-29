import 'package:expense_tracker/config/service_locator.dart';
import 'package:expense_tracker/domain/entity/expense_details_entity.dart';
import 'package:expense_tracker/presentation/item_details/bloc/expense_details_bloc.dart';
import 'package:expense_tracker/presentation/item_details/bloc/expense_details_event.dart';
import 'package:expense_tracker/presentation/item_details/bloc/expense_details_state.dart';
import 'package:expense_tracker/presentation/item_details/widget/button.dart';
import 'package:expense_tracker/presentation/item_details/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utilities/extensions/extensions.dart';

import '../../dashboard/page/dashboard.dart';

class ExpenseDetailsPage extends StatefulWidget {
  static const String path = "expense-details";

  const ExpenseDetailsPage({super.key, required this.dateTime});

  final DateTime dateTime;

  @override
  State<ExpenseDetailsPage> createState() => _ExpenseDetailsPageState();
}

class _ExpenseDetailsPageState extends State<ExpenseDetailsPage> {
  final ScrollController _scrollController = ScrollController();
  TextEditingController title = TextEditingController();
  TextEditingController price = TextEditingController();
  final BehaviorSubject<bool> _isAddButtonVisible =
      BehaviorSubject<bool>.seeded(true);
  final ExpenseDetailsBloc _bloc = sl<ExpenseDetailsBloc>();

  @override
  void initState() {
    super.initState();
    _bloc.add(FetchExpenseEvent(date: widget.dateTime));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    title.dispose();
    price.dispose();
    _isAddButtonVisible.close();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.go('/${Dashboard.path}');
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _datePriceOverView(context),
              Expanded(child: _expenseList(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _datePriceOverView(BuildContext context) {
    return BlocBuilder<ExpenseDetailsBloc, ExpenseDetailsState>(
        bloc: _bloc,
        builder: (context, state) {
          if (state is FetchExpenseSuccess) {
            final totalPrice = state.totalPrice;
            return _datePriceContainer(context, totalPrice);
          } else if (state is FetchExpenseError) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _datePriceContainer(BuildContext context, int? totalPrice) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: height * 0.12,
      child: Stack(
        children: [
          _outerContainer(height, width, totalPrice),
        ],
      ),
    );
  }

  Widget _outerContainer(double height, double width, int? totalPrice) {
    return Positioned(
      left: width * 0.18,
      child: Container(
        height: height * 0.1,
        width: width * 0.6,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              blurRadius: 2,
              spreadRadius: 1,
            )
          ],
        ),
        child: Center(
          child: _datePriceColumn(totalPrice),
        ),
      ),
    );
  }

  Widget _datePriceColumn(int? totalPrice) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Date: ${widget.dateTime.formattedDate()}",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Total Price: $totalPrice",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ],
    );
  }

  Widget _expenseList(BuildContext context) {
    return BlocBuilder<ExpenseDetailsBloc, ExpenseDetailsState>(
      bloc: _bloc,
      builder: (context, state) {
        if (state is FetchExpenseSuccess) {
          final expenses = state.list;
          if (expenses == null || expenses.isEmpty) {
            return bottomItem(context);
          }

          return ListView.builder(
            controller: _scrollController,
            physics: const ClampingScrollPhysics(),
            itemCount: expenses.length + 1,
            itemBuilder: (context, index) {
              if (index < expenses.length) {
                final expense = expenses[index];
                return expenseItem(context, expense, Theme.of(context));
              } else {
                return bottomItem(context);
              }
            },
          );
        } else if (state is FetchExpenseError) {
          return Center(child: Text('Error: ${state.errorMessage}'));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget expenseItem(
      BuildContext context, ExpenseDetailsEntity expense, ThemeData theme) {
    return card(context, theme, expense);
  }

  Widget card(
      BuildContext context, ThemeData theme, ExpenseDetailsEntity expense) {
    return Slidable(
      key: Key('$expense'),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              _bloc.add(DeleteExpense(id: expense.id));
              _bloc.add(FetchExpenseEvent(date: widget.dateTime));
            },
            icon: Icons.delete_outline_outlined,
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: Colors.white,
            borderRadius: BorderRadius.circular(12),
          )
        ],
      ),
      child: Card(
        elevation: 2.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: _cardItem(expense, theme),
      ),
    );
  }

  _cardItem(ExpenseDetailsEntity expense, ThemeData theme) {
    return ListTile(
      contentPadding: const EdgeInsets.all(16),
      leading: Icon(Icons.shopping_cart, color: theme.colorScheme.primary),
      title: Text(
        expense.name,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: _trailingItem(expense.price, expense.id, theme),
    );
  }

  _trailingItem(int price, int id, ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          price.toString(),
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline_outlined),
          color: theme.colorScheme.primary,
          onPressed: () {
            _bloc.add(DeleteExpense(id: id));
            _bloc.add(FetchExpenseEvent(date: widget.dateTime));
          },
        ),
      ],
    );
  }

  Widget bottomItem(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _isAddButtonVisible,
      initialData: true,
      builder: (context, addButtonSnapshot) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (addButtonSnapshot.data!)
                ? GradientButton(
                    onPressed: () {
                      _isAddButtonVisible.add(false);
                      _scrollDown();
                    },
                    gradientColors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.onPrimary,
                    ],
                  )
                : _addNewExpenseForm(),
          ],
        );
      },
    );
  }

  void _scrollDown() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 220.0,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _addNewExpenseForm() {
    return Column(
      children: [
        CustomTextField(
            labelText: "Description",
            controller: title,
            keyboardType: TextInputType.text),
        CustomTextField(
          labelText: "Price",
          controller: price,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _saveButton(context),
          ],
        ),
      ],
    );
  }

  Widget _saveButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: InkWell(
        onTap: () {
          _isAddButtonVisible.add(true);
          _bloc.add(AddNewExpense(
            description: title.text,
            price: int.parse(price.text),
            dateTime: widget.dateTime,
          ));
          _bloc.add(FetchExpenseEvent(date: widget.dateTime));
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent + 10,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOut,
          );
          title.clear();
          price.clear();
        },
        borderRadius: BorderRadius.circular(15),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.onPrimary
              ],
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(2, 2),
                blurRadius: 5,
              ),
            ],
          ),
          child:  Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              'Save',style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            ),
          ),
        ),
      ),
    );
  }
}
