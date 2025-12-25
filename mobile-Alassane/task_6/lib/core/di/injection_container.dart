import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

// Core
import 'package:task_6/core/network/network_info.dart';
import 'package:task_6/core/network/network_info_impl.dart';

// Data
import 'package:task_6/feature/data/datasources/product_local_data_source.dart';
import 'package:task_6/feature/data/datasources/product_local_data_source_impl.dart';
import 'package:task_6/feature/data/datasources/product_remote_data_source.dart';
import 'package:task_6/feature/data/datasources/product_remote_data_source_impl.dart';
import 'package:task_6/feature/data/repositories/product_repository_impl.dart';

// Domain
import 'package:task_6/feature/domain/product_repository.dart';
import 'package:task_6/feature/domain/usecases/create_product_usecase.dart';
import 'package:task_6/feature/domain/usecases/delete_product_usecase.dart';
import 'package:task_6/feature/domain/usecases/update_product_usecase.dart';
import 'package:task_6/feature/domain/usecases/view_all_products_usecase.dart';
import 'package:task_6/feature/domain/usecases/view_product_usecase.dart';

// Presentation
import 'package:task_6/feature/presentation/bloc/product_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // -------------------------
  // Externals
  // -------------------------
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  sl.registerLazySingleton<http.Client>(() => http.Client());
  sl.registerLazySingleton<InternetConnectionChecker>(
    () => InternetConnectionChecker.instance,
  );


  // -------------------------
  // Core
  // -------------------------
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(connectionChecker:sl()));

  // -------------------------
  // DataSources
  // -------------------------
  sl.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDatasourceImpl(sharedPreferences: sl()),
  );

  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(client: sl()),
  );

  // -------------------------
  // Repository
  // -------------------------
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remote: sl(),
      local: sl(),
      networkInfo: sl(),
    ),
  );

  // -------------------------
  // UseCases
  // -------------------------
  sl.registerLazySingleton(() => ViewAllProductsUseCase(sl()));
  sl.registerLazySingleton(() => ViewProductUseCase(sl()));
  sl.registerLazySingleton(() => CreateProductUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProductUseCase(sl()));
  sl.registerLazySingleton(() => DeleteProductUseCase(sl()));

  // -------------------------
  // Bloc (Presentation)
  // -------------------------
  // Bloc = factory 
  sl.registerFactory(
    () => ProductBloc(
      viewAllProductsUseCase: sl(),
      viewProductUseCase: sl(),
      createProductUseCase: sl(),
      updateProductUseCase: sl(),
      deleteProductUseCase: sl(),
    ),
  );
}