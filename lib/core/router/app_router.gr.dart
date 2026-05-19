// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i22;
import 'package:book_thrift/features/auth/auth_entry_page.dart' as _i2;
import 'package:book_thrift/features/auth/models/user_profile.dart' as _i25;
import 'package:book_thrift/features/cart/cart_page.dart' as _i5;
import 'package:book_thrift/features/chat/chat_detail_page.dart' as _i7;
import 'package:book_thrift/features/chat/chat_list_page.dart' as _i8;
import 'package:book_thrift/features/checkout/checkout_page.dart' as _i9;
import 'package:book_thrift/features/home/homepage.dart' as _i12;
import 'package:book_thrift/features/listing/book_detail_page.dart' as _i4;
import 'package:book_thrift/features/listing/create_listing_page.dart' as _i10;
import 'package:book_thrift/features/listing/models/book_listing.dart' as _i24;
import 'package:book_thrift/features/my_listings/my_listings_page.dart' as _i13;
import 'package:book_thrift/features/notifications/notifications_page.dart'
    as _i14;
import 'package:book_thrift/features/onboarding/onboarding_page.dart' as _i15;
import 'package:book_thrift/features/profile/edit_profile_page.dart' as _i11;
import 'package:book_thrift/features/profile/profile_page.dart' as _i16;
import 'package:book_thrift/features/profile/public_seller_profile_page.dart'
    as _i17;
import 'package:book_thrift/features/search/searchpage.dart' as _i18;
import 'package:book_thrift/features/settings/about_page.dart' as _i1;
import 'package:book_thrift/features/settings/bin_page.dart' as _i3;
import 'package:book_thrift/features/settings/change_password_page.dart' as _i6;
import 'package:book_thrift/features/settings/settings_page.dart' as _i19;
import 'package:book_thrift/features/splash/splash_page.dart' as _i20;
import 'package:book_thrift/features/wishlist/wishlist_page.dart' as _i21;
import 'package:flutter/material.dart' as _i23;

/// generated route for
/// [_i1.AboutPage]
class AboutRoute extends _i22.PageRouteInfo<void> {
  const AboutRoute({List<_i22.PageRouteInfo>? children})
      : super(
          AboutRoute.name,
          initialChildren: children,
        );

  static const String name = 'AboutRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      return const _i1.AboutPage();
    },
  );
}

/// generated route for
/// [_i2.AuthEntryPage]
class AuthEntryRoute extends _i22.PageRouteInfo<void> {
  const AuthEntryRoute({List<_i22.PageRouteInfo>? children})
      : super(
          AuthEntryRoute.name,
          initialChildren: children,
        );

  static const String name = 'AuthEntryRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      return const _i2.AuthEntryPage();
    },
  );
}

/// generated route for
/// [_i3.BinPage]
class BinRoute extends _i22.PageRouteInfo<void> {
  const BinRoute({List<_i22.PageRouteInfo>? children})
      : super(
          BinRoute.name,
          initialChildren: children,
        );

  static const String name = 'BinRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      return const _i3.BinPage();
    },
  );
}

/// generated route for
/// [_i4.BookDetailPage]
class BookDetailRoute extends _i22.PageRouteInfo<BookDetailRouteArgs> {
  BookDetailRoute({
    _i23.Key? key,
    required _i24.BookListing listing,
    bool isOwner = false,
    String? heroTag,
    List<_i22.PageRouteInfo>? children,
  }) : super(
          BookDetailRoute.name,
          args: BookDetailRouteArgs(
            key: key,
            listing: listing,
            isOwner: isOwner,
            heroTag: heroTag,
          ),
          initialChildren: children,
        );

  static const String name = 'BookDetailRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BookDetailRouteArgs>();
      return _i4.BookDetailPage(
        key: args.key,
        listing: args.listing,
        isOwner: args.isOwner,
        heroTag: args.heroTag,
      );
    },
  );
}

class BookDetailRouteArgs {
  const BookDetailRouteArgs({
    this.key,
    required this.listing,
    this.isOwner = false,
    this.heroTag,
  });

  final _i23.Key? key;

  final _i24.BookListing listing;

  final bool isOwner;

  final String? heroTag;

  @override
  String toString() {
    return 'BookDetailRouteArgs{key: $key, listing: $listing, isOwner: $isOwner, heroTag: $heroTag}';
  }
}

