part of 'chat_bloc.dart';

class ChatState extends Equatable {
  const ChatState({
    this.threads = const [],
    this.selectedFilter = 'All',
    this.searchQuery = '',
  });

  final List<ChatThread> threads;
  final String selectedFilter;
  final String searchQuery;

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

      // Safe check for null/empty and case-insensitive matching
      final pName = t.peerName.toLowerCase();
      final bTitle = t.bookTitle.toLowerCase();
      final query = searchQuery.toLowerCase();

      final matchesSearch = pName.contains(query) || bTitle.contains(query);

      return matchesFilter && matchesSearch;
    }).toList();
  }

  ChatState copyWith({
    List<ChatThread>? threads,
    String? selectedFilter,
    String? searchQuery,
  }) {
    return ChatState(
      threads: threads ?? this.threads,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [threads, selectedFilter, searchQuery];
}
