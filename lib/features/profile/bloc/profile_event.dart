part of 'profile_bloc.dart';
sealed class ProfileEvent extends Equatable { const ProfileEvent(); @override List<Object?> get props => []; }
class LoadProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final String? fullName;
  final String? email;
  final String? phone;
  final String? userType;
  final String? location;
  final String? institution;
  final String? className;
  final String? semester;
  final String? imagePath;

  const UpdateProfile({
    this.fullName,
    this.email,
    this.phone,
    this.userType,
    this.location,
    this.institution,
    this.className,
    this.semester,
    this.imagePath,
  });

  @override
  List<Object?> get props => [
        fullName,
        email,
        phone,
        userType,
        location,
        institution,
        className,
        semester,
        imagePath,
      ];
}

class ResetSession extends ProfileEvent {}
