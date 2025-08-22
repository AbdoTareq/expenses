import 'package:dartz/dartz.dart';
import 'package:expenses/core/constants/constants.dart';
import 'package:expenses/data/repository/mocked_network.dart';
import 'package:logger/web.dart';

import 'package:expenses/core/datasources/local/local_data_source.dart';
import 'package:expenses/core/datasources/remote/endpoints.dart';
import 'package:expenses/core/datasources/remote/network.dart';
import 'package:expenses/core/datasources/remote/network_info.dart';
import 'package:expenses/core/error/failures.dart';
import 'package:expenses/data/model/expense_model.dart';

abstract class ExpensesRepository {
  Future<Either<Failure, ExpensesWrapper>> getExpenses(String filter);
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
  Future<Either<Failure, ExpensesWrapper>> getExpenses(String filter) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remote.get(Endpoints.expenses);
        if (result.statusCode == 200) {
          final Map<dynamic, dynamic> res =
              (await local.read(kExpenses) as Map<dynamic, dynamic>);
          return Right(ExpensesWrapper.fromJson(res));
        }
        return const Left(ServerFailure(message: 'server error', data: null));
      } catch (e) {
        Logger().e(e);
        if (await local.containsKey(kExpenses)) {
          return Right(await _getCashed(filter));
        } else {
          Logger().i('mocked Data');
          final mockedRes = await mocked.getExpense(filter);
          local.write(kExpenses, mockedRes.toJson());
          return Right(mockedRes);
        }
      }
    } else {
      if (await local.containsKey(kExpenses)) {
        return Right(await _getCashed(filter));
      }
      return const Left(
        OfflineFailure(message: 'please connect to internet', data: null),
      );
    }
  }

  Future<ExpensesWrapper> _getCashed(String filter) async {
    Logger().i('cashed Data');
    final Map<dynamic, dynamic> res =
        (await local.read(kExpenses) as Map<dynamic, dynamic>);
    var wrapper = ExpensesWrapper.fromJson(res);
    return wrapper.copyWith(
      data:
          wrapper.data
              ?.where(
                (e) =>
                    filter == 'This month'
                        ? e.date.contains('Today') || e.date.contains('-')
                        : e.date.contains(filter),
              )
              .toList(),
    );
  }

  @override
  Future<Either<Failure, void>> addExpense(ExpenseModel expense) async {
    if (await networkInfo.isConnected) {
      if (await local.containsKey(kExpenses)) {
        final Map<dynamic, dynamic> res =
            (await local.read(kExpenses) as Map<dynamic, dynamic>);
        var wrapper = ExpensesWrapper.fromJson(res);
        wrapper.data?.add(expense);
        local.write(kExpenses, wrapper.toJson());
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
