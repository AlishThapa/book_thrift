import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:book_thrift/constants/design_tokens.dart';
import 'package:book_thrift/core/router/app_router.gr.dart';

class ProfileMenuList extends StatelessWidget {
  const ProfileMenuList({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
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
          const SizedBox(height: AppSpacing.sm),
          _sectionTitle(context, '🏆 My Progress'),
          _tile(
            context,
            Icons.emoji_events_outlined,
            'Badges & Rank',
            'See your achievements and standing',
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Badges & Rank coming soon!')),
              );
            },
            color: Colors.amber,
          ),
          _tile(
            context,
            Icons.local_fire_department_outlined,
            'Active Challenge',
            'Complete goals to earn rewards',
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Active Challenge coming soon!')),
              );
            },
            color: Colors.deepOrange,
          ),
          const SizedBox(height: AppSpacing.sm),
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
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.xs, 0, 0, AppSpacing.sm),
      child: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
        ),
      ),
    );
  }

  Widget _tile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap, {
    Color? color,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final themeColor = color ?? colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: theme.brightness == Brightness.dark
              ? Colors.grey.withValues(alpha: 0.2)
              : colorScheme.outline.withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm + 2,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        themeColor.withValues(alpha: 0.15),
                        themeColor.withValues(alpha: 0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: themeColor, size: 22),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: textTheme.titleMedium?.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: textTheme.bodySmall?.copyWith(
                          fontSize: 12,
                          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 10,
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
