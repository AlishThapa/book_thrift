import 'package:flutter/material.dart';
import 'package:book_thrift/constants/app_colors.dart';

/// Top greeting header with user name, tagline, and notification bell.
class ModernHeader extends StatelessWidget {
  const ModernHeader({
    super.key,
    required this.name,
    required this.onNotifications,
  });

  final String name;
  final VoidCallback onNotifications;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, $name 👋',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              _TaglineBadge(),
            ],
          ),
        ),
        const SizedBox(width: 12),
        _NotificationButton(onTap: onNotifications),
      ],
    );
  }
}

class _TaglineBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.15),
        ),
      ),
      child: Text(
        '✨ Find your next thrift read',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _NotificationButton extends StatelessWidget {
  const _NotificationButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.neutralLight,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(
            Icons.notifications_none_rounded,
            color: AppColors.primary,
            size: 24,
          ),
        ),
      ),
    );
  }
}