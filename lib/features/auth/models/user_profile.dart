import 'package:hive/hive.dart';
import 'package:book_thrift/core/hive/hive_type_ids.dart';

class UserProfile {
  UserProfile({required this.fullName, required this.email, required this.phone, required this.userType, required this.institutionName, required this.classOrCourse, required this.semesterOrYear, required this.location, required this.imagePath});
  final String fullName;
  final String email;
  final String phone;
  final String userType;
  final String institutionName;
  final String classOrCourse;
  final String semesterOrYear;
  final String location;
  final String imagePath;
}

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = HiveTypeIds.userProfile;

  @override
  UserProfile read(BinaryReader reader) => UserProfile(
        fullName: reader.readString(), email: reader.readString(), phone: reader.readString(), userType: reader.readString(),
        institutionName: reader.readString(), classOrCourse: reader.readString(), semesterOrYear: reader.readString(),
        location: reader.readString(), imagePath: reader.readString(),
      );

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeString(obj.fullName)..writeString(obj.email)..writeString(obj.phone)..writeString(obj.userType)
      ..writeString(obj.institutionName)..writeString(obj.classOrCourse)..writeString(obj.semesterOrYear)
      ..writeString(obj.location)..writeString(obj.imagePath);
  }
}
