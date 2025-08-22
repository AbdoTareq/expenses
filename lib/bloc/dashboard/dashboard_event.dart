part of 'dashboard_bloc.dart';

sealed class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class GetExpenses extends DashboardEvent {
  final String filter;
  final num page;
  const GetExpenses({this.page = 1, this.filter = 'This month'});

  @override
  List<Object> get props => [];
}
