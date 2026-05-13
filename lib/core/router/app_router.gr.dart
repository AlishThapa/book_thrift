// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i17;
import 'package:book_thrift/features/auth/auth_entry_page.dart' as _i2;
import 'package:book_thrift/features/auth/models/user_profile.dart' as _i21;
import 'package:book_thrift/features/chat/chat_detail_page.dart' as _i4;
import 'package:book_thrift/features/chat/chat_list_page.dart' as _i5;
import 'package:book_thrift/features/home/homepage.dart' as _i8;
import 'package:book_thrift/features/listing/book_detail_page.dart' as _i3;
import 'package:book_thrift/features/listing/create_listing_page.dart' as _i6;
import 'package:book_thrift/features/listing/models/book_listing.dart' as _i19;
import 'package:book_thrift/features/listing/models/listing_draft.dart' as _i20;
import 'package:book_thrift/features/my_listings/my_listings_page.dart' as _i9;
import 'package:book_thrift/features/notifications/notifications_page.dart'
    as _i10;
import 'package:book_thrift/features/onboarding/onboarding_page.dart' as _i11;
import 'package:book_thrift/features/profile/edit_profile_page.dart' as _i7;
import 'package:book_thrift/features/profile/profile_page.dart' as _i12;
import 'package:book_thrift/features/search/searchpage.dart' as _i13;
import 'package:book_thrift/features/settings/about_page.dart' as _i1;
import 'package:book_thrift/features/settings/settings_page.dart' as _i14;
import 'package:book_thrift/features/splash/splash_page.dart' as _i15;
import 'package:book_thrift/features/wishlist/wishlist_page.dart' as _i16;
import 'package:flutter/material.dart' as _i18;

/// generated route for
/// [_i1.AboutPage]
class AboutRoute extends _i17.PageRouteInfo<void> {
  const AboutRoute({List<_i17.PageRouteInfo>? children})
      : super(
          AboutRoute.name,
          initialChildren: children,
        );

  static const String name = 'AboutRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i1.AboutPage();
    },
  );
}

/// generated route for
/// [_i2.AuthEntryPage]
class AuthEntryRoute extends _i17.PageRouteInfo<void> {
  const AuthEntryRoute({List<_i17.PageRouteInfo>? children})
      : super(
          AuthEntryRoute.name,
          initialChildren: children,
        );

  static const String name = 'AuthEntryRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i2.AuthEntryPage();
    },
  );
}

/// generated route for
/// [_i3.BookDetailPage]
class BookDetailRoute extends _i17.PageRouteInfo<BookDetailRouteArgs> {
  BookDetailRoute({
    _i18.Key? key,
    required _i19.BookListing listing,
    bool isOwner = false,
    List<_i17.PageRouteInfo>? children,
  }) : super(
          BookDetailRoute.name,
          args: BookDetailRouteArgs(
            key: key,
            listing: listing,
            isOwner: isOwner,
          ),
          initialChildren: children,
        );

  static const String name = 'BookDetailRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BookDetailRouteArgs>();
      return _i3.BookDetailPage(
        key: args.key,
        listing: args.listing,
        isOwner: args.isOwner,
      );
    },
  );
}

class BookDetailRouteArgs {
  const BookDetailRouteArgs({
    this.key,
    required this.listing,
    this.isOwner = false,
  });

  final _i18.Key? key;

  final _i19.BookListing listing;

  final bool isOwner;

  @override
  String toString() {
    return 'BookDetailRouteArgs{key: $key, listing: $listing, isOwner: $isOwner}';
  }
}

/// generated route for
/// [_i4.ChatDetailPage]
class ChatDetailRoute extends _i17.PageRouteInfo<ChatDetailRouteArgs> {
  ChatDetailRoute({
    _i18.Key? key,
    required String threadId,
    required _i19.BookListing listing,
    List<_i17.PageRouteInfo>? children,
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

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ChatDetailRouteArgs>();
      return _i4.ChatDetailPage(
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

  final _i18.Key? key;

  final String threadId;

  final _i19.BookListing listing;

  @override
  String toString() {
    return 'ChatDetailRouteArgs{key: $key, threadId: $threadId, listing: $listing}';
  }
}

/// generated route for
/// [_i5.ChatListPage]
class ChatListRoute extends _i17.PageRouteInfo<void> {
  const ChatListRoute({List<_i17.PageRouteInfo>? children})
      : super(
          ChatListRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChatListRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i5.ChatListPage();
    },
  );
}

/// generated route for
/// [_i6.CreateListingPage]
class CreateListingRoute extends _i17.PageRouteInfo<CreateListingRouteArgs> {
  CreateListingRoute({
    _i18.Key? key,
    _i20.ListingDraft? initialDraft,
    List<_i17.PageRouteInfo>? children,
  }) : super(
          CreateListingRoute.name,
          args: CreateListingRouteArgs(
            key: key,
            initialDraft: initialDraft,
          ),
          initialChildren: children,
        );

  static const String name = 'CreateListingRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CreateListingRouteArgs>(
          orElse: () => const CreateListingRouteArgs());
      return _i6.CreateListingPage(
        key: args.key,
        initialDraft: args.initialDraft,
      );
    },
  );
}

