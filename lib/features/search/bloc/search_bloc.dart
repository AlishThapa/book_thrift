import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_thrift/core/data/app_repository.dart';
import 'package:book_thrift/features/search/repo/search_repo.dart';
import 'package:book_thrift/features/search/models/search_models.dart';
import '../../listing/models/book_listing.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({required this.localRepo, required this.searchRepo}) : super(const SearchState()) {
    on<LoadSearch>(_load);
    on<QueryChanged>(_query);
    on<SearchSubmitted>(_submitted);
    on<SortChanged>(_sort);
    on<ToggleCategory>(_toggleCategory);
    on<ClearCategories>(_clearCategories);
    on<RefreshSearch>(_onRefresh);
  }
  final AppRepository localRepo;
  final SearchRepo searchRepo;

  Future<void> _onRefresh(RefreshSearch e, Emitter<SearchState> emit) async {
    await _fetchResults(emit);
  }

  Future<void> _toggleCategory(ToggleCategory e, Emitter<SearchState> emit) async {
    final updated = Set<String>.from(state.selectedCategories
    );
    if (e.category == 'All') {
      updated.clear();
    } else {
      if (updated.contains(e.category)) {
        updated.remove(e.category);
      } else {
        updated.add(e.category);
      }
    }
    emit(state.copyWith(selectedCategories: updated));

    // After toggling, fetch from API with current filters
    await _fetchResults(emit);
  }

  Future<void> _clearCategories(ClearCategories e, Emitter<SearchState> emit) async {
    emit(state.copyWith(selectedCategories: {}));
    await _fetchResults(emit);
  }

  Future<void> _load(LoadSearch e, Emitter<SearchState> emit) async {
    emit(state.copyWith(
      query: '',
      selectedCategories: {},
      results: [],
      status: SearchStatus.loading,
    ));

    try {
      final books = await searchRepo.getBooks();
      final recent = await localRepo.recentSearches();
      emit(state.copyWith(
        results: books,
        recent: recent,
        status: SearchStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(status: SearchStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _query(QueryChanged e, Emitter<SearchState> emit) async {
    emit(state.copyWith(query: e.query));
  }

  Future<void> _submitted(SearchSubmitted e, Emitter<SearchState> emit) async {
    emit(state.copyWith(query: e.query));
    if (e.query.isNotEmpty) {
      await localRepo.saveSearch(SearchHistoryItem(query: e.query, createdAt: DateTime.now()));
    }
    await _fetchResults(emit);
  }

  Future<void> _fetchResults(Emitter<SearchState> emit) async {
    emit(state.copyWith(status: SearchStatus.loading));
    try {
      final books = await searchRepo.getBooks(
        search: state.query,
        categories: state.selectedCategories.toList(),
      );

      emit(state.copyWith(
        results: books,
        recent: await localRepo.recentSearches(),
        status: SearchStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(status: SearchStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _sort(SortChanged e, Emitter<SearchState> emit) async {
    final list = [...state.results];
    if (e.sort == 'lowest price') list.sort((a, b) => a.sellingPrice.compareTo(b.sellingPrice));
    if (e.sort == 'newest') list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    emit(state.copyWith(sort: e.sort, results: list));
  }
}
