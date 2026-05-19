import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  static const String _accessTokenKey = 'access_token';
  static const String _uidKey = 'user_uid';
  static const String _onboardingCompleteKey = 'onboarding_complete';

  Future<void> saveAccessToken(String token) async {
    await _prefs.setString(_accessTokenKey, token);
  }

  String? getAccessToken() {
    return _prefs.getString(_accessTokenKey);
  }

  Future<void> saveUid(String uid) async {
    await _prefs.setString(_uidKey, uid);
  }

  String? getUid() {
    return _prefs.getString(_uidKey);
  }

  Future<void> clearAccessToken() async {
    await _prefs.remove(_accessTokenKey);
  }

  Future<void> clearUid() async {
    await _prefs.remove(_uidKey);
  }

  Future<void> setOnboardingComplete(bool value) async {
    await _prefs.setBool(_onboardingCompleteKey, value);
  }

  bool isOnboardingComplete() {
    return _prefs.getBool(_onboardingCompleteKey) ?? false;
  }
}