/// generated route for
/// [_i5.CartPage]
class CartRoute extends _i22.PageRouteInfo<CartRouteArgs> {
  CartRoute({
    _i23.Key? key,
    _i23.ValueChanged<int>? onNavigate,
    List<_i22.PageRouteInfo>? children,
  }) : super(
          CartRoute.name,
          args: CartRouteArgs(
            key: key,
            onNavigate: onNavigate,
          ),
          initialChildren: children,
        );

  static const String name = 'CartRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      final args =
          data.argsAs<CartRouteArgs>(orElse: () => const CartRouteArgs());
      return _i5.CartPage(
        key: args.key,
        onNavigate: args.onNavigate,
      );
    },
  );
}

class CartRouteArgs {
  const CartRouteArgs({
    this.key,
    this.onNavigate,
  });

  final _i23.Key? key;

  final _i23.ValueChanged<int>? onNavigate;

  @override
  String toString() {
    return 'CartRouteArgs{key: $key, onNavigate: $onNavigate}';
  }
}

/// generated route for
/// [_i6.ChangePasswordPage]
class ChangePasswordRoute extends _i22.PageRouteInfo<void> {
  const ChangePasswordRoute({List<_i22.PageRouteInfo>? children})
      : super(
          ChangePasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChangePasswordRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      return const _i6.ChangePasswordPage();
    },
  );
}

/// generated route for
/// [_i7.ChatDetailPage]
class ChatDetailRoute extends _i22.PageRouteInfo<ChatDetailRouteArgs> {
  ChatDetailRoute({
    _i23.Key? key,
    required String threadId,
    required _i24.BookListing listing,
    List<_i22.PageRouteInfo>? children,
  }) : super(
          ChatDetailRoute.name,
          args: ChatDetailRouteArgs(
            key: key,
            threadId: threadId,
            listing: listing,
          ),
          initialChildren: children,
        );

  static const String name = 'ChatDetailRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ChatDetailRouteArgs>();
      return _i7.ChatDetailPage(
        key: args.key,
        threadId: args.threadId,
        listing: args.listing,
      );
    },
  );
}

class ChatDetailRouteArgs {
  const ChatDetailRouteArgs({
    this.key,
    required this.threadId,
    required this.listing,
  });

  final _i23.Key? key;

  final String threadId;

  final _i24.BookListing listing;

  @override
  String toString() {
    return 'ChatDetailRouteArgs{key: $key, threadId: $threadId, listing: $listing}';
  }
}

/// generated route for
/// [_i8.ChatListPage]
class ChatListRoute extends _i22.PageRouteInfo<void> {
  const ChatListRoute({List<_i22.PageRouteInfo>? children})
      : super(
          ChatListRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChatListRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      return const _i8.ChatListPage();
    },
  );
}

/// generated route for
/// [_i9.CheckoutPage]
class CheckoutRoute extends _i22.PageRouteInfo<void> {
  const CheckoutRoute({List<_i22.PageRouteInfo>? children})
      : super(
          CheckoutRoute.name,
          initialChildren: children,
        );

  static const String name = 'CheckoutRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      return const _i9.CheckoutPage();
    },
  );
}

/// generated route for
/// [_i10.CreateListingPage]
class CreateListingRoute extends _i22.PageRouteInfo<CreateListingRouteArgs> {
  CreateListingRoute({
    _i23.Key? key,
    _i24.BookListing? listing,
    List<_i22.PageRouteInfo>? children,
  }) : super(
          CreateListingRoute.name,
          args: CreateListingRouteArgs(
            key: key,
            listing: listing,
          ),
          initialChildren: children,
        );

  static const String name = 'CreateListingRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CreateListingRouteArgs>(
          orElse: () => const CreateListingRouteArgs());
      return _i10.CreateListingPage(
        key: args.key,
        listing: args.listing,
      );
    },
  );
}

class CreateListingRouteArgs {
  const CreateListingRouteArgs({
    this.key,
    this.listing,
  });

  final _i23.Key? key;

  final _i24.BookListing? listing;

  @override
  String toString() {
    return 'CreateListingRouteArgs{key: $key, listing: $listing}';
  }
}

/// generated route for
/// [_i11.EditProfilePage]
class EditProfileRoute extends _i22.PageRouteInfo<EditProfileRouteArgs> {
  EditProfileRoute({
    _i23.Key? key,
    _i25.UserProfile? profile,
    List<_i22.PageRouteInfo>? children,
  }) : super(
          EditProfileRoute.name,
          args: EditProfileRouteArgs(
            key: key,
            profile: profile,
          ),
          initialChildren: children,
        );

