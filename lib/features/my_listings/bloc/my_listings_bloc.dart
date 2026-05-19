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
    emit(state.copyWith(status: MyListingsStatus.loading));
    await _fetchListings(emit);
  }

  Future<void> _onRefreshMyListings(RefreshMyListings event, Emitter<MyListingsState> emit) async {
    await _fetchListings(emit);
  }

  Future<void> _fetchListings(Emitter<MyListingsState> emit) async {
    try {
      // Fetching active and sold listings separately as requested.
      // For active, we don't pass the status to let it default to 'active' as per the API.
      final results = await Future.wait([
        _repo.getMyListings(), // defaults to active
        _repo.getMyListings(status: 'sold'),
      ]);

      emit(state.copyWith(
        status: MyListingsStatus.success,
        activeListings: results[0],
        soldListings: results[1],
      ));
    } catch (e) {
      emit(state.copyWith(
        status: MyListingsStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
