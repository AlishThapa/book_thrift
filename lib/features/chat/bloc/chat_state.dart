part of 'chat_bloc.dart';

enum ChatStatus { initial, loading, success, failure }

class ChatState extends Equatable {
  const ChatState({
    this.status = ChatStatus.initial,
    this.threads = const [],
    this.selectedFilter = 'All',
    this.searchQuery = '',
    this.errorMessage,
    this.lastCreatedConversationId,
  });

  final ChatStatus status;
  final List<ChatThread> threads;
  final String selectedFilter;
  final String searchQuery;
  final String? errorMessage;
  final String? lastCreatedConversationId;

  List<ChatThread> get filteredThreads {
    return threads.where((t) {
      // Filter by category
      bool matchesFilter = true;
      if (selectedFilter == 'Unread') {
        matchesFilter = t.unreadCount > 0;
      } else if (selectedFilter == 'Books') {
        matchesFilter = true; 
      } else if (selectedFilter == 'Courses') {
        matchesFilter = false; 
      }

      final pName = t.peerName.toLowerCase();
      final bTitle = t.bookTitle.toLowerCase();
      final query = searchQuery.toLowerCase();

      final matchesSearch = pName.contains(query) || bTitle.contains(query);

      return matchesFilter && matchesSearch;
    }).toList();
  }

  ChatState copyWith({
    ChatStatus? status,
    List<ChatThread>? threads,
    String? selectedFilter,
    String? searchQuery,
    String? errorMessage,
    String? lastCreatedConversationId,
  }) {
    return ChatState(
      status: status ?? this.status,
      threads: threads ?? this.threads,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage ?? this.errorMessage,
      lastCreatedConversationId: lastCreatedConversationId ?? this.lastCreatedConversationId,
    );
  }

  @override
  List<Object?> get props => [status, threads, selectedFilter, searchQuery, errorMessage, lastCreatedConversationId];
}