  static const String name = 'EditProfileRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EditProfileRouteArgs>(
          orElse: () => const EditProfileRouteArgs());
      return _i11.EditProfilePage(
        key: args.key,
        profile: args.profile,
      );
    },
  );
}

class EditProfileRouteArgs {
  const EditProfileRouteArgs({
    this.key,
    this.profile,
  });

  final _i23.Key? key;

  final _i25.UserProfile? profile;

  @override
  String toString() {
    return 'EditProfileRouteArgs{key: $key, profile: $profile}';
  }
}

/// generated route for
/// [_i12.MainShellPage]
class MainShellRoute extends _i22.PageRouteInfo<MainShellRouteArgs> {
  MainShellRoute({
    _i23.Key? key,
    int initialIndex = 0,
    List<_i22.PageRouteInfo>? children,
  }) : super(
          MainShellRoute.name,
          args: MainShellRouteArgs(
            key: key,
            initialIndex: initialIndex,
          ),
          initialChildren: children,
        );

  static const String name = 'MainShellRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MainShellRouteArgs>(
          orElse: () => const MainShellRouteArgs());
      return _i12.MainShellPage(
        key: args.key,
        initialIndex: args.initialIndex,
      );
    },
  );
}

class MainShellRouteArgs {
  const MainShellRouteArgs({
    this.key,
    this.initialIndex = 0,
  });

  final _i23.Key? key;

  final int initialIndex;

  @override
  String toString() {
    return 'MainShellRouteArgs{key: $key, initialIndex: $initialIndex}';
  }
}

/// generated route for
/// [_i13.MyListingsPage]
class MyListingsRoute extends _i22.PageRouteInfo<void> {
  const MyListingsRoute({List<_i22.PageRouteInfo>? children})
      : super(
          MyListingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'MyListingsRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      return const _i13.MyListingsPage();
    },
  );
}

/// generated route for
/// [_i14.NotificationsPage]
class NotificationsRoute extends _i22.PageRouteInfo<void> {
  const NotificationsRoute({List<_i22.PageRouteInfo>? children})
      : super(
          NotificationsRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotificationsRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      return const _i14.NotificationsPage();
    },
  );
}

/// generated route for
/// [_i15.OnboardingPage]
class OnboardingRoute extends _i22.PageRouteInfo<void> {
  const OnboardingRoute({List<_i22.PageRouteInfo>? children})
      : super(
          OnboardingRoute.name,
          initialChildren: children,
        );

  static const String name = 'OnboardingRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      return const _i15.OnboardingPage();
    },
  );
}

/// generated route for
/// [_i16.ProfilePage]
class ProfileRoute extends _i22.PageRouteInfo<void> {
  const ProfileRoute({List<_i22.PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      return const _i16.ProfilePage();
    },
  );
}

/// generated route for
/// [_i2.ProfileSetupPage]
class ProfileSetupRoute extends _i22.PageRouteInfo<void> {
  const ProfileSetupRoute({List<_i22.PageRouteInfo>? children})
      : super(
          ProfileSetupRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileSetupRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      return const _i2.ProfileSetupPage();
    },
  );
}

/// generated route for
/// [_i17.PublicSellerProfilePage]
class PublicSellerProfileRoute extends _i22.PageRouteInfo<void> {
  const PublicSellerProfileRoute({List<_i22.PageRouteInfo>? children})
      : super(
          PublicSellerProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'PublicSellerProfileRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      return const _i17.PublicSellerProfilePage();
    },
  );
}

/// generated route for
/// [_i18.SearchPage]
class SearchRoute extends _i22.PageRouteInfo<void> {
  const SearchRoute({List<_i22.PageRouteInfo>? children})
      : super(
          SearchRoute.name,
          initialChildren: children,
        );

  static const String name = 'SearchRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      return const _i18.SearchPage();
    },
  );
}

/// generated route for
/// [_i19.SettingsPage]
class SettingsRoute extends _i22.PageRouteInfo<void> {
  const SettingsRoute({List<_i22.PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      return const _i19.SettingsPage();
    },
  );
}

/// generated route for
/// [_i20.SplashPage]
class SplashRoute extends _i22.PageRouteInfo<void> {
  const SplashRoute({List<_i22.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      return const _i20.SplashPage();
    },
  );
}

/// generated route for
/// [_i21.WishlistPage]
class WishlistRoute extends _i22.PageRouteInfo<void> {
  const WishlistRoute({List<_i22.PageRouteInfo>? children})
      : super(
          WishlistRoute.name,
          initialChildren: children,
        );

  static const String name = 'WishlistRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      return const _i21.WishlistPage();
    },
  );
}
