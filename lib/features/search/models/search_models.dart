import 'package:hive/hive.dart';
import 'package:book_thrift/core/hive/hive_type_ids.dart';

class SearchHistoryItem {
  SearchHistoryItem({required this.query, required this.createdAt});
  final String query;
  final DateTime createdAt;
}

class RecentlyViewedItem {
  RecentlyViewedItem({required this.listingId, required this.viewedAt});
  final String listingId;
  final DateTime viewedAt;
}

class SearchHistoryItemAdapter extends TypeAdapter<SearchHistoryItem> {
  @override
  final int typeId = HiveTypeIds.searchHistoryItem;
  @override
  SearchHistoryItem read(BinaryReader r) => SearchHistoryItem(query: r.readString(), createdAt: DateTime.fromMillisecondsSinceEpoch(r.readInt()));
  @override
  void write(BinaryWriter w, SearchHistoryItem o) => w..writeString(o.query)..writeInt(o.createdAt.millisecondsSinceEpoch);
}

class RecentlyViewedItemAdapter extends TypeAdapter<RecentlyViewedItem> {
  @override
  final int typeId = HiveTypeIds.recentlyViewedItem;
  @override
  RecentlyViewedItem read(BinaryReader r) => RecentlyViewedItem(listingId: r.readString(), viewedAt: DateTime.fromMillisecondsSinceEpoch(r.readInt()));
  @override
  void write(BinaryWriter w, RecentlyViewedItem o) => w..writeString(o.listingId)..writeInt(o.viewedAt.millisecondsSinceEpoch);
}
