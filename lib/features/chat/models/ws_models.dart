import 'package:book_thrift/core/utils/json_helper.dart';

class WsMessage {
  final String type;
  final Map<String, dynamic> data;

  WsMessage({required this.type, required this.data});

  factory WsMessage.fromJson(Map<String, dynamic> json) {
    return WsMessage(
      type: JsonHelper.toStringValue(json['type']) ?? '',
      data: json,
    );
  }

  Map<String, dynamic> toJson() => data;
}

class SendChatMessage {
  final String type = 'send_message';
  final int conversationId;
  final String content;
  final int? replyToMessageId;

  SendChatMessage({
    required this.conversationId,
    required this.content,
    this.replyToMessageId,
  });

  Map<String, dynamic> toJson() => {
        'type': type,
        'conversation_id': conversationId,
        'content': content,
        if (replyToMessageId != null) 'reply_to_message_id': replyToMessageId,
      };
}

class ReadReceiptMessage {
  final String type = 'read_receipt';
  final int messageId;
  final int conversationId;

  ReadReceiptMessage({
    required this.messageId,
    required this.conversationId,
  });

  Map<String, dynamic> toJson() => {
        'type': type,
        'message_id': messageId,
        'conversation_id': conversationId,
      };
}
