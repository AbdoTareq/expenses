import 'package:dio/dio.dart';
import 'package:expenses/core/datasources/local/local_data_source.dart';
import 'package:expenses/dashboard/bloc/dashboard_bloc.dart';
import 'package:expenses/dashboard/data/repository/dashboard_repository.dart';
import 'package:expenses/dashboard/data/repository/mocked_network.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:requests_inspector/requests_inspector.dart';
import 'package:expenses/core/datasources/remote/network.dart';
import 'package:expenses/core/datasources/remote/network_info.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerLazySingleton(() => DashboardBloc(repository: sl()));

  // Repository
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImp(
      remote: sl(),
      local: sl(),
      networkInfo: sl(),
      mocked: sl(),
    ),
  );

  // Datasources
  sl.registerLazySingleton<NetworkInterface>(() => Network(dio: sl()));
  sl.registerLazySingleton<LocalDataSource>(
    () => LocalDataSourceImpl(box: sl()),
  );

  //! Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectionChecker: sl()),
  );

  //! External
  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());
  sl.registerLazySingleton<MockedNetwork>(() => MockedNetworkImpl());
  final box = await Hive.openBox('expenses');
  sl.registerLazySingleton<Box<dynamic>>(() => box);
  sl.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 1000),
        receiveTimeout: const Duration(seconds: 1000),
        // By default, Dio treats any HTTP status code from 200 to 299 as a successful response. If you need a different range or specific conditions, you can override it using validateStatus.
        validateStatus: (status) {
          // Treat status codes less than 399 as successful
          return status != null;
        },
      ),
    ),
  );
  sl<Dio>().interceptors.addAll([RequestsInspectorInterceptor()]);
}
