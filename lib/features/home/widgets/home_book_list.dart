import 'package:book_thrift/features/listing/models/book_listing.dart';
import 'package:flutter/material.dart';
import 'package:book_thrift/constants/design_tokens.dart';
import 'package:book_thrift/features/home/widgets/book_card.dart';
import 'package:book_thrift/features/home/widgets/book_card_skeleton.dart';

class HomeBookList extends StatelessWidget {
  const HomeBookList({
    super.key,
    required this.listings,
    required this.onBookTap,
    this.heroPrefix = 'home',
  });

  final List<BookListing> listings;
  final ValueChanged<BookListing> onBookTap;
  final String heroPrefix;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      scrollDirection: Axis.horizontal,
      itemCount: listings.length,
      separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
      itemBuilder: (context, index) {
        final listing = listings[index];
        final heroTag = '${heroPrefix}_book_image_${listing.id}';
        return BookCard(
          listing: listing,
          heroTag: heroTag,
          onTap: () => onBookTap(listing),
        );
      },
    );
  }
}

class SkeletonList extends StatelessWidget {
  const SkeletonList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      scrollDirection: Axis.horizontal,
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
      itemBuilder: (_, __) => const BookCardSkeleton(),
    );
  }
}
