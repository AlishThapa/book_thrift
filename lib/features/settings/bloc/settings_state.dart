part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  const SettingsState({
    this.themeMode = ThemeMode.light,
    this.notificationsEnabled = true,
  });

  final ThemeMode themeMode;
  final bool notificationsEnabled;

  SettingsState copyWith({ThemeMode? themeMode, bool? notificationsEnabled}) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }

  @override
  List<Object?> get props => [themeMode, notificationsEnabled];
}
