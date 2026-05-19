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
    on<ToggleBookWishlist>(_onToggleBookWishlist);
    on<DeleteListing>(_onDeleteListing);
  }

  Future<void> _onDeleteListing(
    DeleteListing event,
    Emitter<ListingDetailState> emit,
  ) async {
    emit(state.copyWith(status: ListingDetailStatus.loading));
    try {
      await _listingRepo.deleteListing(event.bookId);
      emit(state.copyWith(status: ListingDetailStatus.deleted));
    } catch (e) {
      emit(state.copyWith(
        status: ListingDetailStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onFetchListingDetail(
    FetchListingDetail event,
    Emitter<ListingDetailState> emit,
  ) async {
    // Clear the previous listing when starting a new fetch to avoid showing stale data in other parts of the UI
    emit(state.copyWith(status: ListingDetailStatus.loading, listing: null));
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

  Future<void> _onToggleBookWishlist(
    ToggleBookWishlist event,
    Emitter<ListingDetailState> emit,
  ) async {
    if (state.listing == null) return;

    // Optimistically update the UI
    final currentListing = state.listing!;
    final updatedListing = currentListing.copyWith(
      isWishlisted: !currentListing.isWishlisted,
    );
    emit(state.copyWith(listing: updatedListing));

    try {
      final response = await _listingRepo.toggleWishlist(event.bookId);
      final isWishlisted = response['data']['is_wishlisted'] as bool;
      
      // Ensure state is synced with server response if it differs from optimistic update
      if (isWishlisted != updatedListing.isWishlisted) {
         emit(state.copyWith(
          listing: updatedListing.copyWith(isWishlisted: isWishlisted),
        ));
      }
    } catch (e) {
      // Revert optimistic update on failure
      emit(state.copyWith(listing: currentListing));
      // Optionally emit a failure state or show a snackbar
    }
  }
}
