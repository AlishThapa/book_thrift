import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_thrift/constants/app_colors.dart';
import 'package:book_thrift/constants/design_tokens.dart';
import 'package:book_thrift/constants/size_constants.dart';
import 'package:book_thrift/core/data/app_repository.dart';
import 'package:book_thrift/core/data/seed_data.dart';
import 'package:book_thrift/core/di/injection.dart';
import 'package:book_thrift/features/auth/auth_entry_page.dart';
import 'package:book_thrift/features/auth/models/user_profile.dart';
import 'package:book_thrift/features/profile/bloc/profile_bloc.dart';
import 'package:book_thrift/features/settings/bloc/settings_bloc.dart';
import 'package:book_thrift/features/settings/widgets/settings_group.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, settingsState) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            children: [
              SettingsGroup(
                title: 'Appearance',
                children: [
                  SwitchListTile(
                    value: settingsState.themeMode == ThemeMode.dark,
                    onChanged: (v) => context.read<SettingsBloc>().add(ToggleDarkMode(v)),
                    title: const Text('Dark Mode'),
                    secondary: const Icon(Icons.dark_mode_rounded),
                  ),
                ],
              ),
              SettingsGroup(
                title: 'Notifications',
                children: [
                  SwitchListTile(
                    value: settingsState.notificationsEnabled,
                    onChanged: (v) => context.read<SettingsBloc>().add(ToggleNotifications(v)),
                    title: const Text('Push Notifications'),
                    secondary: const Icon(Icons.notifications_rounded),
                  ),
                ],
              ),
              SettingsGroup(
                title: 'General',
                children: [
                  const AboutListTile(
                    applicationName: 'BookLoop',
                    applicationVersion: '1.0.0',
                    icon: const Icon(Icons.info_rounded),
                    child: Text('About BookLoop'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.restart_alt_rounded, color: AppColors.warning),
                    title: const Text('Clear local data & reseed'),
                    onTap: () => _showResetConfirmation(context),
                  ),
                ],
              ),
              const SizedBox(height: HeightConstants.md),
              SettingsGroup(
                title: 'Account',
                children: [
                  ListTile(
                    leading: const Icon(Icons.logout_rounded),
                    title: const Text('Logout'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const AuthEntryPage()),
                        (_) => false,
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete_forever_rounded, color: AppColors.error),
                    title: const Text('Delete Profile', style: TextStyle(color: AppColors.error)),
                    trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.error),
                    onTap: () => _showDeleteConfirmation(context),
                  ),
                ],
              ),
              const SizedBox(height: HeightConstants.xl),
              Center(
                child: Text(
                  'Version 1.0.0 (Build 1)',
                  style: AppTextStyles.caption,
                ),
              ),
              const SizedBox(height: HeightConstants.xl),
            ],
          );
        },
      ),
    );
  }

  void _showResetConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Data?'),
        content: const Text('This will clear all local data and reseed with initial data. This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final repo = getIt<AppRepository>();
              await repo.clearAll();
              for (final listing in SeedData.listings()) {
                await repo.saveListing(listing);
              }
              for (final thread in SeedData.threads()) {
                await repo.saveThread(thread);
              }
              for (final n in SeedData.notifications()) {
                await repo.saveNotification(n);
              }
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data reset complete'), behavior: SnackBarBehavior.floating),
              );
            },
            child: const Text('Reset', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Profile?'),
        content: const Text('Are you sure you want to delete your profile? This action is permanent.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final p = context.read<ProfileBloc>().state.profile;
              if (p == null) return;
              await getIt<AppRepository>().saveProfile(
                UserProfile(
                  fullName: 'Deleted User',
                  email: '',
                  phone: '',
                  userType: p.userType,
                  institutionName: '',
                  classOrCourse: '',
                  semesterOrYear: '',
                  location: '',
                  imagePath: p.imagePath,
                ),
              );
              if (!context.mounted) return;
              context.read<ProfileBloc>().add(LoadProfile());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile deleted'), behavior: SnackBarBehavior.floating),
              );
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
