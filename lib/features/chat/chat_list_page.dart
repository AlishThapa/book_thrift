import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_thrift/constants/design_tokens.dart';
import 'package:book_thrift/features/chat/bloc/chat_bloc.dart';
import 'package:book_thrift/features/chat/widgets/chat_thread_card.dart';
import 'package:book_thrift/features/chat/widgets/chat_filter_chips.dart';
import 'package:book_thrift/features/listing/models/book_listing.dart';
import 'package:book_thrift/shared/widgets/system/app_search_bar.dart';
import 'package:book_thrift/core/router/app_router.gr.dart';

@RoutePage()
class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final List<String> _filters = ['All', 'Unread', 'Books', 'Courses'];
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final chatBloc = context.read<ChatBloc>();

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 40,
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded, size: 24), onPressed: () => context.router.back()),
        title: SizedBox(
          height: 38,
          child: AppSearchBar(
            controller: _searchController,
            hintText: 'Search messages...',
            onChanged: (query) => chatBloc.add(SearchThreads(query)),
            onClear: () {
              _searchController.clear();
              chatBloc.add(const SearchThreads(''));
            },
          ),
        ),
        actions: [
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.sm),
            BlocBuilder<ChatBloc, ChatState>(
              buildWhen: (p, c) => p.selectedFilter != c.selectedFilter,
              builder: (context, state) {
                return ChatFilterChips(
                  filters: _filters,
                  selectedFilter: state.selectedFilter,
                  onFilterSelected: (filter) => chatBloc.add(ChangeFilter(filter)),
                );
              },
            ),
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state.status == ChatStatus.loading && state.threads.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.status == ChatStatus.failure && state.threads.isEmpty) {
                    return _ErrorState(
                      message: state.errorMessage ?? 'Failed to load chats',
                      onRetry: () => chatBloc.add(LoadThreads()),
                    );
                  }

                  final threads = state.filteredThreads;

                  if (threads.isEmpty) {
                    return const _EmptyChatsState();
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      chatBloc.add(LoadThreads());
                      // Wait for next state where status is not loading
                      await chatBloc.stream.firstWhere((s) => s.status != ChatStatus.loading);
                    },
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
                      itemCount: threads.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, i) {
                        final t = threads[i];
                        return ChatThreadCard(
                          thread: t,
                          onTap: () => context.router.push(
                            ChatDetailRoute(threadId: t.id, listing: BookListing.sample(t.bookId, t.bookTitle, 'Unknown', 'General', 0, 0)),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline_rounded, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(message),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

class _EmptyChatsState extends StatelessWidget {
  const _EmptyChatsState();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(color: colorScheme.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(Icons.chat_bubble_outline_rounded, size: 64, color: colorScheme.primary),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('No Messages Yet', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Your conversations with sellers\nwill appear here.',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
