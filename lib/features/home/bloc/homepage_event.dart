part of 'homepage_bloc.dart';

sealed class HomepageEvent extends Equatable {
  const HomepageEvent();

  @override
  List<Object?> get props => [];
}

class LoadHomepage extends HomepageEvent {}

class SelectCategory extends HomepageEvent {
  const SelectCategory(this.category);

  final String category;

  @override
  List<Object?> get props => [category];
}

class RequestLocationPermission extends HomepageEvent {}

class UpdateLocationPermissionStatus extends HomepageEvent {
  const UpdateLocationPermissionStatus(this.status);
  final LocationPermissionStatus status;

  @override
  List<Object?> get props => [status];
}
