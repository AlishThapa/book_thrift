import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_thrift/constants/app_colors.dart';
import 'package:book_thrift/features/listing/models/book_listing.dart';
import 'package:book_thrift/features/wishlist/bloc/wishlist_bloc.dart';

class BookCard extends StatelessWidget {
  const BookCard({super.key, required this.listing, required this.onTap});

  final BookListing listing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0, right: 3),
        child: Container(
          width: 170,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.withValues(alpha: 0.3) : colorScheme.outline.withValues(alpha: 0.1)),
            boxShadow: [BoxShadow(color: colorScheme.shadow.withValues(alpha: 0.1), blurRadius: 5, offset: const Offset(3, 3))],
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover image area
              _BookCoverPlaceholder(),

              const SizedBox(height: 10),

              // Title
              Text(
                listing.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: colorScheme.onSurface, height: 1.3),
              ),

              const SizedBox(height: 6),

              // Condition badge
              _ConditionBadge(condition: listing.condition),

              const Spacer(),

              // Price row
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _PriceBadge(price: listing.sellingPrice),
                  const Spacer(),
                  BlocBuilder<WishlistBloc, WishlistState>(
                    builder: (context, state) {
                      final isWishlisted = state.ids.contains(listing.id);
                      return _WishlistButton(wishlisted: isWishlisted, onTap: () => context.read<WishlistBloc>().add(ToggleWishlist(listing.id)));
                    },
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
      decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.07), borderRadius: BorderRadius.circular(12)),
      child: Center(child: Icon(Icons.menu_book_rounded, size: 44, color: AppColors.primary.withValues(alpha: 0.5))),
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
      decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.success, fontWeight: FontWeight.w600),
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
      decoration: BoxDecoration(color: AppColors.success, borderRadius: BorderRadius.circular(10)),
      child: Text(
        'NPR ${price.toStringAsFixed(0)}',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.surface, fontWeight: FontWeight.w700, letterSpacing: 0.3),
      ),
    );
  }
}

class _WishlistButton extends StatelessWidget {
  const _WishlistButton({required this.wishlisted, required this.onTap});

  final bool wishlisted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
        child: Icon(wishlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded, key: ValueKey(wishlisted), color: AppColors.accent, size: 20),
      ),
    );
  }
}
