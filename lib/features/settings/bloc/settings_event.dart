part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSettings extends SettingsEvent {}

class ToggleDarkMode extends SettingsEvent {
  const ToggleDarkMode(this.enabled);

  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}

class ToggleNotifications extends SettingsEvent {
  const ToggleNotifications(this.enabled);

  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}
