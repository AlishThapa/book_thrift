part of 'my_listings_bloc.dart';

abstract class MyListingsEvent extends Equatable {
  const MyListingsEvent();

  @override
  List<Object> get props => [];
}

class LoadMyListings extends MyListingsEvent {
  const LoadMyListings();
}

class RefreshMyListings extends MyListingsEvent {
  const RefreshMyListings();
}
