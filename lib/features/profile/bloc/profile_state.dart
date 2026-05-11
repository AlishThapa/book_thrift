part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  const ProfileState({this.profile});
  final UserProfile? profile;
  ProfileState copyWith({UserProfile? profile}) => ProfileState(profile: profile ?? this.profile);
  @override
  List<Object?> get props => [profile];
}
