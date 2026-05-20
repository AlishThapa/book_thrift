part of 'my_listings_bloc.dart';

abstract class MyListingsEvent extends Equatable {
  const MyListingsEvent();

  @override
  List<Object> get props => [];
}

class LoadMyListings extends MyListingsEvent {
  final String status;
  const LoadMyListings({this.status = 'active'});

  @override
  List<Object> get props => [status];
}

class RefreshMyListings extends MyListingsEvent {
  final String status;
  const RefreshMyListings({this.status = 'active'});

  @override
  List<Object> get props => [status];
}
