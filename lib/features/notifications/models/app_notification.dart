import 'package:hive/hive.dart';
import 'package:book_thrift/core/hive/hive_type_ids.dart';

class AppNotification {
  AppNotification({required this.id, required this.title, required this.body, required this.createdAt, this.isRead = false});
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;

  static AppNotification sample(String id, String title, String body) => AppNotification(id: id, title: title, body: body, createdAt: DateTime.now());
}

class AppNotificationAdapter extends TypeAdapter<AppNotification> {
  @override
  final int typeId = HiveTypeIds.appNotification;
  @override
  AppNotification read(BinaryReader r) => AppNotification(id: r.readString(), title: r.readString(), body: r.readString(), createdAt: DateTime.fromMillisecondsSinceEpoch(r.readInt()), isRead: r.readBool());
  @override
  void write(BinaryWriter w, AppNotification o) => w..writeString(o.id)..writeString(o.title)..writeString(o.body)..writeInt(o.createdAt.millisecondsSinceEpoch)..writeBool(o.isRead);
}
