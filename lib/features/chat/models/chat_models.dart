import 'package:hive/hive.dart';
import 'package:book_thrift/core/hive/hive_type_ids.dart';

enum ChatMessageType { text, image, document }

class ChatMessage {
  ChatMessage({
    required this.id,
    required this.text,
    required this.isMe,
    required this.sentAt,
    this.type = ChatMessageType.text,
    this.mediaUrl,
    this.fileName,
  });
  final String id;
  final String text;
  final bool isMe;
  final DateTime sentAt;
  final ChatMessageType type;
  final String? mediaUrl;
  final String? fileName;
}

class ChatThread {
  ChatThread({
    required this.id,
    required this.bookId,
    required this.bookTitle,
    required this.peerName,
    required this.messages,
    required this.updatedAt,
    this.unreadCount = 0,
  });

  final String id;
  final String bookId;
  final String bookTitle;
  final String peerName;
  final List<ChatMessage> messages;
  final DateTime updatedAt;
  final int unreadCount;

  ChatThread copyWith({
    List<ChatMessage>? messages,
    DateTime? updatedAt,
    int? unreadCount,
  }) =>
      ChatThread(
        id: id,
        bookId: bookId,
        bookTitle: bookTitle,
        peerName: peerName,
        messages: messages ?? this.messages,
        updatedAt: updatedAt ?? this.updatedAt,
        unreadCount: unreadCount ?? this.unreadCount,
      );

  static ChatThread sample() => ChatThread(
        id: 't1',
        bookId: '1',
        bookTitle: 'Calculus for Engineers',
        peerName: 'Aditi',
        messages: [
          ChatMessage(
            id: 'm1',
            text: 'Is this available?',
            isMe: true,
            sentAt: DateTime.now().subtract(const Duration(hours: 2)),
          ),
          ChatMessage(
            id: 'm2',
            text: 'Yes, available near campus gate.',
            isMe: false,
            sentAt: DateTime.now().subtract(const Duration(hours: 1)),
          ),
        ],
        updatedAt: DateTime.now(),
        unreadCount: 1,
      );
}

class ChatMessageAdapter extends TypeAdapter<ChatMessage> {
  @override
  final int typeId = HiveTypeIds.chatMessage;
  @override
  ChatMessage read(BinaryReader r) => ChatMessage(
        id: r.readString(),
        text: r.readString(),
        isMe: r.readBool(),
        sentAt: DateTime.fromMillisecondsSinceEpoch(r.readInt()),
        type: ChatMessageType.values[r.readInt()],
        mediaUrl: r.readBool() ? r.readString() : null,
        fileName: r.readBool() ? r.readString() : null,
      );
  @override
  void write(BinaryWriter w, ChatMessage o) {
    w
      ..writeString(o.id)
      ..writeString(o.text)
      ..writeBool(o.isMe)
      ..writeInt(o.sentAt.millisecondsSinceEpoch)
      ..writeInt(o.type.index);
    w.writeBool(o.mediaUrl != null);
    if (o.mediaUrl != null) w.writeString(o.mediaUrl!);
    w.writeBool(o.fileName != null);
    if (o.fileName != null) w.writeString(o.fileName!);
  }
}

class ChatThreadAdapter extends TypeAdapter<ChatThread> {
  @override
  final int typeId = HiveTypeIds.chatThread;

  @override
  ChatThread read(BinaryReader r) {
    // Safely read strings, providing fallbacks for potentially corrupted or old data
    String safeReadString() {
      try {
        return r.readString();
      } catch (_) {
        return '';
      }
    }

    final id = safeReadString();
    final bookId = safeReadString();
    final bookTitle = safeReadString();
    final peerName = safeReadString();

    List<ChatMessage> messages = [];
    try {
      messages = (r.readList()).cast<ChatMessage>();
    } catch (_) {
      messages = [];
    }

    int millis = DateTime.now().millisecondsSinceEpoch;
    try {
      final readMillis = r.readInt();
      if (readMillis.abs() <= 8640000000000000) {
        millis = readMillis;
      }
    } catch (_) {}

    int unreadCount = 0;
    try {
      if (r.availableBytes > 0) {
        unreadCount = r.readInt();
      }
    } catch (_) {}

    return ChatThread(
      id: id,
      bookId: bookId,
      bookTitle: bookTitle,
      peerName: peerName,
      messages: messages,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(millis),
      unreadCount: unreadCount,
    );
  }

  @override
  void write(BinaryWriter w, ChatThread o) => w
    ..writeString(o.id)
    ..writeString(o.bookId)
    ..writeString(o.bookTitle)
    ..writeString(o.peerName)
    ..writeList(o.messages)
    ..writeInt(o.updatedAt.millisecondsSinceEpoch)
    ..writeInt(o.unreadCount);
}
