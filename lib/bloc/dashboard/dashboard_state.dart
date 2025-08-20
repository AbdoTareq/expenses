part of 'dashboard_bloc.dart';

class DashboardState extends Equatable {
  final RxStatus status;
  final List<ExpenseModel>? expenses;
  final String? errorMessage;

  const DashboardState({
    this.status = RxStatus.loading,
    this.expenses,
    this.errorMessage,
  });

  DashboardState copyWith({
    RxStatus? status,
    List<ExpenseModel>? expenses,
    String? errorMessage,
  }) {
    return DashboardState(
      status: status ?? this.status,
      expenses: expenses ?? this.expenses,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, expenses, errorMessage];
}
