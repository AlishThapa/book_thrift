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
    if (state.items.isEmpty) {
      emit(state.copyWith(status: WishlistStatus.loading));
    }
    try {
      final items = await _listingRepo.getWishlist();
      emit(state.copyWith(
        status: WishlistStatus.success,
        items: items,
        ids: items.map((e) => e.id).toSet(),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: state.items.isNotEmpty ? WishlistStatus.success : WishlistStatus.failure,
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

      if (isWishlisted) {
        // If it was added back (Undo), reload the list to get the full item data
        add(LoadWishlist());
      } else {
        // If it was removed, update the UI immediately
        final updatedIds = Set<String>.from(state.ids)..remove(e.listingId);
        final updatedItems = List<BookListing>.from(state.items)
          ..removeWhere((item) => item.id == e.listingId);
        
        emit(state.copyWith(
          items: updatedItems,
          ids: updatedIds,
        ));
      }
    } catch (e) {
      // Handle error
    }
  }
}
