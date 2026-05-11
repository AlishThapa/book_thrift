import 'package:hive/hive.dart';
import 'package:book_thrift/core/hive/hive_type_ids.dart';

class WishlistItem {
  WishlistItem({required this.listingId, required this.savedAt});
  final String listingId;
  final DateTime savedAt;
}

class WishlistItemAdapter extends TypeAdapter<WishlistItem> {
  @override
  final int typeId = HiveTypeIds.wishlistItem;
  @override
  WishlistItem read(BinaryReader r) => WishlistItem(listingId: r.readString(), savedAt: DateTime.fromMillisecondsSinceEpoch(r.readInt()));
  @override
  void write(BinaryWriter w, WishlistItem o) => w..writeString(o.listingId)..writeInt(o.savedAt.millisecondsSinceEpoch);
}
