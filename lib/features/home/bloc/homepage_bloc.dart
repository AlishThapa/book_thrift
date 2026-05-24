import 'package:book_thrift/core/services/location_service.dart';
import 'package:book_thrift/features/home/repo/homepage_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_thrift/features/listing/models/book_listing.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';

part 'homepage_event.dart';
part 'homepage_state.dart';

class HomepageBloc extends Bloc<HomepageEvent, HomepageState> {
  HomepageBloc(this._locationService, this._homeRepo) : super(const HomepageState()) {
    on<LoadHomepage>(_onLoad);
    on<UpdateLocationPermissionStatus>(_onUpdateLocationPermissionStatus);
  }

  final LocationService _locationService;
  final HomepageRepo _homeRepo;

  Future<void> _onLoad(LoadHomepage event, Emitter<HomepageState> emit) async {
    emit(state.copyWith(loading: true));

    final hasAsked = await _locationService.hasBeenAsked();
    final isGranted = await _locationService.isPermissionGranted();

    LocationPermissionStatus permissionStatus = LocationPermissionStatus.notAsked;
    double? lat;
    double? lng;

    if (!hasAsked) {
      final granted = await _locationService.requestPermission();
      permissionStatus = granted ? LocationPermissionStatus.granted : LocationPermissionStatus.denied;

      if (granted) {
        await _locationService.updateLocation();
        lat = _locationService.getCachedLat();
        lng = _locationService.getCachedLng();
      }
    } else if (isGranted) {
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

    try {
      final dashboardData = await _homeRepo.getDashboardData(lat: lat, lng: lng);

      emit(
        state.copyWith(
          loading: false,
          nearYouListings: dashboardData['near_you'],
          picksForYouListings: dashboardData['picks_for_you'],
          justDroppedListings: dashboardData['just_dropped'],
          trendingListings: dashboardData['trending_this_month'],
          locationPermission: permissionStatus,
        ),
      );
    } catch (e) {
      Logger().e("Error loading homepage data: $e");
      emit(state.copyWith(loading: false, locationPermission: permissionStatus));
    }
  }

  Future<void> _onUpdateLocationPermissionStatus(UpdateLocationPermissionStatus event, Emitter<HomepageState> emit) async {
    await _locationService.setPermissionStatus(asked: true, granted: event.status == LocationPermissionStatus.granted);

    emit(state.copyWith(locationPermission: event.status));

    if (event.status == LocationPermissionStatus.granted) {
      add(LoadHomepage());
    }
  }
}
