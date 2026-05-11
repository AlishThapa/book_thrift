import 'package:flutter/material.dart';
import 'package:book_thrift/constants/app_colors.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, $name 👋',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.primary.withOpacity(0.15) : AppColors.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? AppColors.primary.withOpacity(0.3) : AppColors.secondary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Text(
                  '✨ Find your next thrift read',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDark ? AppColors.primaryLight : AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : AppColors.neutralLight,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black26 : AppColors.primary.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            onPressed: onNotifications,
            icon: Icon(
              Icons.notifications_none_rounded,
              color: isDark ? Colors.white : AppColors.primary,
              size: 26,
            ),
          ),
        ),
      ],
    );
  }
}