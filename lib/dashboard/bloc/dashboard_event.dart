part of 'dashboard_bloc.dart';

sealed class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class GetExpenses extends DashboardEvent {
  final String filter;
  const GetExpenses({this.filter = 'this month'});

  @override
  List<Object> get props => [];
}
