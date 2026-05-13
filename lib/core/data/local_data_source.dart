import 'package:hive/hive.dart';
import 'package:book_thrift/core/hive/hive_boxes.dart';
import 'package:book_thrift/features/auth/models/user_profile.dart';
import 'package:book_thrift/features/chat/models/chat_models.dart';
import 'package:book_thrift/features/listing/models/book_listing.dart';
import 'package:book_thrift/features/notifications/models/app_notification.dart';
import 'package:book_thrift/features/search/models/search_models.dart';
import 'package:book_thrift/features/wishlist/models/wishlist_item.dart';

class LocalDataSource {
  Future<List<BookListing>> getListings() async => Hive.box<BookListing>(HiveBoxes.listings).values.toList();

  Future<void> upsertListing(BookListing listing) async => Hive.box<BookListing>(HiveBoxes.listings).put(listing.id, listing);

  Future<void> deleteListing(String id) async => Hive.box<BookListing>(HiveBoxes.listings).delete(id);

  Future<UserProfile?> getUserProfile() async => Hive.box<UserProfile>(HiveBoxes.userProfile).get('me');

  Future<void> saveUserProfile(UserProfile profile) async => Hive.box<UserProfile>(HiveBoxes.userProfile).put('me', profile);

  Future<List<WishlistItem>> getWishlist() async => Hive.box<WishlistItem>(HiveBoxes.wishlist).values.toList();

  Future<void> saveWishlistItem(WishlistItem item) async => Hive.box<WishlistItem>(HiveBoxes.wishlist).put(item.listingId, item);

  Future<void> deleteWishlistItem(String listingId) async => Hive.box<WishlistItem>(HiveBoxes.wishlist).delete(listingId);

  Future<List<ChatThread>> getThreads() async => Hive.box<ChatThread>(HiveBoxes.threads).values.toList();

  Future<void> saveThread(ChatThread thread) async => Hive.box<ChatThread>(HiveBoxes.threads).put(thread.id, thread);

  Future<void> deleteThread(String id) async => Hive.box<ChatThread>(HiveBoxes.threads).delete(id);

  Future<List<AppNotification>> getNotifications() async => Hive.box<AppNotification>(HiveBoxes.notifications).values.toList();

  Future<void> saveNotification(AppNotification n) async => Hive.box<AppNotification>(HiveBoxes.notifications).put(n.id, n);

  Future<void> deleteNotification(String id) async => Hive.box<AppNotification>(HiveBoxes.notifications).delete(id);

  Future<List<SearchHistoryItem>> getRecentSearches() async => Hive.box<SearchHistoryItem>(HiveBoxes.recentSearches).values.toList();

  Future<void> saveRecentSearch(SearchHistoryItem item) async => Hive.box<SearchHistoryItem>(HiveBoxes.recentSearches).put(item.query, item);

  Future<List<RecentlyViewedItem>> getRecentlyViewed() async => Hive.box<RecentlyViewedItem>(HiveBoxes.recentlyViewed).values.toList();

  Future<void> saveRecentlyViewed(RecentlyViewedItem item) async => Hive.box<RecentlyViewedItem>(HiveBoxes.recentlyViewed).put(item.listingId, item);

  Future<void> setBoolPref(String key, bool value) async => Hive.box(HiveBoxes.appPrefs).put(key, value);
  Future<bool> getBoolPref(String key, {bool fallback = false}) async => Hive.box(HiveBoxes.appPrefs).get(key, defaultValue: fallback) as bool;

  Future<void> clearAll() async {
    await Future.wait([
      Hive.box<BookListing>(HiveBoxes.listings).clear(),
      Hive.box<WishlistItem>(HiveBoxes.wishlist).clear(),
      Hive.box<ChatThread>(HiveBoxes.threads).clear(),
      Hive.box<AppNotification>(HiveBoxes.notifications).clear(),
      Hive.box<SearchHistoryItem>(HiveBoxes.recentSearches).clear(),
      Hive.box<RecentlyViewedItem>(HiveBoxes.recentlyViewed).clear(),
    ]);
  }
}
