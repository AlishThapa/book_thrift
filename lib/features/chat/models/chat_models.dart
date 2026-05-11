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
  ChatThread({required this.id, required this.bookId, required this.bookTitle, required this.peerName, required this.messages, required this.updatedAt});
  final String id;
  final String bookId;
  final String bookTitle;
  final String peerName;
  final List<ChatMessage> messages;
  final DateTime updatedAt;

  ChatThread copyWith({List<ChatMessage>? messages, DateTime? updatedAt}) => ChatThread(
        id: id, bookId: bookId, bookTitle: bookTitle, peerName: peerName, messages: messages ?? this.messages, updatedAt: updatedAt ?? this.updatedAt,
      );

  static ChatThread sample() => ChatThread(
        id: 't1',
        bookId: '1',
        bookTitle: 'Calculus for Engineers',
        peerName: 'Aditi',
        messages: [
          ChatMessage(id: 'm1', text: 'Is this available?', isMe: true, sentAt: DateTime.now().subtract(const Duration(hours: 2))),
          ChatMessage(id: 'm2', text: 'Yes, available near campus gate.', isMe: false, sentAt: DateTime.now().subtract(const Duration(hours: 1))),
        ],
        updatedAt: DateTime.now(),
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
    final id = r.readString();
    final bookId = r.readString();
    final bookTitle = r.readString();
    final peerName = r.readString();
    
    // Handle list reading with safety
    List<ChatMessage> messages = [];
    try {
      messages = (r.readList()).cast<ChatMessage>();
    } catch (_) {
      messages = [];
    }
    
    // Safety check for schema misalignment on updatedAt
    int millis = DateTime.now().millisecondsSinceEpoch;
    try {
      final readMillis = r.readInt();
      if (readMillis.abs() <= 8640000000000000) {
        millis = readMillis;
      }
    } catch (_) {}

    return ChatThread(
      id: id,
      bookId: bookId,
      bookTitle: bookTitle,
      peerName: peerName,
      messages: messages,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(millis),
    );
  }
  @override
  void write(BinaryWriter w, ChatThread o) => w..writeString(o.id)..writeString(o.bookId)..writeString(o.bookTitle)..writeString(o.peerName)..writeList(o.messages)..writeInt(o.updatedAt.millisecondsSinceEpoch);
}
