import 'package:book_thrift/features/listing/models/book_listing.dart';
import 'package:book_thrift/features/my_listings/repo/my_listings_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'my_listings_event.dart';
part 'my_listings_state.dart';

class MyListingsBloc extends Bloc<MyListingsEvent, MyListingsState> {
  final MyListingsRepo _repo;

  MyListingsBloc(this._repo) : super(const MyListingsState()) {
    on<LoadMyListings>(_onLoadMyListings);
    on<RefreshMyListings>(_onRefreshMyListings);
  }

  Future<void> _onLoadMyListings(LoadMyListings event, Emitter<MyListingsState> emit) async {
    // Only show loading if we don't have data yet
    final currentList = event.status == 'sold' ? state.soldListings : state.activeListings;
    if (currentList.isEmpty) {
      emit(state.copyWith(status: MyListingsStatus.loading));
    }
    await _fetchListings(emit, event.status);
  }

  Future<void> _onRefreshMyListings(RefreshMyListings event, Emitter<MyListingsState> emit) async {
    await _fetchListings(emit, event.status);
  }

  Future<void> _fetchListings(Emitter<MyListingsState> emit, String status) async {
    try {
      final results = await _repo.getMyListings(status: status);

      if (status == 'sold') {
        emit(state.copyWith(
          status: MyListingsStatus.success,
          soldListings: results,
        ));
      } else {
        emit(state.copyWith(
          status: MyListingsStatus.success,
          activeListings: results,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: MyListingsStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
