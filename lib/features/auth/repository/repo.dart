import 'package:book_thrift/core/services/api_services.dart';
import 'package:book_thrift/features/auth/models/user_profile.dart';
import 'package:book_thrift/constants/api_url.dart';

import 'package:book_thrift/core/di/injection.dart';
import 'package:book_thrift/core/storage/storage_service.dart';
import 'package:logger/logger.dart';

class AuthRepository {
  final ApiServices _apiServices = ApiServices.instance;
  final StorageService _storageService = getIt<StorageService>();

  Future<UserProfile> register(UserProfile profile) async {
    try {
      final response = await _apiServices.postData(url: ApiUrl.register, data: profile.toJson(), useToken: false);
      return UserProfile.fromJson(response['data'] ?? response);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserProfile> login(String email, String password) async {
    try {
      final response = await _apiServices.postData(url: ApiUrl.login, data: {'email': email, 'password': password}, useToken: false);

      final data = response['data'] as Map<String, dynamic>?;

      if (data != null && data.containsKey('access_token')) {
        final token = data['access_token'];
        final uid = data['user']['uid'];
        Logger().i('Login Successful. Access Token: $token\nuid: $uid');
        await _storageService.saveAccessToken(token);
        await _storageService.saveUid(uid);
      }

      return UserProfile.fromJson(data ?? response);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> changePassword({required int userId, required String oldPassword, required String newPassword, required String confirmNewPassword}) async {
    try {
      await _apiServices.postData(
        url: ApiUrl.changePassword,
        queryParameters: {'user_id': userId},
        data: {'old_password': oldPassword, 'new_password': newPassword, 'confirm_new_password': confirmNewPassword},
      );
    } catch (e) {
      rethrow;
    }
  }
}
