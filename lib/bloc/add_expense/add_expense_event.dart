part of 'add_expense_bloc.dart';

sealed class AddExpenseEvent extends Equatable {
  final ExpenseModel expenseModel;
  const AddExpenseEvent(this.expenseModel);

  @override
  List<Object> get props => [];
}
