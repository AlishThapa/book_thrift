import 'package:flutter/material.dart';
import 'package:book_thrift/constants/app_colors.dart';
import 'package:book_thrift/features/listing/models/book_listing.dart';

/// Vertical book card used in the horizontal recommended list.
/// Shows title, condition, price (with original crossed out), and a wishlist toggle.
class BookCard extends StatefulWidget {
  const BookCard({
    super.key,
    required this.listing,
    required this.onTap,
  });

  final BookListing listing;
  final VoidCallback onTap;

  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  bool _wishlisted = false;

  void _toggleWishlist() => setState(() => _wishlisted = !_wishlisted);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 170,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border, width: 0.8),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.07),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover image area
              _BookCoverPlaceholder(),

              const SizedBox(height: 10),

              // Title
              Text(
                widget.listing.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 6),

              // Condition badge
              _ConditionBadge(condition: widget.listing.condition),

              const Spacer(),

              // Price row
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _PriceBadge(price: widget.listing.sellingPrice),
                  const Spacer(),
                  _WishlistButton(
                    wishlisted: _wishlisted,
                    onTap: _toggleWishlist,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Book cover placeholder — swap with CachedNetworkImage when imageUrl is available.
class _BookCoverPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Icon(
          Icons.menu_book_rounded,
          size: 44,
          color: AppColors.primary.withOpacity(0.5),
        ),
      ),
    );
  }
}

class _ConditionBadge extends StatelessWidget {
  const _ConditionBadge({required this.condition});

  /// e.g. "Like New", "Good", "Fair"
  final String? condition;

  @override
  Widget build(BuildContext context) {
    final label = (condition?.isNotEmpty == true) ? condition! : 'Good';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: AppColors.success,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _PriceBadge extends StatelessWidget {
  const _PriceBadge({required this.price});

  final double price;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.success,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '₹${price.toStringAsFixed(0)}',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: AppColors.surface,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _WishlistButton extends StatelessWidget {
  const _WishlistButton({
    required this.wishlisted,
    required this.onTap,
  });

  final bool wishlisted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, animation) =>
            ScaleTransition(scale: animation, child: child),
        child: Icon(
          wishlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          key: ValueKey(wishlisted),
          color: AppColors.accent,
          size: 20,
        ),
      ),
    );
  }
}