part of 'my_listings_bloc.dart';

enum MyListingsStatus { initial, loading, success, failure }

class MyListingsState extends Equatable {
  const MyListingsState({
    this.status = MyListingsStatus.initial,
    this.activeListings = const [],
    this.soldListings = const [],
    this.errorMessage = '',
  });

  final MyListingsStatus status;
  final List<BookListing> activeListings;
  final List<BookListing> soldListings;
  final String errorMessage;

  MyListingsState copyWith({
    MyListingsStatus? status,
    List<BookListing>? activeListings,
    List<BookListing>? soldListings,
    String? errorMessage,
  }) {
    return MyListingsState(
      status: status ?? this.status,
      activeListings: activeListings ?? this.activeListings,
      soldListings: soldListings ?? this.soldListings,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [status, activeListings, soldListings, errorMessage];
}
