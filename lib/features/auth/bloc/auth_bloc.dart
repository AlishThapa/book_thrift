import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_thrift/features/auth/models/user_profile.dart';
import 'package:book_thrift/features/auth/repository/repo.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthState()) {
    on<RegisterRequested>(_onRegisterRequested);
    on<LoginRequested>(_onLoginRequested);
    on<UserTypeChanged>(_onUserTypeChanged);
  }

  void _onUserTypeChanged(UserTypeChanged event, Emitter<AuthState> emit) {
    emit(state.copyWith(selectedUserType: event.userType));
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final profile = await _authRepository.register(event.profile);
      emit(state.copyWith(
        status: AuthStatus.registered,
        userProfile: profile,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final profile = await _authRepository.login(event.email, event.password);
      emit(state.copyWith(
        status: AuthStatus.success,
        userProfile: profile,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
