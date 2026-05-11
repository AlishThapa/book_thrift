import 'package:hive/hive.dart';
import 'package:book_thrift/core/hive/hive_type_ids.dart';

class ListingDraft {
  ListingDraft({required this.id, required this.data, required this.updatedAt});
  final String id;
  final Map<String, dynamic> data;
  final DateTime updatedAt;
}

class ListingDraftAdapter extends TypeAdapter<ListingDraft> {
  @override
  final int typeId = HiveTypeIds.listingDraft;

  @override
  ListingDraft read(BinaryReader reader) => ListingDraft(
        id: reader.readString(),
        data: Map<String, dynamic>.from(reader.readMap()),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      );

  @override
  void write(BinaryWriter writer, ListingDraft obj) {
    writer..writeString(obj.id)..writeMap(obj.data)..writeInt(obj.updatedAt.millisecondsSinceEpoch);
  }
}
