import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LocationPermissionStatus { notAsked, granted, denied }

class LocationService {
  final SharedPreferences _prefs;

  LocationService(this._prefs);

  static const _keyGranted = 'location_permission_granted';
  static const _keyAsked = 'location_permission_asked';
  static const _keyLat = 'cached_lat';
  static const _keyLng = 'cached_lng';

  Future<bool> isPermissionGranted() async {
    return _prefs.getBool(_keyGranted) ?? false;
  }

  Future<bool> hasBeenAsked() async {
    return _prefs.getBool(_keyAsked) ?? false;
  }

  Future<void> setPermissionStatus({required bool asked, required bool granted}) async {
    await _prefs.setBool(_keyAsked, asked);
    await _prefs.setBool(_keyGranted, granted);
  }

  Future<bool> requestPermission() async {
    // Remove Permission.location.request() entirely
    LocationPermission permission = await Geolocator.requestPermission();
    final isGranted = permission == LocationPermission.always || permission == LocationPermission.whileInUse;
    await setPermissionStatus(asked: true, granted: isGranted);
    return isGranted;
  }

  Future<void> updateLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        return;
      }

      final position = await Geolocator.getCurrentPosition(locationSettings: LocationSettings(accuracy: LocationAccuracy.medium));

      await _prefs.setDouble(_keyLat, position.latitude);
      await _prefs.setDouble(_keyLng, position.longitude);

      Logger().d("Location Updated: Lat: ${position.latitude}, Lng: ${position.longitude}");
    } catch (e) {
      // Silently fail as per "update location silently in background"
    }
  }

  double? getCachedLat() => _prefs.getDouble(_keyLat);
  double? getCachedLng() => _prefs.getDouble(_keyLng);
}
