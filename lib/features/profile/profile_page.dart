import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_thrift/constants/app_colors.dart';
import 'package:book_thrift/constants/design_tokens.dart';
import 'package:book_thrift/features/my_listings/my_listings_page.dart';
import 'package:book_thrift/features/notifications/notifications_page.dart';
import 'package:book_thrift/features/profile/bloc/profile_bloc.dart';
import 'package:book_thrift/features/profile/edit_profile_page.dart';
import 'package:book_thrift/features/profile/public_seller_profile_page.dart';
import 'package:book_thrift/features/profile/widgets/profile_header.dart';
import 'package:book_thrift/features/profile/widgets/profile_stats.dart';
import 'package:book_thrift/features/settings/settings_page.dart';
import 'package:book_thrift/features/wishlist/wishlist_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          final p = state.profile;
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: ProfileHeader(
                  profile: p,
                  onEdit: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => EditProfilePage(profile: p)),
                    );
                    if (!context.mounted) return;
                    context.read<ProfileBloc>().add(LoadProfile());
                  },
                ),
              ),
              const SliverToBoxAdapter(child: ProfileStats()),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _sectionTitle('Store Management'),
                    _tile(
                      context,
                      Icons.inventory_2_outlined,
                      'My Listings',
                      'Manage your listed books',
                      () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MyListingsPage())),
                      color: Colors.blueAccent,
                    ),
                    _tile(
                      context,
                      Icons.storefront_outlined,
                      'Public Profile',
                      'View your store as others see it',
                      () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PublicSellerProfilePage())),
                      color: Colors.orangeAccent,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _sectionTitle('Preferences'),
                    _tile(
                      context,
                      Icons.favorite_rounded,
                      'Wishlist',
                      'Books you\'ve saved for later',
                      () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WishlistPage())),
                      color: Colors.pinkAccent,
                    ),
                    _tile(
                      context,
                      Icons.notifications_active_outlined,
                      'Notifications',
                      'Alerts, messages, and updates',
                      () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsPage())),
                      color: Colors.teal,
                    ),
                    _tile(
                      context,
                      Icons.settings_suggest_outlined,
                      'Settings',
                      'App preferences and account security',
                      () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage())),
                      color: Colors.blueGrey,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.xs, AppSpacing.sm, 0, AppSpacing.sm),
      child: Text(
        title,
        style: AppTextStyles.sectionTitle.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary.withValues(alpha: 0.8),
        ),
      ),
    );
  }

  Widget _tile(BuildContext context, IconData icon, String title, String subtitle, VoidCallback onTap, {Color? color}) {
    final themeColor = color ?? AppColors.primary;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
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
                  decoration: BoxDecoration(
                    color: themeColor.withValues(alpha: 0.1),
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
                        style: AppTextStyles.cardTitle.copyWith(
                          fontSize: 15,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: AppColors.textLight.withValues(alpha: 0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
