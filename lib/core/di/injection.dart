import 'package:book_thrift/core/router/app_router.dart';
import 'package:book_thrift/core/services/dio_services.dart';
import 'package:book_thrift/core/services/location_service.dart';
import 'package:book_thrift/core/services/websocket_service.dart';
import 'package:get_it/get_it.dart';
import 'package:book_thrift/core/data/app_repository.dart';
import 'package:book_thrift/core/data/local_data_source.dart';

import 'package:book_thrift/features/auth/repository/repo.dart';
import 'package:book_thrift/features/home/repo/homepage_repo.dart';
import 'package:book_thrift/features/profile/repo/profile_repo.dart';
import 'package:book_thrift/features/chat/repo/chat_repo.dart';
import 'package:book_thrift/features/listing/repo/listing_repo.dart';
import 'package:book_thrift/features/search/repo/search_repo.dart';
import 'package:book_thrift/features/cart/repo/cart_repo.dart';
import 'package:book_thrift/features/my_listings/repo/my_listings_repo.dart';
import 'package:book_thrift/features/settings/repo/bin_repository.dart';

import 'package:book_thrift/core/storage/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => StorageService(prefs));
  getIt.registerLazySingleton(() => LocationService(prefs));
  getIt.registerLazySingleton(LocalDataSource.new);
  getIt.registerLazySingleton(() => AppRepository(getIt()));
  getIt.registerLazySingleton(AuthRepository.new);
  getIt.registerLazySingleton(ProfileRepo.new);
  getIt.registerLazySingleton(ListingRepo.new);
  getIt.registerLazySingleton(ChatRepo.new);
  getIt.registerLazySingleton(HomepageRepo.new);
  getIt.registerLazySingleton(SearchRepo.new);
  getIt.registerLazySingleton(CartRepo.new);
  getIt.registerLazySingleton(MyListingsRepo.new);
  getIt.registerLazySingleton(BinRepository.new);
  getIt.registerSingleton(AppRouter());
  getIt.registerLazySingleton(DioServices.new);
  getIt.registerLazySingleton(WebSocketService.new);
}
