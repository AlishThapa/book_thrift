part of 'wishlist_bloc.dart';

enum WishlistStatus { initial, loading, success, failure }

class WishlistState extends Equatable {
  const WishlistState({
    this.status = WishlistStatus.initial,
    this.items = const [],
    this.ids = const {},
    this.errorMessage,
  });

  final WishlistStatus status;
  final List<BookListing> items;
  final Set<String> ids;
  final String? errorMessage;

  WishlistState copyWith({
    WishlistStatus? status,
    List<BookListing>? items,
    Set<String>? ids,
    String? errorMessage,
  }) {
    return WishlistState(
      status: status ?? this.status,
      items: items ?? this.items,
      ids: ids ?? this.ids,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, items, ids, errorMessage];
}
