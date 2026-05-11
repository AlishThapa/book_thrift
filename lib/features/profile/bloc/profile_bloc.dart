import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_thrift/core/data/app_repository.dart';

import '../../auth/models/user_profile.dart';
part  'profile_event.dart';
part  'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(this.repo) : super(const ProfileState()) {
    on<LoadProfile>((e, emit) async => emit(state.copyWith(profile: await repo.profile())));
    on<ResetSession>((e, emit) async {
      await repo.clearAll();
      emit(const ProfileState());
    });
  }
  final AppRepository repo;
}
