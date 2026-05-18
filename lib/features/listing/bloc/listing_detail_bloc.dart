import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_thrift/features/listing/models/book_listing.dart';
import 'package:book_thrift/features/listing/repo/listing_repo.dart';
import 'package:equatable/equatable.dart';

part 'listing_detail_event.dart';
part 'listing_detail_state.dart';

class ListingDetailBloc extends Bloc<ListingDetailEvent, ListingDetailState> {
  final ListingRepo _listingRepo;

  ListingDetailBloc(this._listingRepo) : super(const ListingDetailState()) {
    on<FetchListingDetail>(_onFetchListingDetail);
  }

  Future<void> _onFetchListingDetail(
    FetchListingDetail event,
    Emitter<ListingDetailState> emit,
  ) async {
    emit(state.copyWith(status: ListingDetailStatus.loading));
    try {
      final listing = await _listingRepo.getBookDetails(event.bookId);
      emit(state.copyWith(
        status: ListingDetailStatus.success,
        listing: listing,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ListingDetailStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
