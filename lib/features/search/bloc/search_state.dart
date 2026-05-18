part of 'search_bloc.dart';

enum SearchStatus { initial, loading, success, failure }

class SearchState extends Equatable {
  const SearchState({
    this.query = '',
    this.sort = 'most relevant',
    this.results = const [],
    this.recent = const [],
    this.selectedCategories = const {},
    this.status = SearchStatus.initial,
    this.errorMessage = '',
  });
  final String query;
  final String sort;
  final List<BookListing> results;
  final List<SearchHistoryItem> recent;
  final Set<String> selectedCategories;
  final SearchStatus status;
  final String errorMessage;

  SearchState copyWith({
    String? query,
    String? sort,
    List<BookListing>? results,
    List<SearchHistoryItem>? recent,
    Set<String>? selectedCategories,
    SearchStatus? status,
    String? errorMessage,
  }) =>
      SearchState(
        query: query ?? this.query,
        sort: sort ?? this.sort,
        results: results ?? this.results,
        recent: recent ?? this.recent,
        selectedCategories: selectedCategories ?? this.selectedCategories,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  @override
  List<Object?> get props => [query, sort, results, recent, selectedCategories, status, errorMessage];
}
