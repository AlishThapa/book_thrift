import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_thrift/constants/widgets/app_surface.dart';
import 'package:book_thrift/core/data/app_repository.dart';
import 'package:book_thrift/core/data/seed_data.dart';
import 'package:book_thrift/core/di/injection.dart';
import 'package:book_thrift/features/auth/auth_entry_page.dart';
import 'package:book_thrift/features/auth/models/user_profile.dart';
import 'package:book_thrift/features/profile/bloc/profile_bloc.dart';
import 'package:book_thrift/features/settings/bloc/settings_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, settingsState) {
          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              AppSurface(
                child: SwitchListTile(
                  value: settingsState.themeMode == ThemeMode.dark,
                  onChanged: (v) => context.read<SettingsBloc>().add(ToggleDarkMode(v)),
                  title: const Text('Dark mode'),
                ),
              ),
              const SizedBox(height: 8),
              AppSurface(
                child: SwitchListTile(
                  value: settingsState.notificationsEnabled,
                  onChanged: (v) => context.read<SettingsBloc>().add(ToggleNotifications(v)),
                  title: const Text('Notifications'),
                ),
              ),
              const SizedBox(height: 8),
              const AppSurface(child: AboutListTile(applicationName: 'BookLoop', applicationVersion: '1.0.0')),
              const SizedBox(height: 8),
              AppSurface(
                child: ListTile(
                  leading: const Icon(Icons.restart_alt_rounded),
                  title: const Text('Clear local data & reseed'),
                  onTap: () async {
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
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data reset complete')));
                  },
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const AuthEntryPage()), (_) => false);
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                onPressed: () async {
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
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile deleted')));
                },
                icon: const Icon(Icons.delete_outline),
                label: const Text('Delete profile'),
              ),
            ],
          );
        },
      ),
    );
  }
}
