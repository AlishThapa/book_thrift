import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_thrift/constants/design_tokens.dart';
import 'package:book_thrift/constants/app_colors.dart';
import 'package:book_thrift/features/listing/book_detail_page.dart';
import 'package:book_thrift/features/search/bloc/search_bloc.dart';
import 'package:book_thrift/shared/widgets/book_card.dart';
import 'package:book_thrift/shared/widgets/system/app_search_bar.dart';
import 'package:book_thrift/shared/widgets/system/app_filter_chip.dart';
import 'package:book_thrift/core/router/app_router.gr.dart';

@RoutePage()
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SearchView();
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final categories = ['Engineering', 'School', 'Medical', 'Business', 'Arts', 'Science'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Books'),
        centerTitle: true,
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          final results = state.selectedCategory == null
              ? state.results
              : state.results
                  .where((e) => e.category.toLowerCase().contains(state.selectedCategory!.toLowerCase()))
                  .toList();

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                decoration: BoxDecoration(
                  color: Theme.of(context).appBarTheme.backgroundColor,
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Column(
                    children: [
                      AppSearchBar(
                        controller: _searchController,
                        hintText: 'Title, author, course...',
                        showFilterIcon: true,
                        onChanged: (v) => context.read<SearchBloc>().add(QueryChanged(v)),
                        onClear: () {
                          _searchController.clear();
                          context.read<SearchBloc>().add(QueryChanged(''));
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      SizedBox(
                        height: 38,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.xs),
                          itemBuilder: (context, index) {
                            final cat = categories[index];
                            final isSelected = state.selectedCategory == cat;
                            return AppFilterChip(
                              label: cat,
                              selected: isSelected,
                              onSelected: (selected) {
                                context.read<SearchBloc>().add(
                                      CategoryFilterChanged(selected ? cat : null),
                                    );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: state.query.trim().isEmpty && state.selectedCategory == null
                      ? const _InitialSearchState()
                      : results.isEmpty
                          ? const _EmptySearchResults()
                          : ListView.separated(
                              itemCount: results.length,
                              padding: const EdgeInsets.fromLTRB(0, AppSpacing.md, 0, 100),
                              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                              itemBuilder: (_, i) => BookCard(
                                listing: results[i],
                                onTap: () => context.router.push(
                                  BookDetailRoute(listing: results[i]),
                                ),
                              ),
                            ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _InitialSearchState extends StatelessWidget {
  const _InitialSearchState();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.explore_rounded,
              size: 64,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Discover Your Next Read',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Search for books by title, author, course,\nor institution to find exactly what you need.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}

class _EmptySearchResults extends StatelessWidget {
  const _EmptySearchResults();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search_off_rounded,
              size: 64,
              color: AppColors.error,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'No matching books found',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Try adjusting your search or filters to\nfind what you are looking for.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark ? Colors.white60 : AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}
