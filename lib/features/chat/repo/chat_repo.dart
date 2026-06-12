import 'package:book_thrift/constants/api_url.dart';
import 'package:book_thrift/core/services/dio_services.dart';
import 'package:book_thrift/features/chat/models/chat_models.dart';
import 'package:logger/logger.dart';

class ChatRepo {
  final DioServices _ds = ds;

  Future<List<ChatConversation>> getChats() async {
    try {
      final response = await _ds.dio.get(ApiUrl.chats);
      
      if (response.statusCode == 200) {
        final chatResponse = ChatResponse.fromJson(response.data);
        return chatResponse.data;
      } else {
        throw Exception('Failed to load chats: ${response.statusCode}');
      }
    } catch (e) {
      Logger().e('Error in getChats: $e');
      rethrow;
    }
  }

  Future<ChatConversation> createOrGetConversation(int recipientId) async {
    try {
      final response = await _ds.dio.post('${ApiUrl.chats}/$recipientId');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ChatConversation.fromJson(response.data);
      } else {
        throw Exception('Failed to create or get conversation: ${response.statusCode}');
      }
    } catch (e) {
      Logger().e('Error in createOrGetConversation: $e');
      rethrow;
    }
  }

  Future<bool> sendMessage(int conversationId, String content) async {
    try {
      final response = await _ds.dio.post(
        ApiUrl.messages,
        data: {
          'conversation_id': conversationId,
          'content': content,
        },
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      Logger().e('Error in sendMessage: $e');
      return false;
    }
  }

  Future<List<ChatMessage>> getMessages(int conversationId, String? currentUid) async {
    try {
      final response = await _ds.dio.get('${ApiUrl.chats}/$conversationId/messages');
      if (response.statusCode == 200) {
        final List data = response.data['data'] ?? [];
        return data.map((m) => _mapApiMessageToModel(m, currentUid)).toList();
      } else {
        throw Exception('Failed to load messages');
      }
    } catch (e) {
      Logger().e('Error in getMessages: $e');
      rethrow;
    }
  }

  ChatMessage _mapApiMessageToModel(Map<String, dynamic> m, String? currentUid) {
    return ChatMessage(
      id: m['id'].toString(),
      text: m['content'] ?? '',
      isMe: m['sender_id']?.toString() == currentUid,
      sentAt: DateTime.tryParse(m['sent_at'] ?? '') ?? DateTime.now(),
      readAt: m['read_at'] != null ? DateTime.tryParse(m['read_at']) : null,
    );
  }
}
