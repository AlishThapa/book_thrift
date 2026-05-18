import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:book_thrift/constants/design_tokens.dart';
import 'package:book_thrift/features/listing/models/book_listing.dart';
import 'package:book_thrift/features/listing/widgets/book_detail_image_carousel.dart';
import 'package:book_thrift/features/listing/widgets/book_specs_grid.dart';
import 'package:book_thrift/features/listing/widgets/seller_info_card.dart';
import 'package:book_thrift/features/wishlist/bloc/wishlist_bloc.dart';
import 'package:book_thrift/features/cart/bloc/cart_bloc.dart';
import 'package:book_thrift/features/listing/bloc/listing_detail_bloc.dart';
import 'package:book_thrift/shared/widgets/system/bottom_cta_bar.dart';

@RoutePage()
class BookDetailPage extends StatefulWidget {
  const BookDetailPage({super.key, required this.listing, this.isOwner = false});
  final BookListing listing;
  final bool isOwner;

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  @override
  void initState() {
    super.initState();
    final bookId = int.tryParse(widget.listing.id);
    if (bookId != null) {
      context.read<ListingDetailBloc>().add(FetchListingDetail(bookId));
    }
  }

  void _onShare(BookListing listing) {
    Share.share('Check out this book: ${listing.title} by ${listing.author} for NPR ${listing.sellingPrice.toStringAsFixed(0)} on KitabSathi!', subject: 'Book Listing: ${listing.title}');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return BlocBuilder<ListingDetailBloc, ListingDetailState>(
      builder: (context, state) {
        final listing = state.listing ?? widget.listing;

        return Scaffold(
          backgroundColor: colorScheme.surfaceContainerLowest,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: colorScheme.onPrimary,
            actions: [
              BlocBuilder<WishlistBloc, WishlistState>(
                builder: (_, wishlistState) {
                  final selected = wishlistState.ids.contains(listing.id);
                  return IconButton(
                    onPressed: () => context.read<WishlistBloc>().add(ToggleWishlist(listing.id)),
                    icon: Icon(selected ? Icons.favorite : Icons.favorite_border, color: selected ? colorScheme.error : colorScheme.onPrimary),
                  );
                },
              ),
              IconButton(
                onPressed: () => _onShare(listing),
                icon: Icon(Icons.share_rounded, color: colorScheme.onPrimary),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: state.status == ListingDetailStatus.loading && state.listing == null
              ? const Center(child: CircularProgressIndicator())
              : state.status == ListingDetailStatus.failure && state.listing == null
              ? Center(child: Text('Error: ${state.errorMessage}'))
              : RefreshIndicator(
                  onRefresh: () async {
                    final bookId = int.tryParse(widget.listing.id);
                    if (bookId != null) {
                      final bloc = context.read<ListingDetailBloc>();
                      bloc.add(FetchListingDetail(bookId));
                      await bloc.stream.firstWhere((s) => s.status != ListingDetailStatus.loading);
                    }
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                        child: Container(
                          color: colorScheme.primary,
                          height: 350,
                          child: BookDetailImageCarousel(imagePaths: listing.imagePaths, listingId: listing.id),
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(0, -32),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                          child: Container(
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainer,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [BoxShadow(color: colorScheme.shadow.withValues(alpha: 0.08), blurRadius: 16, offset: const Offset(0, 4))],
                            ),
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title + price row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(listing.title.isEmpty ? 'Untitled Book' : listing.title, style: textTheme.headlineSmall),
                                          const SizedBox(height: 4),
                                          Text(
                                            listing.owner?.fullName != null ? 'by ${listing.owner!.fullName}' : (listing.author.isEmpty ? 'Unknown Author' : 'by ${listing.author}'),
                                            style: textTheme.bodyMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'NPR ${listing.sellingPrice.toStringAsFixed(0)}',
                                          style: textTheme.headlineSmall?.copyWith(fontSize: 28, color: colorScheme.primary, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppSpacing.lg),

                                Text('Book Details', style: textTheme.titleLarge),
                                const SizedBox(height: AppSpacing.sm),
                                BookSpecsGrid(listing: listing),

                                const SizedBox(height: AppSpacing.lg),
                                Text('About this book', style: textTheme.titleLarge),
                                const SizedBox(height: AppSpacing.sm),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                                  decoration: BoxDecoration(
                                    color: colorScheme.surfaceContainerLow,
                                    borderRadius: BorderRadius.circular(AppRadius.md),
                                    border: Border.all(color: colorScheme.primary.withValues(alpha: 0.05)),
                                  ),
                                  child: Text(
                                    listing.description.trim().isEmpty ? 'No details provided' : listing.description,
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.onSurface,
                                      height: 1.5,
                                      fontStyle: listing.description.trim().isEmpty ? FontStyle.italic : FontStyle.normal,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: AppSpacing.xl),
                                Text('Seller Information', style: textTheme.titleLarge),
                                const SizedBox(height: AppSpacing.sm),
                                SellerInfoCard(owner: listing.owner),

                                const SizedBox(height: 120),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          ),
          bottomNavigationBar: widget.isOwner
              ? null
              : BottomCtaBar(
                  children: [
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 48,
                        child: FilledButton(
                          onPressed: () {
                            // Handle Buy Now - maybe go straight to checkout?
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                          ),
                          child: const Text(
                            'Buy Now',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () {
                            context.read<CartBloc>().add(AddToCart(listing));
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to cart')));
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: colorScheme.primary, width: 1.5),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                          ),
                          child: Text(
                            'Add to Cart',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: colorScheme.primary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
