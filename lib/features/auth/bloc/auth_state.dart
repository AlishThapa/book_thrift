part of 'auth_bloc.dart';

enum AuthStatus { initial, loading, success, failure, registered }

class AuthState extends Equatable {
  final AuthStatus status;
  final UserProfile? userProfile;
  final String? errorMessage;
  final String selectedUserType;

  const AuthState({
    this.status = AuthStatus.initial,
    this.userProfile,
    this.errorMessage,
    this.selectedUserType = "student",
  });

  AuthState copyWith({
    AuthStatus? status,
    UserProfile? userProfile,
    String? errorMessage,
    String? selectedUserType,
  }) {
    return AuthState(
      status: status ?? this.status,
      userProfile: userProfile ?? this.userProfile,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedUserType: selectedUserType ?? this.selectedUserType,
    );
  }

  @override
  List<Object?> get props => [status, userProfile, errorMessage, selectedUserType];
}
