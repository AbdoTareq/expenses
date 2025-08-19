import 'package:dartz/dartz.dart';
import 'package:logger/web.dart';

import 'package:expenses/core/datasources/local/local_data_source.dart';
import 'package:expenses/core/datasources/remote/endpoints.dart';
import 'package:expenses/core/datasources/remote/network.dart';
import 'package:expenses/core/datasources/remote/network_info.dart';
import 'package:expenses/core/error/failures.dart';
import 'package:expenses/dashboard/data/model/expense_model.dart';

abstract class DashboardRepository {
  Future<Either<Failure, List<ExpenseModel>>> getExpenses(String filter);
}

class DashboardRepositoryImp extends DashboardRepository {
  final NetworkInterface remote;
  final LocalDataSource local;
  final NetworkInfo networkInfo;

  DashboardRepositoryImp({
    required this.remote,
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
        } else {
          if (await local.containsKey('expenses')) {
            return Right(
              (local.read('expenses') as List)
                  .map((expense) => ExpenseModel.fromJson(expense))
                  .toList(),
            );
          }
        }
        return Right([]);
      } catch (e) {
        Logger().e(e);
        return Left(ServerFailure(message: e.toString(), data: e));
      }
    } else {
      if (await local.containsKey('expenses')) {
        return Right(
          (local.read('expenses') as List)
              .map((expense) => ExpenseModel.fromJson(expense))
              .toList(),
        );
      }
      return const Left(
        OfflineFailure(message: 'please connect to internet', data: null),
      );
    }
  }
}
