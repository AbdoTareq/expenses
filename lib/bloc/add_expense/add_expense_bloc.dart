import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:expenses/core/constants/status.dart';
import 'package:expenses/core/services/file_picker_manager.dart';
import 'package:expenses/data/model/expense_model.dart';
import 'package:expenses/data/repository/expenses_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_expense_event.dart';
part 'add_expense_state.dart';

class AddExpenseBloc extends Bloc<AddExpenseEvent, AddExpenseState> {
  final ExpensesRepository repository;
  final PickerManager pickerManager;
  AddExpenseBloc({required this.repository, required this.pickerManager})
    : super(AddExpenseState(status: RxStatus.initial)) {
    on<AddExpenseEvent>(_getExpenses);
  }

  Future<void> _getExpenses(
    AddExpenseEvent event,
    Emitter<AddExpenseState> emit,
  ) async {
    try {
      emit(state.copyWith(status: RxStatus.loading));
      final res = await repository.addExpense(event.expenseModel);
      emit(
        res.fold(
          (l) =>
              state.copyWith(status: RxStatus.error, errorMessage: l.message),
          (r) => AddExpenseState(status: RxStatus.success),
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: RxStatus.error, errorMessage: e.toString()));
    }
  }

  Future<String?> pickFile() async => await pickerManager.pickFile();
}
