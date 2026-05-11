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

class CategoryFilterChanged extends SearchEvent {
  const CategoryFilterChanged(this.category);
  final String? category;
  @override
  List<Object?> get props => [category];
}
