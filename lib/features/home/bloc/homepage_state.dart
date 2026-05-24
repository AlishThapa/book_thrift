part of 'homepage_bloc.dart';

class HomepageState extends Equatable {
  const HomepageState({
    this.loading = true,
    this.nearYouListings = const [],
    this.picksForYouListings = const [],
    this.justDroppedListings = const [],
    this.trendingListings = const [],
    this.locationPermission = LocationPermissionStatus.notAsked,
  });

  final bool loading;
  final List<BookListing> nearYouListings;
  final List<BookListing> picksForYouListings;
  final List<BookListing> justDroppedListings;
  final List<BookListing> trendingListings;
  final LocationPermissionStatus locationPermission;

  HomepageState copyWith({
    bool? loading,
    List<BookListing>? nearYouListings,
    List<BookListing>? picksForYouListings,
    List<BookListing>? justDroppedListings,
    List<BookListing>? trendingListings,
    LocationPermissionStatus? locationPermission,
  }) =>
      HomepageState(
        loading: loading ?? this.loading,
        nearYouListings: nearYouListings ?? this.nearYouListings,
        picksForYouListings: picksForYouListings ?? this.picksForYouListings,
        justDroppedListings: justDroppedListings ?? this.justDroppedListings,
        trendingListings: trendingListings ?? this.trendingListings,
        locationPermission: locationPermission ?? this.locationPermission,
      );

  @override
  List<Object?> get props => [
        loading,
        nearYouListings,
        picksForYouListings,
        justDroppedListings,
        trendingListings,
        locationPermission,
      ];
}
