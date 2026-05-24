part of 'homepage_bloc.dart';

sealed class HomepageEvent extends Equatable {
  const HomepageEvent();

  @override
  List<Object?> get props => [];
}

class LoadHomepage extends HomepageEvent {}

class RequestLocationPermission extends HomepageEvent {}

class UpdateLocationPermissionStatus extends HomepageEvent {
  const UpdateLocationPermissionStatus(this.status);
  final LocationPermissionStatus status;

  @override
  List<Object?> get props => [status];
}
