import 'package:dartz/dartz.dart';
import 'package:expenses/data/repository/mocked_network.dart';
import 'package:logger/web.dart';

import 'package:expenses/core/datasources/local/local_data_source.dart';
import 'package:expenses/core/datasources/remote/endpoints.dart';
import 'package:expenses/core/datasources/remote/network.dart';
import 'package:expenses/core/datasources/remote/network_info.dart';
import 'package:expenses/core/error/failures.dart';
import 'package:expenses/data/model/expense_model.dart';

abstract class ExpensesRepository {
  Future<Either<Failure, List<ExpenseModel>>> getExpenses(String filter);
  Future<Either<Failure, void>> addExpense(ExpenseModel expense);
}

class ExpensesRepositoryImp extends ExpensesRepository {
  final NetworkInterface remote;
  final MockedNetwork mocked;
  final LocalDataSource local;
  final NetworkInfo networkInfo;

  ExpensesRepositoryImp({
    required this.remote,
    required this.mocked,
    required this.local,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ExpenseModel>>> getExpenses(String filter) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remote.get(Endpoints.expenses);
        if (result.statusCode == 200) {
          return Right(
            (result.data as List)
                .map((expense) => ExpenseModel.fromJson(expense))
                .toList(),
          );
        }
        return const Left(ServerFailure(message: 'server error', data: null));
      } catch (e) {
        Logger().e(e);
        if (await local.containsKey('expenses')) {
          Logger().i('cashed Data');
          final List<dynamic> res =
              (await local.read('expenses')
                  as Map<dynamic, dynamic>)['expenses'];
          return Right(
            res.map((expense) => ExpenseModel.fromJson(expense)).toList(),
          );
        } else {
          Logger().i('mocked Data');
          final mockedRes = await mocked.getExpense(filter);
          local.write('expenses', {
            'expenses': mockedRes.map((expense) => expense.toJson()).toList(),
          });
          return Right(mockedRes);
        }
      }
    } else {
      if (await local.containsKey('expenses')) {
        final List<dynamic> res =
            (await local.read('expenses') as Map<dynamic, dynamic>)['expenses'];
        return Right(
          res.map((expense) => ExpenseModel.fromJson(expense)).toList(),
        );
      }
      return const Left(
        OfflineFailure(message: 'please connect to internet', data: null),
      );
    }
  }

  @override
  Future<Either<Failure, void>> addExpense(ExpenseModel expense) async {
    if (await networkInfo.isConnected) {
      if (await local.containsKey('expenses')) {
        final List<dynamic> res =
            (await local.read('expenses') as Map<dynamic, dynamic>)['expenses'];
        var list =
            res.map((expense) => ExpenseModel.fromJson(expense)).toList();
        list.add(expense);
        local.write('expenses', {
          'expenses': list.map((expense) => expense.toJson()).toList(),
        });
        return Right(null);
      } else {
        return const Left(ServerFailure(message: 'server error', data: null));
      }
    } else {
      return const Left(
        OfflineFailure(message: 'please connect to internet', data: null),
      );
    }
  }
}
