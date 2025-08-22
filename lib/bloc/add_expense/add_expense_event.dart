part of 'add_expense_bloc.dart';

sealed class ExpensesEvent extends Equatable {
  const ExpensesEvent();

  @override
  List<Object> get props => [];
}

class AddExpenseEvent extends ExpensesEvent {
  final ExpenseModel expenseModel;
  final ExchangeWrapper exchangeWrapper;
  const AddExpenseEvent(this.expenseModel, this.exchangeWrapper);

  @override
  List<Object> get props => [];
}
