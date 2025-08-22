import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:expenses/core/constants/status.dart';
import 'package:expenses/core/error/failures.dart';
import 'package:expenses/core/extensions/string_extension.dart';
import 'package:expenses/core/services/file_picker_manager.dart';
import 'package:expenses/data/model/exchange_wrapper.dart';
import 'package:expenses/data/model/expense_model.dart';
import 'package:expenses/data/repository/exchange_repository.dart';
import 'package:expenses/data/repository/expenses_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/web.dart';

part 'add_expense_event.dart';
part 'add_expense_state.dart';

class AddExpenseBloc extends Bloc<AddExpenseEvent, AddExpenseState> {
  final ExpensesRepository repository;
  final ExchangeRepository exchangeRepository;
  final PickerManager pickerManager;
  AddExpenseBloc({
    required this.repository,
    required this.exchangeRepository,
    required this.pickerManager,
  }) : super(AddExpenseState(status: RxStatus.initial)) {
    on<AddExpenseEvent>(_getExpenses);
  }

  Future<void> _getExpenses(
    AddExpenseEvent event,
    Emitter<AddExpenseState> emit,
  ) async {
    try {
      emit(state.copyWith(status: RxStatus.loading));
      var temp = event.expenseModel.copyWith(
        convertedAmount:
            _getConvertedAmount(
              event.exchangeWrapper,
              event.expenseModel,
            ).toString(),
      );
      final res = await repository.addExpense(temp);
      res.fold(
        (l) {
          emit(state.copyWith(status: RxStatus.error, errorMessage: l.message));
        },
        (r) {
          emit(state.copyWith(status: RxStatus.success));
        },
      );
    } catch (e) {
      emit(state.copyWith(status: RxStatus.error, errorMessage: e.toString()));
    }
  }

  Future<Either<Failure, ExchangeWrapper>> getRates() async =>
      await exchangeRepository.getExchangeRates();

  num _getConvertedAmount(ExchangeWrapper rates, ExpenseModel expenseModel) {
    num rate = rates.conversionRates?.toJson()[expenseModel.currency]!;
    Logger().i(rate);
    return expenseModel.amount.toDouble / rate;
  }

  Future<String?> pickFile() async => await pickerManager.pickFile();
}
