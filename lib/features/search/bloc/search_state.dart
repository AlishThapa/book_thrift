part of 'search_bloc.dart';

class SearchState extends Equatable {
  const SearchState({
    this.query = '',
    this.sort = 'most relevant',
    this.results = const [],
    this.recent = const [],
    this.selectedCategories = const {},
  });
  final String query;
  final String sort;
  final List<BookListing> results;
  final List<SearchHistoryItem> recent;
  final Set<String> selectedCategories;

  SearchState copyWith({
    String? query,
    String? sort,
    List<BookListing>? results,
    List<SearchHistoryItem>? recent,
    Set<String>? selectedCategories,
  }) =>
      SearchState(
        query: query ?? this.query,
        sort: sort ?? this.sort,
        results: results ?? this.results,
        recent: recent ?? this.recent,
        selectedCategories: selectedCategories ?? this.selectedCategories,
      );

  @override
  List<Object?> get props => [query, sort, results, recent, selectedCategories];
}
