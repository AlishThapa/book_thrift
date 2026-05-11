import 'package:flutter/material.dart';
import 'package:book_thrift/constants/app_colors.dart';
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
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: Text(
              sellerName[0],
              style: const TextStyle(
                color: AppColors.primary,
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
                  style: AppTextStyles.cardTitle,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, size: 16, color: AppColors.warning),
                    const SizedBox(width: 4),
                    Text(
                      '$rating ($reviewsCount reviews)',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onTap,
            icon: const Icon(Icons.chevron_right_rounded, color: AppColors.neutral),
          ),
        ],
      ),
    );
  }
}
