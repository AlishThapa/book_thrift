import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_thrift/core/data/app_repository.dart';
import 'package:book_thrift/features/listing/models/book_listing.dart';

part 'homepage_event.dart';
part 'homepage_state.dart';

class HomepageBloc extends Bloc<HomepageEvent, HomepageState> {
  HomepageBloc(this._repo) : super(const HomepageState()) {
    on<LoadHomepage>(_onLoad);
    on<SelectCategory>(_onSelectCategory);
  }

  final AppRepository _repo;

  /// Cached full listing so we don't re-fetch on every category tap.
  List<BookListing> _allListings = [];

  Future<void> _onLoad(
      LoadHomepage event,
      Emitter<HomepageState> emit,
      ) async {
    emit(state.copyWith(loading: true));
    _allListings = await _repo.listings();
    emit(state.copyWith(loading: false, listings: _allListings));
  }

  void _onSelectCategory(
      SelectCategory event,
      Emitter<HomepageState> emit,
      ) {
    final filtered = event.category == 'All'
        ? _allListings
        : _allListings.where((e) => e.category == event.category).toList();

    emit(state.copyWith(
      selectedCategory: event.category,
      listings: filtered,
    ));
  }
}