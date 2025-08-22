import 'package:dartz/dartz.dart';
import 'package:expenses/core/constants/constants.dart';
import 'package:expenses/core/datasources/local/local_data_source.dart';
import 'package:expenses/core/datasources/remote/endpoints.dart';
import 'package:expenses/core/datasources/remote/network.dart';
import 'package:expenses/core/datasources/remote/network_info.dart';
import 'package:expenses/core/error/failures.dart';
import 'package:expenses/data/model/exchange_wrapper.dart';
import 'package:logger/web.dart';

abstract class ExchangeRepository {
  Future<Either<Failure, ExchangeWrapper>> getExchangeRates();
}

class ExchangeRepositoryImp extends ExchangeRepository {
  final NetworkInterface remote;
  final LocalDataSource local;
  final NetworkInfo networkInfo;

  ExchangeRepositoryImp({
    required this.remote,
    required this.local,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ExchangeWrapper>> getExchangeRates() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remote.get(Endpoints.rates);
        if (result.statusCode == 200) {
          var exchange = ExchangeWrapper.fromJson(result.data);
          await local.write(kExchangeRates, result.data);
          return Right(exchange);
        }
        return const Left(ServerFailure(message: 'server error', data: null));
      } catch (e) {
        Logger().e(e);
        if (await local.containsKey(kExchangeRates)) {
          return Right(await _getCashed());
        }
        return Left(OfflineFailure(message: e.toString(), data: null));
      }
    } else {
      if (await local.containsKey(kExchangeRates)) {
        return Right(await _getCashed());
      }
      return const Left(
        OfflineFailure(message: 'please connect to internet', data: null),
      );
    }
  }

  Future<ExchangeWrapper> _getCashed() async {
    Logger().i('cashed Data');
    final Map<dynamic, dynamic> res =
        (await local.read(kExchangeRates) as Map<dynamic, dynamic>);
    var wrapper = ExchangeWrapper.fromJson(res);
    return wrapper;
  }
}
