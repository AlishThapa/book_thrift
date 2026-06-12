import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:book_thrift/constants/design_tokens.dart';
import 'package:book_thrift/constants/app_colors.dart';
import 'package:book_thrift/constants/size_constants.dart';
import 'package:book_thrift/features/listing/models/book_listing.dart';

class BookCard extends StatelessWidget {
  const BookCard({
    super.key,
    required this.listing,
    this.onTap,
    this.trailing,
    this.grid = false,
    this.heroTag,
  });

  final BookListing listing;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool grid;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    return grid 
        ? _GridCard(listing: listing, onTap: onTap, heroTag: heroTag) 
        : _ListCard(listing: listing, onTap: onTap, trailing: trailing, heroTag: heroTag);
  }
}

class _ListCard extends StatelessWidget {
  const _ListCard({required this.listing, this.onTap, this.trailing, this.heroTag});
  final BookListing listing;
  final VoidCallback? onTap;
  final Widget? trailing;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      // margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: theme.brightness == Brightness.dark 
            ? Colors.grey.withValues(alpha: 0.3) 
            : colorScheme.outline.withValues(alpha: 0.1)
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Row(
              children: [
                _BookImage(listing: listing, size: HeightConstants.bookImageWidth, heroTag: heroTag),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              listing.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _ConditionBadge(condition: listing.condition),
                        ],
                      ),
                      const SizedBox(height: HeightConstants.tiny),
                      Text(
                        listing.author,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'NPR ${listing.sellingPrice.toStringAsFixed(0)}',
                            style: AppTextStyles.price.copyWith(
                              fontSize: 18,
                              color: theme.brightness == Brightness.dark
                                ? colorScheme.onPrimaryContainer
                                : colorScheme.primary,
                            ),
                          ),
                          if (trailing != null)
                            trailing!
                          else
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                            ),
                        ],
                      ),
                    ],
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

class _GridCard extends StatelessWidget {
  const _GridCard({required this.listing, this.onTap, this.heroTag});
  final BookListing listing;
  final VoidCallback? onTap;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: theme.brightness == Brightness.dark 
            ? Colors.grey.withValues(alpha: 0.3) 
            : colorScheme.outline.withValues(alpha: 0.1)
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      _BookImage(listing: listing, size: double.infinity, isGrid: true, heroTag: heroTag),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: _ConditionBadge(condition: listing.condition),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        listing.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        listing.author,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'NPR ${listing.sellingPrice.toStringAsFixed(0)}',
                            style: AppTextStyles.price.copyWith(
                              color: theme.brightness == Brightness.dark 
                                ? colorScheme.onPrimaryContainer 
                                : colorScheme.primary,
                            ),
                          ),
                          if (listing.negotiable)
                            const Icon(Icons.handshake_outlined, size: 16, color: AppColors.accent),
                        ],
                      ),
                    ],
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

class _BookImage extends StatelessWidget {
  const _BookImage({required this.listing, required this.size, this.isGrid = false, this.heroTag});
  final BookListing listing;
  final double size;
  final bool isGrid;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Hero(
      tag: heroTag ?? 'book_image_${listing.id}',
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: isGrid ? double.infinity : size,
          height: isGrid ? double.infinity : size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.primary.withValues(alpha: 0.1),
                colorScheme.primary.withValues(alpha: 0.05),
              ],
            ),
          ),
          child: listing.imagePaths.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: _buildImage(listing.imagePaths.first, colorScheme),
                )
              : const _BookPlaceholder(),
        ),
      ),
    );
  }

  Widget _buildImage(String path, ColorScheme colorScheme) {
    final isNetwork = path.startsWith('http');
    if (isNetwork) {
      return CachedNetworkImage(
        imageUrl: path,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: colorScheme.primary.withValues(alpha: 0.05),
          child: const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
        errorWidget: (context, url, error) => const _BookPlaceholder(),
      );
    } else {
      return Image.file(
        File(path),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const _BookPlaceholder(),
      );
    }
  }
}

class _BookPlaceholder extends StatelessWidget {
  const _BookPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        Icons.menu_book_rounded,
        size: 32,
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
      ),
    );
  }
}

class _ConditionBadge extends StatelessWidget {
  const _ConditionBadge({required this.condition});
  final String condition;

  @override
  Widget build(BuildContext context) {
    Color badgeColor;
    switch (condition.toLowerCase()) {
      case 'new':
        badgeColor = AppColors.success;
        break;
      case 'like new':
        badgeColor = AppColors.primary;
        break;
      case 'good':
        badgeColor = AppColors.accent;
        break;
      default:
        badgeColor = AppColors.neutral;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        condition,
        style: TextStyle(
          color: badgeColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
