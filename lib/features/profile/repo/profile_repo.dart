import 'package:book_thrift/core/services/api_services.dart';
import 'package:book_thrift/features/profile/models/profile_data.dart';
import 'package:book_thrift/constants/api_url.dart';

class ProfileRepo {
  Future<ProfileData> getProfile() async {
    final response = await apiInstance.getData(url: ApiUrl.getProfile);
    return ProfileData.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<ProfileData> updateProfile({String? fullName, String? email, String? phone, String? userType, String? location, String? institution, String? className, String? semester}) async {
    final data = {
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'user_type': userType,
      'location': location,
      'institution': institution,
      'class_name': className,
      'semester': semester,
    };

    final response = await apiInstance.putData(url: ApiUrl.editProfile, data: data);
    return ProfileData.fromJson(response['data'] as Map<String, dynamic>);
  }
}
