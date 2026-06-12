import 'dart:async';

import 'package:book_thrift/core/services/websocket_service.dart';
import 'package:book_thrift/core/storage/storage_service.dart';
import 'package:book_thrift/features/chat/models/ws_models.dart';
import 'package:book_thrift/features/chat/repo/chat_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_thrift/core/data/app_repository.dart';
import 'package:book_thrift/features/chat/models/chat_models.dart';
import 'package:book_thrift/features/listing/models/book_listing.dart';
import 'package:logger/logger.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc(this.repo, this.chatRepo, this.storage, this._wsService) : super(const ChatState()) {
    on<LoadThreads>(_load);
    on<CreateConversation>(_onCreateConversation);
    on<ResetLastCreatedId>((_, emit) => emit(state.copyWith(lastCreatedConversationId: null)));
    on<SendMessage>(_send);
    on<DeleteThread>(_delete);
    on<ChangeFilter>(_onChangeFilter);
    on<SearchThreads>(_onSearchThreads);
    on<ConnectWebSocket>(_onConnectWs);
    on<DisconnectWebSocket>(_onDisconnectWs);
    on<ReceivedWsMessage>(_onReceivedWsMessage);
    on<LoadMessages>(_onLoadMessages);
    on<MarkMessageRead>(_onMarkMessageRead);
  }

  final AppRepository repo;
  final ChatRepo chatRepo;
  final StorageService storage;
  final WebSocketService _wsService;
  StreamSubscription? _wsSubscription;

  void _onMarkMessageRead(MarkMessageRead e, Emitter<ChatState> emit) {
    if (_wsService.isConnected) {
      _wsService.sendMessage(ReadReceiptMessage(
        messageId: e.messageId,
        conversationId: e.conversationId,
      ).toJson());
    }
  }

  void _onConnectWs(ConnectWebSocket e, Emitter<ChatState> emit) {
    _wsService.connect();
    _wsSubscription?.cancel();
    _wsSubscription = _wsService.messageStream.listen((msg) {
      add(ReceivedWsMessage(msg));
    });
  }

  void _onDisconnectWs(DisconnectWebSocket e, Emitter<ChatState> emit) {
    _wsSubscription?.cancel();
    _wsService.disconnect();
  }

  void _onReceivedWsMessage(ReceivedWsMessage e, Emitter<ChatState> emit) {
    final msg = e.message;
    final type = msg['type'];

    if (type == 'new_message') {
      final convId = msg['conversation_id'].toString();
      final content = msg['content'];
      final senderId = msg['sender_id'];
      
      final list = List<ChatThread>.from(state.threads);
      final index = list.indexWhere((t) => t.id == convId);

      final newMessage = ChatMessage(
        id: msg['id'].toString(),
        text: content,
        isMe: senderId.toString() == storage.getUid(),
        sentAt: DateTime.tryParse(msg['sent_at'] ?? '') ?? DateTime.now(),
      );

      if (index >= 0) {
        final updatedMessages = List<ChatMessage>.from(list[index].messages)..add(newMessage);
        final updatedThread = list[index].copyWith(
          messages: updatedMessages,
          updatedAt: newMessage.sentAt,
        );
        list.removeAt(index);
        list.insert(0, updatedThread);
        emit(state.copyWith(threads: list));
      } else {
        add(LoadThreads());
      }
    } else if (type == 'message_read') {
      final convId = msg['conversation_id'].toString();
      final messageId = msg['message_id'].toString();
      final readAt = DateTime.tryParse(msg['read_at'] ?? '') ?? DateTime.now();

      final list = List<ChatThread>.from(state.threads);
      final index = list.indexWhere((t) => t.id == convId);

      if (index >= 0) {
        final messages = List<ChatMessage>.from(list[index].messages);
        final msgIndex = messages.indexWhere((m) => m.id == messageId);
        if (msgIndex >= 0) {
          messages[msgIndex] = messages[msgIndex].copyWith(readAt: readAt);
          list[index] = list[index].copyWith(messages: messages);
          emit(state.copyWith(threads: list));
        }
      }
    }
  }

  Future<void> _onLoadMessages(LoadMessages e, Emitter<ChatState> emit) async {
    final convId = int.tryParse(e.threadId);
    if (convId == null) return;

    try {
      final currentUid = storage.getUid();
      final messages = await chatRepo.getMessages(convId, currentUid);
      final list = List<ChatThread>.from(state.threads);
      final index = list.indexWhere((t) => t.id == e.threadId);

      if (index >= 0) {
        list[index] = list[index].copyWith(messages: messages);
        emit(state.copyWith(threads: list));
      }
    } catch (e) {
      Logger().e('Error loading messages: $e');
    }
  }

  @override
  Future<void> close() {
    _wsSubscription?.cancel();
    return super.close();
  }

  Future<void> _onCreateConversation(CreateConversation e, Emitter<ChatState> emit) async {
    emit(state.copyWith(status: ChatStatus.loading));
    try {
      final conversation = await chatRepo.createOrGetConversation(e.recipientId);
      final currentUid = storage.getUid();
      final thread = _mapConversationToThread(conversation, currentUid);

      final updatedThreads = List<ChatThread>.from(state.threads);
      final index = updatedThreads.indexWhere((t) => t.id == thread.id);
      if (index >= 0) {
        updatedThreads[index] = thread;
      } else {
        updatedThreads.insert(0, thread);
      }

      emit(state.copyWith(
        status: ChatStatus.success,
        threads: updatedThreads,
        lastCreatedConversationId: thread.id,
      ));
      
      // Reset after a short delay so it doesn't trigger again on next success
      Future.delayed(const Duration(milliseconds: 100), () {
        if (!isClosed) add(ResetLastCreatedId());
      });
    } catch (e) {
      Logger().e('Error creating conversation: $e');
      emit(state.copyWith(status: ChatStatus.failure, errorMessage: 'Failed to start conversation'));
    }
  }

  Future<void> _load(LoadThreads e, Emitter<ChatState> emit) async {
    emit(state.copyWith(status: ChatStatus.loading));
    try {
      final conversations = await chatRepo.getChats();
      final currentUid = storage.getUid();

      final threads = conversations.map((conv) => _mapConversationToThread(conv, currentUid)).toList();

      emit(state.copyWith(status: ChatStatus.success, threads: threads));
    } catch (e) {
      Logger().e('Error loading chats: $e');
      // Fallback to local on error
      final threads = await repo.threads();
      emit(state.copyWith(
        status: threads.isNotEmpty ? ChatStatus.success : ChatStatus.failure,
        threads: threads,
        errorMessage: 'Failed to sync with server. Showing local data.',
      ));
    }
  }

  ChatThread _mapConversationToThread(ChatConversation conv, String? currentUid) {
    final currentUserPart = conv.participants.firstWhere(
      (p) => p.uid == currentUid,
      orElse: () => conv.participants.isNotEmpty ? conv.participants.first : ChatParticipant(id: -1, uid: '', fullName: 'Unknown', email: '', phone: '', userType: '', location: '', institution: '', className: '', semester: '', createdAt: DateTime.now(), updatedAt: DateTime.now()),
    );

    final peer = conv.participants.firstWhere(
      (p) => p.uid != currentUid,
      orElse: () => conv.participants.isNotEmpty ? conv.participants.first : ChatParticipant(id: -1, uid: '', fullName: 'System', email: '', phone: '', userType: '', location: '', institution: '', className: '', semester: '', createdAt: DateTime.now(), updatedAt: DateTime.now()),
    );

    return ChatThread(
      id: conv.id.toString(),
      bookId: '0', // API doesn't seem to provide book details in this endpoint yet
      bookTitle: 'Inquiry', 
      peerName: peer.fullName,
      messages: conv.lastMessage != null
          ? [
              ChatMessage(
                id: conv.lastMessage!.id.toString(),
                text: conv.lastMessage!.content,
                isMe: conv.lastMessage!.senderId == currentUserPart.id,
                sentAt: conv.lastMessage!.sentAt,
              )
            ]
          : [],
      updatedAt: conv.lastMessage?.sentAt ?? conv.createdAt,
      unreadCount: 0,
    );
  }

  void _onChangeFilter(ChangeFilter e, Emitter<ChatState> emit) {
    emit(state.copyWith(selectedFilter: e.filter));
  }

  void _onSearchThreads(SearchThreads e, Emitter<ChatState> emit) {
    emit(state.copyWith(searchQuery: e.query));
  }

  Future<void> _delete(DeleteThread e, Emitter<ChatState> emit) async {
    await repo.deleteThread(e.threadId);
    final threads = await repo.threads();
    emit(state.copyWith(threads: threads));
  }

  Future<void> _send(SendMessage e, Emitter<ChatState> emit) async {
    final convId = int.tryParse(e.threadId);
    
    // Optimistic UI update
    final newMessage = ChatMessage(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      text: e.text,
      isMe: true,
      sentAt: DateTime.now(),
      type: e.type,
      mediaUrl: e.mediaUrl,
      fileName: e.fileName,
    );

    final list = List<ChatThread>.from(state.threads);
    var i = list.indexWhere((t) => t.id == e.threadId);
    
    if (i < 0) {
      if (e.listing == null) return;
      
      final newThread = ChatThread(
        id: e.threadId,
        bookId: e.listing!.id,
        bookTitle: e.listing!.title,
        peerName: 'Seller', 
        messages: [newMessage],
        updatedAt: DateTime.now(),
        unreadCount: 0,
      );
      list.insert(0, newThread);
      await repo.saveThread(newThread);
    } else {
      final updatedMessages = List<ChatMessage>.from(list[i].messages)..add(newMessage);
      final updatedThread = list[i].copyWith(
        messages: updatedMessages,
        updatedAt: DateTime.now(),
      );
      list.removeAt(i);
      list.insert(0, updatedThread);
      await repo.saveThread(updatedThread);
    }

    emit(state.copyWith(threads: list));

    // Send via WebSocket if connected
    if (convId != null && _wsService.isConnected) {
      _wsService.sendMessage(SendChatMessage(
        conversationId: convId,
        content: e.text,
      ).toJson());
    } else if (convId != null) {
      // Fallback to REST if WS is not connected
      final success = await chatRepo.sendMessage(convId, e.text);
      if (!success) {
        Logger().w('Failed to send message via REST too.');
      }
    }
  }
}
