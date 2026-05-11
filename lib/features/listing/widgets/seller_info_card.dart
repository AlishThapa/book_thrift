import 'package:flutter/material.dart';
import 'package:book_thrift/constants/design_tokens.dart';

class SellerInfoCard extends StatelessWidget {
  const SellerInfoCard({
    super.key,
    required this.sellerName,
    required this.rating,
    required this.reviewsCount,
    this.onTap,
  });

  final String sellerName;
  final double rating;
  final int reviewsCount;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
            child: Text(
              sellerName[0],
              style: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sellerName,
                  style: textTheme.titleMedium,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.star_rounded, size: 16, color: colorScheme.tertiary),
                    const SizedBox(width: 4),
                    Text(
                      '$rating ($reviewsCount reviews)',
                      style: textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onTap,
            icon: Icon(Icons.chevron_right_rounded, color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
