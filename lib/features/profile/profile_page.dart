import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_thrift/constants/design_tokens.dart';
import 'package:book_thrift/core/router/app_router.gr.dart';
import 'package:book_thrift/features/profile/bloc/profile_bloc.dart';
import 'package:book_thrift/features/profile/widgets/profile_header.dart';
import 'package:book_thrift/features/profile/widgets/profile_stats.dart';

@RoutePage()
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // backgroundColor: colorScheme.surface,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            final p = state.profile;
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ProfileBloc>().add(LoadProfile());
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: ProfileHeader(
                      profile: p,
                      onEdit: () async {
                        await context.pushRoute(EditProfileRoute(profile: p));
                        if (!context.mounted) return;
                        context.read<ProfileBloc>().add(LoadProfile());
                      },
                    ),
                  ),
                  const SliverToBoxAdapter(child: ProfileStats()),
                  const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _sectionTitle(context, 'Store Management'),
                        _tile(
                          context,
                          Icons.inventory_2_outlined,
                          'My Listings',
                          'Manage your listed books',
                          () => context.pushRoute(const MyListingsRoute()),
                          color: Colors.blueAccent,
                        ),
                          _tile(
                          context,
                          Icons.storefront_outlined,
                          'Public Profile',
                          'View your store as others see it',
                          () => context.pushRoute(const PublicSellerProfileRoute()),
                          color: Colors.orangeAccent,
                        ),
                        _sectionTitle(context, 'Preferences'),
                        _tile(
                          context,
                          Icons.favorite_rounded,
                          'Wishlist',
                          'Books you\'ve saved for later',
                          () => context.pushRoute(const WishlistRoute()),
                          color: Colors.pinkAccent,
                        ),
                        _tile(
                          context,
                          Icons.notifications_active_outlined,
                          'Notifications',
                          'Alerts, messages, and updates',
                          () => context.pushRoute(const NotificationsRoute()),
                          color: Colors.teal,
                        ),
                        _tile(
                          context,
                          Icons.settings_suggest_outlined,
                          'Settings',
                          'App preferences and account security',
                          () => context.pushRoute(const SettingsRoute()),
                          color: Colors.blueGrey,
                        ),
                        const SizedBox(height: 120),
                      ]),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.xs, 0, 0, AppSpacing.sm),
      child: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(fontSize: 14, fontWeight: FontWeight.w800, color: theme.colorScheme.onSurface.withValues(alpha: 0.8)),
      ),
    );
  }

  Widget _tile(BuildContext context, IconData icon, String title, String subtitle, VoidCallback onTap, {Color? color}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final themeColor = color ?? colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey.withValues(alpha: 0.3)
              : colorScheme.outline.withValues(alpha: 0.1),
        ),
        boxShadow: [BoxShadow(color: colorScheme.shadow.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(4, 4))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(color: themeColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                  child: Icon(icon, color: themeColor, size: 22),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: textTheme.titleMedium?.copyWith(fontSize: 15, color: colorScheme.onSurface)),
                      const SizedBox(height: 2),
                      Text(subtitle, style: textTheme.bodySmall?.copyWith(fontSize: 12, color: colorScheme.onSurfaceVariant)),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: 14, color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
