import 'package:book_thrift/core/utils/json_helper.dart';

class ProfileData {
  final int id;
  final String fullName;
  final String email;
  final String phone;
  final String userType;
  final String location;
  final String institution;
  final String className;
  final String semester;
  final String createdAt;
  final String? updatedAt;

  ProfileData({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.userType,
    required this.location,
    required this.institution,
    required this.className,
    required this.semester,
    required this.createdAt,
    this.updatedAt,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      id: JsonHelper.toInt(json['id']) ?? 0,
      fullName: JsonHelper.toStringValue(json['full_name']) ?? '',
      email: JsonHelper.toStringValue(json['email']) ?? '',
      phone: JsonHelper.toStringValue(json['phone']) ?? '',
      userType: JsonHelper.toStringValue(json['user_type']) ?? '',
      location: JsonHelper.toStringValue(json['location']) ?? '',
      institution: JsonHelper.toStringValue(json['institution']) ?? '',
      className: JsonHelper.toStringValue(json['class_name']) ?? '',
      semester: JsonHelper.toStringValue(json['semester']) ?? '',
      createdAt: JsonHelper.toStringValue(json['created_at']) ?? '',
      updatedAt: JsonHelper.toStringValue(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'user_type': userType,
      'location': location,
      'institution': institution,
      'class_name': className,
      'semester': semester,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
