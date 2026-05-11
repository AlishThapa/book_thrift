import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_thrift/core/data/app_repository.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc(this._repo) : super(const SettingsState()) {
    on<LoadSettings>(_loadSettings);
    on<ToggleDarkMode>(_toggleDarkMode);
    on<ToggleNotifications>(_toggleNotifications);
  }

  final AppRepository _repo;

  Future<void> _loadSettings(LoadSettings event, Emitter<SettingsState> emit) async {
    final darkMode = await _repo.getBoolPref('dark_mode');
    final notificationsEnabled = await _repo.getBoolPref('notifications_enabled', fallback: true);
    emit(
      state.copyWith(
        themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
        notificationsEnabled: notificationsEnabled,
      ),
    );
  }

  Future<void> _toggleDarkMode(ToggleDarkMode event, Emitter<SettingsState> emit) async {
    await _repo.setBoolPref('dark_mode', event.enabled);
    emit(state.copyWith(themeMode: event.enabled ? ThemeMode.dark : ThemeMode.light));
  }

  Future<void> _toggleNotifications(ToggleNotifications event, Emitter<SettingsState> emit) async {
    await _repo.setBoolPref('notifications_enabled', event.enabled);
    emit(state.copyWith(notificationsEnabled: event.enabled));
  }
}
