import 'package:book_thrift/core/services/location_service.dart';
import 'package:book_thrift/features/home/repo/homepage_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_thrift/core/data/app_repository.dart';
import 'package:book_thrift/features/listing/models/book_listing.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';

part 'homepage_event.dart';
part 'homepage_state.dart';

class HomepageBloc extends Bloc<HomepageEvent, HomepageState> {
  HomepageBloc(this._repo, this._locationService, this._homeRepo) : super(const HomepageState()) {
    on<LoadHomepage>(_onLoad);
    on<SelectCategory>(_onSelectCategory);
    on<UpdateLocationPermissionStatus>(_onUpdateLocationPermissionStatus);
  }

  final AppRepository _repo;
  final LocationService _locationService;
  final HomepageRepo _homeRepo;

  /// Cached full listing so we don't re-fetch on every category tap.
  List<BookListing> _allListings = [];

  Future<void> _onLoad(LoadHomepage event, Emitter<HomepageState> emit) async {
    emit(state.copyWith(loading: true));

    final hasAsked = await _locationService.hasBeenAsked();
    final isGranted = await _locationService.isPermissionGranted();

    LocationPermissionStatus permissionStatus = LocationPermissionStatus.notAsked;
    double? lat;
    double? lng;

    if (!hasAsked) {
      // First time - request permission
      final granted = await _locationService.requestPermission();
      permissionStatus = granted ? LocationPermissionStatus.granted : LocationPermissionStatus.denied;

      if (granted) {
        await _locationService.updateLocation();
        lat = _locationService.getCachedLat();
        lng = _locationService.getCachedLng();
      }
    } else if (isGranted) {
      // Add a real system check here
      final realPermission = await Geolocator.checkPermission();
      final reallyGranted = realPermission == LocationPermission.whileInUse || realPermission == LocationPermission.always;
      if (reallyGranted) {
        permissionStatus = LocationPermissionStatus.granted;
        await _locationService.updateLocation();
        lat = _locationService.getCachedLat();
        lng = _locationService.getCachedLng();
      } else {
        await _locationService.setPermissionStatus(asked: true, granted: false);
        permissionStatus = LocationPermissionStatus.denied;
      }
    } else {
      permissionStatus = LocationPermissionStatus.denied;
    }

    Logger().i("Location Status: hasAsked=$hasAsked, isGranted=$isGranted, permissionStatus=$permissionStatus");
    Logger().i("Location Coordinates: lat=$lat, lng=$lng");

    try {
      final dashboardData = await _homeRepo.getDashboardData(lat: lat, lng: lng);

      _allListings = await _repo.listings();

      emit(
        state.copyWith(
          loading: false,
          listings: _allListings,
          nearYouListings: dashboardData['near_you'],
          picksForYouListings: dashboardData['picks_for_you'],
          justDroppedListings: dashboardData['just_dropped'],
          trendingListings: dashboardData['trending_this_month'],
          locationPermission: permissionStatus,
        ),
      );
    } catch (e) {
      Logger().e("Error loading homepage data: $e");
      // If API fails, we fallback to local
      _allListings = await _repo.listings();
      emit(state.copyWith(loading: false, listings: _allListings, locationPermission: permissionStatus));
    }
  }

  void _onSelectCategory(SelectCategory event, Emitter<HomepageState> emit) {
    final filtered = event.category == 'All' ? _allListings : _allListings.where((e) => e.category == event.category).toList();

    emit(state.copyWith(selectedCategory: event.category, listings: filtered));
  }

  Future<void> _onUpdateLocationPermissionStatus(UpdateLocationPermissionStatus event, Emitter<HomepageState> emit) async {
    await _locationService.setPermissionStatus(asked: true, granted: event.status == LocationPermissionStatus.granted);

    emit(state.copyWith(locationPermission: event.status));

    if (event.status == LocationPermissionStatus.granted) {
      add(LoadHomepage());
    }
  }
}
