import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_thrift/features/listing/models/book_listing.dart';
import 'package:book_thrift/features/listing/repo/listing_repo.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  WishlistBloc(this._listingRepo) : super(const WishlistState()) {
    on<LoadWishlist>(_load);
    on<ToggleWishlist>(_toggle);
  }

  final ListingRepo _listingRepo;

  Future<void> _load(LoadWishlist e, Emitter<WishlistState> emit) async {
    emit(state.copyWith(status: WishlistStatus.loading));
    try {
      final items = await _listingRepo.getWishlist();
      emit(state.copyWith(
        status: WishlistStatus.success,
        items: items,
        ids: items.map((e) => e.id).toSet(),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: WishlistStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _toggle(ToggleWishlist e, Emitter<WishlistState> emit) async {
    try {
      final bookId = int.tryParse(e.listingId);
      if (bookId == null) return;

      final response = await _listingRepo.toggleWishlist(bookId);
      final isWishlisted = response['data']['is_wishlisted'] as bool;

      final updatedIds = Set<String>.from(state.ids);
      List<BookListing> updatedItems = List<BookListing>.from(state.items);

      if (isWishlisted) {
        updatedIds.add(e.listingId);
        // If it was added and we don't have it in items, we might need to fetch it or just wait for next load.
        // For simplicity, if we are in the wishlist page, removing is more common.
      } else {
        updatedIds.remove(e.listingId);
        updatedItems.removeWhere((item) => item.id == e.listingId);
      }

      emit(state.copyWith(
        items: updatedItems,
        ids: updatedIds,
      ));
    } catch (e) {
      // Handle error
    }
  }
}
