part of 'listing_detail_bloc.dart';

sealed class ListingDetailEvent extends Equatable {
  const ListingDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchListingDetail extends ListingDetailEvent {
  final int bookId;

  const FetchListingDetail(this.bookId);

  @override
  List<Object> get props => [bookId];
}
