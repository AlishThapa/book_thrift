part of 'wishlist_bloc.dart';

class WishlistState extends Equatable {
  const WishlistState({this.ids = const {}});
  final Set<String> ids;
  WishlistState copyWith(Set<String>? ids) => WishlistState(ids: ids ?? this.ids);
  @override
  List<Object?> get props => [ids];
}
