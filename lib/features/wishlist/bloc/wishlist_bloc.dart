import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_thrift/core/data/app_repository.dart';
import 'package:book_thrift/features/wishlist/models/wishlist_item.dart';
part 'wishlist_event.dart';
part 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  WishlistBloc(this.repo) : super(const WishlistState()) {
    on<LoadWishlist>(_load);
    on<ToggleWishlist>(_toggle);
  }
  final AppRepository repo;

  Future<void> _load(LoadWishlist e, Emitter<WishlistState> emit) async {
    final all = await repo.wishlist();
    emit(state.copyWith(all.map((e) => e.listingId).toSet()));
  }

  Future<void> _toggle(ToggleWishlist e, Emitter<WishlistState> emit) async {
    final set = {...state.ids};
    if (set.contains(e.listingId)) {
      set.remove(e.listingId);
      await repo.removeWishlist(e.listingId);
    } else {
      set.add(e.listingId);
      await repo.addWishlist(WishlistItem(listingId: e.listingId, savedAt: DateTime.now()));
    }
    emit(state.copyWith(set));
  }
}
