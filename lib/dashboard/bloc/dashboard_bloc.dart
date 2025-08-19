import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:expenses/core/constants/status.dart';
import 'package:expenses/dashboard/data/model/expense_model.dart';
import 'package:expenses/dashboard/data/repository/dashboard_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository repository;
  DashboardBloc({required this.repository})
    : super(DashboardState(status: RxStatus.initial)) {
    on<GetExpenses>(_getExpenses);
  }

  Future<void> _getExpenses(
    GetExpenses event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      final res = await repository.getExpenses(event.filter);
      emit(
        res.fold(
          (l) =>
              state.copyWith(status: RxStatus.error, errorMessage: l.message),
          (r) => DashboardState(status: RxStatus.success, expenses: r),
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: RxStatus.error, errorMessage: e.toString()));
    }
  }
}
