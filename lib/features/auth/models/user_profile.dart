import 'package:hive/hive.dart';
import 'package:book_thrift/core/hive/hive_type_ids.dart';

class UserProfile {
  UserProfile({
    this.id,
    this.uid,
    required this.fullName,
    required this.email,
    this.password,
    required this.phone,
    required this.userType,
    required this.institutionName,
    required this.classOrCourse,
    required this.semesterOrYear,
    required this.location,
    this.imagePath,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final String? uid;
  final String fullName;
  final String email;
  final String? password;
  final String phone;
  final String userType;
  final String institutionName;
  final String classOrCourse;
  final String semesterOrYear;
  final String location;
  final String? imagePath;
  final String? createdAt;
  final String? updatedAt;

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      uid: json['uid'],
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      userType: json['user_type'] ?? '',
      location: json['location'] ?? '',
      institutionName: json['institution'] ?? '',
      classOrCourse: json['class_name'] ?? '',
      semesterOrYear: json['semester'] ?? '',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'full_name': fullName,
      'email': email,
      if (password != null) 'password': password,
      'phone': phone,
      'user_type': userType,
      'location': location,
      'institution': institutionName,
      'class_name': classOrCourse,
      'semester': semesterOrYear,
    };
  }

  UserProfile copyWith({
    int? id,
    String? uid,
    String? fullName,
    String? email,
    String? password,
    String? phone,
    String? userType,
    String? institutionName,
    String? classOrCourse,
    String? semesterOrYear,
    String? location,
    String? imagePath,
    String? createdAt,
    String? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      userType: userType ?? this.userType,
      institutionName: institutionName ?? this.institutionName,
      classOrCourse: classOrCourse ?? this.classOrCourse,
      semesterOrYear: semesterOrYear ?? this.semesterOrYear,
      location: location ?? this.location,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = HiveTypeIds.userProfile;

  @override
  UserProfile read(BinaryReader reader) {
    final fullName = reader.readString();
    final email = reader.readString();
    final phone = reader.readString();
    final userType = reader.readString();
    final institutionName = reader.readString();
    final classOrCourse = reader.readString();
    final semesterOrYear = reader.readString();
    final location = reader.readString();
    final imagePath = reader.readString();

    int? id;
    String? uid;
    String? createdAt;
    String? updatedAt;

    // Safely read new fields if they exist (migration support)
    if (reader.availableBytes > 0) {
      try {
        id = reader.read() as int?;
        if (reader.availableBytes > 0) {
          uid = reader.read() as String?;
        }
        if (reader.availableBytes > 0) {
          createdAt = reader.read() as String?;
        }
        if (reader.availableBytes > 0) {
          updatedAt = reader.read() as String?;
        }
      } catch (_) {
        // Fallback for unexpected data format at the end
      }
    }

    return UserProfile(
      id: id,
      uid: uid,
      fullName: fullName,
      email: email,
      phone: phone,
      userType: userType,
      institutionName: institutionName,
      classOrCourse: classOrCourse,
      semesterOrYear: semesterOrYear,
      location: location,
      imagePath: imagePath,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeString(obj.fullName)
      ..writeString(obj.email)
      ..writeString(obj.phone)
      ..writeString(obj.userType)
      ..writeString(obj.institutionName)
      ..writeString(obj.classOrCourse)
      ..writeString(obj.semesterOrYear)
      ..writeString(obj.location)
      ..writeString(obj.imagePath ?? '')
      ..write(obj.id)
      ..write(obj.uid)
      ..write(obj.createdAt)
      ..write(obj.updatedAt);
  }
}
