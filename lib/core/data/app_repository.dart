import 'package:book_thrift/core/data/local_data_source.dart';
import 'package:book_thrift/features/auth/models/user_profile.dart';
import 'package:book_thrift/features/chat/models/chat_models.dart';
import 'package:book_thrift/features/listing/models/book_listing.dart';
import 'package:book_thrift/features/notifications/models/app_notification.dart';
import 'package:book_thrift/features/search/models/search_models.dart';
import 'package:book_thrift/features/wishlist/models/wishlist_item.dart';

class AppRepository {
  AppRepository(this._local);
  final LocalDataSource _local;

  Future<List<BookListing>> listings() => _local.getListings();
  Future<void> saveListing(BookListing listing) => _local.upsertListing(listing);
  Future<void> deleteListing(String id) => _local.deleteListing(id);

  Future<UserProfile?> profile() => _local.getUserProfile();
  Future<void> saveProfile(UserProfile profile) => _local.saveUserProfile(profile);

  Future<List<WishlistItem>> wishlist() => _local.getWishlist();
  Future<void> addWishlist(WishlistItem item) => _local.saveWishlistItem(item);
  Future<void> removeWishlist(String listingId) => _local.deleteWishlistItem(listingId);

  Future<List<ChatThread>> threads() => _local.getThreads();
  Future<void> saveThread(ChatThread thread) => _local.saveThread(thread);
  Future<void> deleteThread(String id) => _local.deleteThread(id);

  Future<List<AppNotification>> notifications() => _local.getNotifications();
  Future<void> saveNotification(AppNotification notification) => _local.saveNotification(notification);

  Future<List<SearchHistoryItem>> recentSearches() => _local.getRecentSearches();
  Future<void> saveSearch(SearchHistoryItem item) => _local.saveRecentSearch(item);

  Future<void> saveRecentlyViewed(RecentlyViewedItem item) => _local.saveRecentlyViewed(item);
  Future<void> setBoolPref(String key, bool value) => _local.setBoolPref(key, value);
  Future<bool> getBoolPref(String key, {bool fallback = false}) => _local.getBoolPref(key, fallback: fallback);

  Future<void> clearAll() => _local.clearAll();
}
