import 'package:flutter/material.dart';
import 'package:book_thrift/constants/app_colors.dart';
import 'package:book_thrift/constants/design_tokens.dart';
import 'package:book_thrift/features/listing/book_detail_page.dart';
import 'package:book_thrift/features/listing/models/book_listing.dart';

class ChatBookHeader extends StatelessWidget {
  const ChatBookHeader({super.key, required this.listing});
  final BookListing listing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildThumbnail(),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  listing.title,
                  style: AppTextStyles.cardTitle.copyWith(fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '₹${listing.sellingPrice.toStringAsFixed(0)}',
                  style: AppTextStyles.price.copyWith(fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          _buildViewButton(context),
        ],
      ),
    );
  }

  Widget _buildThumbnail() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: const Icon(Icons.book_rounded, color: AppColors.primary, size: 20),
    );
  }

  Widget _buildViewButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BookDetailPage(listing: listing),
          ),
        );
      },
      style: TextButton.styleFrom(
        visualDensity: VisualDensity.compact,
        foregroundColor: AppColors.primary,
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
      ),
      child: const Text('VIEW'),
    );
  }
}
