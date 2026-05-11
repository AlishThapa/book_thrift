import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_thrift/core/data/app_repository.dart';

import 'package:book_thrift/features/search/models/search_models.dart';

import '../../listing/models/book_listing.dart';
part  'search_event.dart';
part  'search_state.dart';
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(this.repo) : super(const SearchState()) {
    on<LoadSearch>(_load);
    on<QueryChanged>(_query);
    on<SortChanged>(_sort);
    on<CategoryFilterChanged>(_categoryFilter);
  }
  final AppRepository repo;

  Future<void> _categoryFilter(CategoryFilterChanged e, Emitter<SearchState> emit) async {
    emit(state.copyWith(selectedCategory: e.category));
  }

  Future<void> _load(LoadSearch e, Emitter<SearchState> emit) async {
    emit(state.copyWith(results: await repo.listings(), recent: await repo.recentSearches()));
  }

  Future<void> _query(QueryChanged e, Emitter<SearchState> emit) async {
    var list = await repo.listings();
    if (e.query.isNotEmpty) {
      await repo.saveSearch(SearchHistoryItem(query: e.query, createdAt: DateTime.now()));
      final q = e.query.toLowerCase();
      list = list.where((x) => [x.title, x.author, x.category, x.subject, x.classOrCourse, x.semester, x.institution].any((f) => f.toLowerCase().contains(q))).toList();
    }
    emit(state.copyWith(query: e.query, results: list, recent: await repo.recentSearches()));
  }

  Future<void> _sort(SortChanged e, Emitter<SearchState> emit) async {
    final list = [...state.results];
    if (e.sort == 'lowest price') list.sort((a,b)=>a.sellingPrice.compareTo(b.sellingPrice));
    if (e.sort == 'newest') list.sort((a,b)=>b.createdAt.compareTo(a.createdAt));
    emit(state.copyWith(sort: e.sort, results: list));
  }
}
