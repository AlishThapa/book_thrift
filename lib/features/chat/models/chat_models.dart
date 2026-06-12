import 'package:hive/hive.dart';
import 'package:book_thrift/core/hive/hive_type_ids.dart';
import 'package:book_thrift/core/utils/json_helper.dart';

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
    this.readAt,
  });
  final String id;
  final String text;
  final bool isMe;
  final DateTime sentAt;
  final ChatMessageType type;
  final String? mediaUrl;
  final String? fileName;
  final DateTime? readAt;

  ChatMessage copyWith({
    String? id,
    String? text,
    bool? isMe,
    DateTime? sentAt,
    ChatMessageType? type,
    String? mediaUrl,
    String? fileName,
    DateTime? readAt,
  }) =>
      ChatMessage(
        id: id ?? this.id,
        text: text ?? this.text,
        isMe: isMe ?? this.isMe,
        sentAt: sentAt ?? this.sentAt,
        type: type ?? this.type,
        mediaUrl: mediaUrl ?? this.mediaUrl,
        fileName: fileName ?? this.fileName,
        readAt: readAt ?? this.readAt,
      );
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

class ChatResponse {
  final List<ChatConversation> data;
  final String message;

  ChatResponse({required this.data, required this.message});

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      data: (json['data'] as List?)?.map((i) => ChatConversation.fromJson(i)).toList() ?? [],
      message: JsonHelper.toStringValue(json['message']) ?? '',
    );
  }
}

class ChatConversation {
  final int id;
  final DateTime createdAt;
  final List<ChatParticipant> participants;
  final LastChatMessage? lastMessage;

  ChatConversation({
    required this.id,
    required this.createdAt,
    required this.participants,
    this.lastMessage,
  });

  factory ChatConversation.fromJson(Map<String, dynamic> json) {
    return ChatConversation(
      id: JsonHelper.toInt(json['id']) ?? 0,
      createdAt: JsonHelper.toDate(json['created_at']) ?? DateTime.now(),
      participants: (json['participants'] as List?)?.map((i) => ChatParticipant.fromJson(i)).toList() ?? [],
      lastMessage: json['last_message'] != null ? LastChatMessage.fromJson(json['last_message']) : null,
    );
  }
}

class ChatParticipant {
  final int id;
  final String uid;
  final String fullName;
  final String email;
  final String phone;
  final String userType;
  final String location;
  final String institution;
  final String className;
  final String semester;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatParticipant({
    required this.id,
    required this.uid,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.userType,
    required this.location,
    required this.institution,
    required this.className,
    required this.semester,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatParticipant.fromJson(Map<String, dynamic> json) {
    return ChatParticipant(
      id: JsonHelper.toInt(json['id']) ?? 0,
      uid: JsonHelper.toStringValue(json['uid']) ?? '',
      fullName: JsonHelper.toStringValue(json['full_name']) ?? '',
      email: JsonHelper.toStringValue(json['email']) ?? '',
      phone: JsonHelper.toStringValue(json['phone']) ?? '',
      userType: JsonHelper.toStringValue(json['user_type']) ?? '',
      location: JsonHelper.toStringValue(json['location']) ?? '',
      institution: JsonHelper.toStringValue(json['institution']) ?? '',
      className: JsonHelper.toStringValue(json['class_name']) ?? '',
      semester: JsonHelper.toStringValue(json['semester']) ?? '',
      createdAt: JsonHelper.toDate(json['created_at']) ?? DateTime.now(),
      updatedAt: JsonHelper.toDate(json['updated_at']) ?? DateTime.now(),
    );
  }
}

class LastChatMessage {
  final int id;
  final String content;
  final int senderId;
  final int conversationId;
  final DateTime sentAt;

  LastChatMessage({
    required this.id,
    required this.content,
    required this.senderId,
    required this.conversationId,
    required this.sentAt,
  });

  factory LastChatMessage.fromJson(Map<String, dynamic> json) {
    return LastChatMessage(
      id: JsonHelper.toInt(json['id']) ?? 0,
      content: JsonHelper.toStringValue(json['content']) ?? '',
      senderId: JsonHelper.toInt(json['sender_id']) ?? 0,
      conversationId: JsonHelper.toInt(json['conversation_id']) ?? 0,
      sentAt: JsonHelper.toDate(json['sent_at']) ?? DateTime.now(),
    );
  }
}
