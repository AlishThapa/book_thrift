part of 'wishlist_bloc.dart';

sealed class WishlistEvent extends Equatable { const WishlistEvent(); @override List<Object?> get props => []; }
class LoadWishlist extends WishlistEvent {}
class ToggleWishlist extends WishlistEvent { const ToggleWishlist(this.listingId); final String listingId; @override List<Object?> get props => [listingId]; }
