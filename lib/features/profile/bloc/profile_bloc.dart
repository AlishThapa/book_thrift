import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_thrift/core/data/app_repository.dart';
import 'package:book_thrift/features/profile/repo/profile_repo.dart';
import 'package:book_thrift/features/auth/models/user_profile.dart';
import 'package:logger/logger.dart';

import '../../../core/di/injection.dart';
import '../../../core/storage/storage_service.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({required this.localRepo, required this.profileRepo}) : super(const ProfileState()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<ResetSession>((e, emit) async {
      await localRepo.clearAll();
      emit(const ProfileState());
    });
  }

  final AppRepository localRepo;
  final ProfileRepo profileRepo;

  Future<void> _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) async {
    try {
      // First load from local
      final localProfile = await localRepo.profile();
      if (localProfile != null) {
        emit(state.copyWith(profile: localProfile));
      }

      // Check if we have a token before fetching from API
      final token = getIt<StorageService>().getAccessToken();
      Logger().d("token is $token");
      if (token == null || token.isEmpty) {
        return;
      }

      // Then fetch from API
      final profileData = await profileRepo.getProfile();

      final remoteProfile = UserProfile(
        id: profileData.id,
        fullName: profileData.fullName,
        email: profileData.email,
        phone: profileData.phone,
        userType: profileData.userType,
        institutionName: profileData.institution,
        classOrCourse: profileData.className,
        semesterOrYear: profileData.semester,
        location: profileData.location,
        createdAt: profileData.createdAt,
        updatedAt: profileData.updatedAt,
        imagePath: localProfile?.imagePath, // Preserve local image if any
      );

      // Save to local and emit
      await localRepo.saveProfile(remoteProfile);
      emit(state.copyWith(profile: remoteProfile));
    } catch (e) {
      // If API fails, we still have local profile (if any)
    }
  }

  Future<void> _onUpdateProfile(UpdateProfile event, Emitter<ProfileState> emit) async {
    try {
      final profileData = await profileRepo.updateProfile(
        fullName: event.fullName,
        email: event.email,
        phone: event.phone,
        userType: event.userType,
        location: event.location,
        institution: event.institution,
        className: event.className,
        semester: event.semester,
      );

      final updatedProfile = UserProfile(
        id: profileData.id,
        fullName: profileData.fullName,
        email: profileData.email,
        phone: profileData.phone,
        userType: profileData.userType,
        institutionName: profileData.institution,
        classOrCourse: profileData.className,
        semesterOrYear: profileData.semester,
        location: profileData.location,
        createdAt: profileData.createdAt,
        updatedAt: profileData.updatedAt,
        imagePath: event.imagePath ?? state.profile?.imagePath, // Use new image path if provided
      );

      await localRepo.saveProfile(updatedProfile);
      emit(state.copyWith(profile: updatedProfile));
    } catch (e) {
      // Handle error (optionally emit an error state)
    }
  }
}
