import 'package:get_it/get_it.dart';
import 'package:book_thrift/core/data/app_repository.dart';
import 'package:book_thrift/core/data/local_data_source.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton(LocalDataSource.new);
  getIt.registerLazySingleton(() => AppRepository(getIt()));
}
