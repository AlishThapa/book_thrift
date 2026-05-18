import 'package:flutter/material.dart';
import 'package:book_thrift/constants/design_tokens.dart';
import 'package:book_thrift/features/auth/models/user_profile.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.profile, required this.onEdit});

  final UserProfile? profile;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary,
            colorScheme.secondary,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(22), bottomRight: Radius.circular(22)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
            child: Row(
              children: [
                Text(
                  'Account',
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: colorScheme.onPrimary.withValues(alpha: 0.5), width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor: colorScheme.onPrimary.withValues(alpha: 0.2),
                    backgroundImage: (profile?.imagePath != null && profile!.imagePath!.isNotEmpty) ? NetworkImage(profile!.imagePath!) : null,
                    child: (profile?.imagePath == null || profile!.imagePath!.isEmpty) ? Icon(Icons.person, size: 35, color: colorScheme.onPrimary) : null,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile?.fullName ?? 'Guest User',
                        style: TextStyle(
                          color: colorScheme.onPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          shadows: [Shadow(offset: const Offset(0, 1), blurRadius: 2, color: colorScheme.shadow.withValues(alpha: 0.3))],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        profile?.institutionName ?? 'Join a Campus',
                        style: TextStyle(color: colorScheme.onPrimary.withValues(alpha: 0.9), fontSize: 14, fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        profile?.location ?? 'Add location',
                        style: TextStyle(color: colorScheme.onPrimary.withValues(alpha: 0.7), fontSize: 12),
                      ),
                    ],
                  ),
                ),
                IconButton.filledTonal(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_rounded, size: 18),
                  style: IconButton.styleFrom(
                    backgroundColor: colorScheme.onPrimary.withValues(alpha: 0.2),
                    foregroundColor: colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
