part of 'listing_detail_bloc.dart';

enum ListingDetailStatus { initial, loading, success, failure, deleted }

class ListingDetailState extends Equatable {
  const ListingDetailState({
    this.status = ListingDetailStatus.initial,
    this.listing,
    this.errorMessage = '',
  });

  final ListingDetailStatus status;
  final BookListing? listing;
  final String errorMessage;

  ListingDetailState copyWith({
    ListingDetailStatus? status,
    BookListing? listing,
    String? errorMessage,
  }) {
    return ListingDetailState(
      status: status ?? this.status,
      listing: listing ?? this.listing,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, listing, errorMessage];
}
