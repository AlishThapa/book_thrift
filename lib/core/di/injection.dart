import 'package:book_thrift/core/router/app_router.dart';
import 'package:book_thrift/core/services/dio_services.dart';
import 'package:get_it/get_it.dart';
import 'package:book_thrift/core/data/app_repository.dart';
import 'package:book_thrift/core/data/local_data_source.dart';

import 'package:book_thrift/features/auth/repository/repo.dart';
import 'package:book_thrift/features/profile/repo/profile_repo.dart';
import 'package:book_thrift/features/listing/repo/listing_repo.dart';
import 'package:book_thrift/features/search/repo/search_repo.dart';

import 'package:book_thrift/core/storage/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => StorageService(prefs));
  getIt.registerLazySingleton(LocalDataSource.new);
  getIt.registerLazySingleton(() => AppRepository(getIt()));
  getIt.registerLazySingleton(AuthRepository.new);
  getIt.registerLazySingleton(ProfileRepo.new);
  getIt.registerLazySingleton(ListingRepo.new);
  getIt.registerLazySingleton(SearchRepo.new);
  getIt.registerSingleton(AppRouter());
  getIt.registerLazySingleton(DioServices.new);
}
