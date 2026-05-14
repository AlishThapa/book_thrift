part of 'search_bloc.dart';

sealed class SearchEvent extends Equatable {
  const SearchEvent();
  @override
  List<Object?> get props => [];
}

class LoadSearch extends SearchEvent {}

class QueryChanged extends SearchEvent {
  const QueryChanged(this.query);
  final String query;
  @override
  List<Object?> get props => [query];
}

class SortChanged extends SearchEvent {
  const SortChanged(this.sort);
  final String sort;
  @override
  List<Object?> get props => [sort];
}

class ToggleCategory extends SearchEvent {
  const ToggleCategory(this.category);
  final String category;
  @override
  List<Object?> get props => [category];
}

class ClearCategories extends SearchEvent {}
