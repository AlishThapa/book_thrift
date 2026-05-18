import 'package:book_thrift/features/auth/bloc/auth_bloc.dart';
import 'package:book_thrift/features/auth/repository/repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:book_thrift/core/data/app_repository.dart';
import 'package:book_thrift/core/data/seed_data.dart';
import 'package:book_thrift/core/di/injection.dart';
import 'package:book_thrift/core/hive/hive_boxes.dart';
import 'package:book_thrift/features/auth/models/user_profile.dart';
import 'package:book_thrift/features/chat/bloc/chat_bloc.dart';
import 'package:book_thrift/features/chat/models/chat_models.dart';
import 'package:book_thrift/features/home/bloc/homepage_bloc.dart';
import 'package:book_thrift/features/listing/models/book_listing.dart';
import 'package:book_thrift/features/notifications/models/app_notification.dart';
import 'package:book_thrift/features/profile/bloc/profile_bloc.dart';
import 'package:book_thrift/features/profile/repo/profile_repo.dart';
import 'package:book_thrift/features/listing/bloc/create_listing_bloc.dart';
import 'package:book_thrift/features/listing/bloc/listing_detail_bloc.dart';
import 'package:book_thrift/features/listing/repo/listing_repo.dart';
import 'package:book_thrift/features/search/bloc/search_bloc.dart';
import 'package:book_thrift/features/search/models/search_models.dart';
import 'package:book_thrift/features/settings/bloc/settings_bloc.dart';
import 'package:book_thrift/features/wishlist/bloc/wishlist_bloc.dart';
import 'package:book_thrift/features/wishlist/models/wishlist_item.dart';
import 'package:book_thrift/features/cart/bloc/cart_bloc.dart';
import 'package:book_thrift/core/router/app_router.dart';
import 'package:book_thrift/core/utils/app_theme.dart';

import 'features/search/repo/search_repo.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  _registerAdapters();
  await _openBoxes();
  await setupDependencies();
  await _seedIfNeeded(getIt<AppRepository>());
  runApp( MyApp());
}

void _registerAdapters() {
  Hive
    ..registerAdapter(UserProfileAdapter())
    ..registerAdapter(BookListingAdapter())
    ..registerAdapter(ChatMessageAdapter())
    ..registerAdapter(ChatThreadAdapter())
    ..registerAdapter(AppNotificationAdapter())
    ..registerAdapter(WishlistItemAdapter())
    ..registerAdapter(SearchHistoryItemAdapter())
    ..registerAdapter(RecentlyViewedItemAdapter());
}

Future<void> _openBoxes() async {
  await Future.wait([
    Hive.openBox<UserProfile>(HiveBoxes.userProfile),
    Hive.openBox<BookListing>(HiveBoxes.listings),
    Hive.openBox<WishlistItem>(HiveBoxes.wishlist),
    Hive.openBox<ChatThread>(HiveBoxes.threads),
    Hive.openBox<AppNotification>(HiveBoxes.notifications),
    Hive.openBox<SearchHistoryItem>(HiveBoxes.recentSearches),
    Hive.openBox<RecentlyViewedItem>(HiveBoxes.recentlyViewed),
    Hive.openBox(HiveBoxes.appPrefs),
  ]);
}

Future<void> _seedIfNeeded(AppRepository repo) async {
  final seeded = await repo.getBoolPref('seeded');
  if (seeded) return;
  for (final listing in SeedData.listings()) {
    await repo.saveListing(listing);
  }
  for (final thread in SeedData.threads()) {
    await repo.saveThread(thread);
  }
  for (final notification in SeedData.notifications()) {
    await repo.saveNotification(notification);
  }
  await repo.saveProfile(SeedData.guestProfile());
  await repo.setBoolPref('seeded', true);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomepageBloc(getIt<AppRepository>())..add(LoadHomepage())),
        BlocProvider(create: (_) => WishlistBloc(getIt<AppRepository>())..add(LoadWishlist())),
        BlocProvider(
          create: (_) => ProfileBloc(
            localRepo: getIt<AppRepository>(),
            profileRepo: getIt<ProfileRepo>(),
          )..add(LoadProfile()),
        ),
        BlocProvider(create: (_) => SettingsBloc(getIt<AppRepository>())..add(LoadSettings())),
        BlocProvider(create: (_) => ChatBloc(getIt<AppRepository>())..add(LoadThreads())),
        BlocProvider(
          create: (_) => SearchBloc(
            localRepo: getIt<AppRepository>(),
            searchRepo: getIt<SearchRepo>(),
          )..add(LoadSearch()),
        ),
        BlocProvider(create: (_) => CartBloc()),
        BlocProvider(create: (_) => AuthBloc(authRepository: getIt<AuthRepository>())),
        BlocProvider(create: (_) => CreateListingBloc(getIt<ListingRepo>())..add(const SeedForm({}))),
        BlocProvider(create: (_) => ListingDetailBloc(getIt<ListingRepo>())),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, settingsState) => MaterialApp.router(
          routerConfig: getIt<AppRouter>().config(),
          debugShowCheckedModeBanner: false,
          title: 'KitabSathi',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: settingsState.themeMode,
          builder: (context, child) => GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: child!,
          ),
        ),
      ),
    );
  }
}
