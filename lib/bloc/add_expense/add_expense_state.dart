part of 'add_expense_bloc.dart';

class AddExpenseState extends Equatable {
  final RxStatus status;
  final String? errorMessage;

  const AddExpenseState({this.status = RxStatus.loading, this.errorMessage});

  AddExpenseState copyWith({RxStatus? status, String? errorMessage}) {
    return AddExpenseState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
