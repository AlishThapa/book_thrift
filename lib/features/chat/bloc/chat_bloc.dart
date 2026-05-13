import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_thrift/core/data/app_repository.dart';
import 'package:book_thrift/features/chat/models/chat_models.dart';
import 'package:book_thrift/features/listing/models/book_listing.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc(this.repo) : super(const ChatState()) {
    on<LoadThreads>(_load);
    on<SendMessage>(_send);
    on<DeleteThread>(_delete);
    on<ChangeFilter>(_onChangeFilter);
    on<SearchThreads>(_onSearchThreads);
  }
  
  final AppRepository repo;

  Future<void> _load(LoadThreads e, Emitter<ChatState> emit) async {
    final threads = await repo.threads();
    emit(state.copyWith(threads: threads));
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
    final list = List<ChatThread>.from(state.threads);
    var i = list.indexWhere((t) => t.id == e.threadId);
    
    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: e.text,
      isMe: true,
      sentAt: DateTime.now(),
      type: e.type,
      mediaUrl: e.mediaUrl,
      fileName: e.fileName,
    );

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
      list.add(newThread);
      await repo.saveThread(newThread);
    } else {
      final updatedMessages = List<ChatMessage>.from(list[i].messages)..add(newMessage);
      final updatedThread = list[i].copyWith(
        messages: updatedMessages,
        updatedAt: DateTime.now(),
      );
      list[i] = updatedThread;
      await repo.saveThread(updatedThread);
    }

    emit(state.copyWith(threads: list));
  }
}