class CreateListingRouteArgs {
  const CreateListingRouteArgs({
    this.key,
    this.initialDraft,
  });

  final _i18.Key? key;

  final _i20.ListingDraft? initialDraft;

  @override
  String toString() {
    return 'CreateListingRouteArgs{key: $key, initialDraft: $initialDraft}';
  }
}

/// generated route for
/// [_i7.EditProfilePage]
class EditProfileRoute extends _i17.PageRouteInfo<EditProfileRouteArgs> {
  EditProfileRoute({
    _i18.Key? key,
    _i21.UserProfile? profile,
    List<_i17.PageRouteInfo>? children,
  }) : super(
          EditProfileRoute.name,
          args: EditProfileRouteArgs(
            key: key,
            profile: profile,
          ),
          initialChildren: children,
        );

  static const String name = 'EditProfileRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EditProfileRouteArgs>(
          orElse: () => const EditProfileRouteArgs());
      return _i7.EditProfilePage(
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

  final _i18.Key? key;

  final _i21.UserProfile? profile;

  @override
  String toString() {
    return 'EditProfileRouteArgs{key: $key, profile: $profile}';
  }
}

/// generated route for
/// [_i8.MainShellPage]
class MainShellRoute extends _i17.PageRouteInfo<MainShellRouteArgs> {
  MainShellRoute({
    _i18.Key? key,
    int initialIndex = 0,
    _i20.ListingDraft? initialDraft,
    List<_i17.PageRouteInfo>? children,
  }) : super(
          MainShellRoute.name,
          args: MainShellRouteArgs(
            key: key,
            initialIndex: initialIndex,
            initialDraft: initialDraft,
          ),
          initialChildren: children,
        );

  static const String name = 'MainShellRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MainShellRouteArgs>(
          orElse: () => const MainShellRouteArgs());
      return _i8.MainShellPage(
        key: args.key,
        initialIndex: args.initialIndex,
        initialDraft: args.initialDraft,
      );
    },
  );
}

class MainShellRouteArgs {
  const MainShellRouteArgs({
    this.key,
    this.initialIndex = 0,
    this.initialDraft,
  });

  final _i18.Key? key;

  final int initialIndex;

  final _i20.ListingDraft? initialDraft;

  @override
  String toString() {
    return 'MainShellRouteArgs{key: $key, initialIndex: $initialIndex, initialDraft: $initialDraft}';
  }
}

/// generated route for
/// [_i9.MyListingsPage]
class MyListingsRoute extends _i17.PageRouteInfo<void> {
  const MyListingsRoute({List<_i17.PageRouteInfo>? children})
      : super(
          MyListingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'MyListingsRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i9.MyListingsPage();
    },
  );
}

/// generated route for
/// [_i10.NotificationsPage]
class NotificationsRoute extends _i17.PageRouteInfo<void> {
  const NotificationsRoute({List<_i17.PageRouteInfo>? children})
      : super(
          NotificationsRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotificationsRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i10.NotificationsPage();
    },
  );
}

/// generated route for
/// [_i11.OnboardingPage]
class OnboardingRoute extends _i17.PageRouteInfo<void> {
  const OnboardingRoute({List<_i17.PageRouteInfo>? children})
      : super(
          OnboardingRoute.name,
          initialChildren: children,
        );

  static const String name = 'OnboardingRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i11.OnboardingPage();
    },
  );
}

/// generated route for
/// [_i12.ProfilePage]
class ProfileRoute extends _i17.PageRouteInfo<void> {
  const ProfileRoute({List<_i17.PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i12.ProfilePage();
    },
  );
}

/// generated route for
/// [_i2.ProfileSetupPage]
class ProfileSetupRoute extends _i17.PageRouteInfo<void> {
  const ProfileSetupRoute({List<_i17.PageRouteInfo>? children})
      : super(
          ProfileSetupRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileSetupRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i2.ProfileSetupPage();
    },
  );
}

/// generated route for
/// [_i13.SearchPage]
class SearchRoute extends _i17.PageRouteInfo<void> {
  const SearchRoute({List<_i17.PageRouteInfo>? children})
      : super(
          SearchRoute.name,
          initialChildren: children,
        );

  static const String name = 'SearchRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i13.SearchPage();
    },
  );
}

/// generated route for
/// [_i14.SettingsPage]
class SettingsRoute extends _i17.PageRouteInfo<void> {
  const SettingsRoute({List<_i17.PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i14.SettingsPage();
    },
  );
}

/// generated route for
/// [_i15.SplashPage]
class SplashRoute extends _i17.PageRouteInfo<void> {
  const SplashRoute({List<_i17.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i15.SplashPage();
    },
  );
}

/// generated route for
/// [_i16.WishlistPage]
class WishlistRoute extends _i17.PageRouteInfo<void> {
  const WishlistRoute({List<_i17.PageRouteInfo>? children})
      : super(
          WishlistRoute.name,
          initialChildren: children,
        );

  static const String name = 'WishlistRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i16.WishlistPage();
    },
  );
}
