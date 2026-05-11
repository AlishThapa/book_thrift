import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:book_thrift/constants/design_tokens.dart';
import 'package:book_thrift/constants/app_colors.dart';
import 'package:book_thrift/features/chat/chat_detail_page.dart';
import 'package:book_thrift/features/listing/models/book_listing.dart';
import 'package:book_thrift/features/listing/widgets/book_detail_image_carousel.dart';
import 'package:book_thrift/features/listing/widgets/book_specs_grid.dart';
import 'package:book_thrift/features/listing/widgets/seller_info_card.dart';
import 'package:book_thrift/features/wishlist/bloc/wishlist_bloc.dart';
import 'package:book_thrift/shared/widgets/system/app_buttons.dart';
import 'package:book_thrift/shared/widgets/system/bottom_cta_bar.dart';

class BookDetailPage extends StatelessWidget {
  const BookDetailPage({super.key, required this.listing, this.isOwner = false});
  final BookListing listing;
  final bool isOwner;

  void _onShare() {
    Share.share('Check out this book: ${listing.title} by ${listing.author} for ₹${listing.sellingPrice.toStringAsFixed(0)} on Book Thrift!', subject: 'Book Listing: ${listing.title}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            elevation: 0,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: BookDetailImageCarousel(imagePaths: listing.imagePaths, listingId: listing.id),
            ),
            actions: [
              BlocBuilder<WishlistBloc, WishlistState>(
                builder: (_, state) {
                  final selected = state.ids.contains(listing.id);
                  return IconButton(
                    onPressed: () => context.read<WishlistBloc>().add(ToggleWishlist(listing.id)),
                    icon: Icon(selected ? Icons.favorite : Icons.favorite_border, color: selected ? AppColors.error : Colors.white),
                  );
                },
              ),
              IconButton(
                onPressed: _onShare,
                icon: const Icon(Icons.share_rounded, color: Colors.white),
              ),
              const SizedBox(width: 8),
            ],
          ),

          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(AppRadius.lg), topRight: Radius.circular(AppRadius.lg)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(listing.title.isEmpty ? 'Untitled Book' : listing.title, style: AppTextStyles.largeHeading),
                              const SizedBox(height: 4),
                              Text(listing.author.isEmpty ? 'Unknown Author' : 'by ${listing.author}', style: AppTextStyles.subtitle),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('₹${listing.sellingPrice.toStringAsFixed(0)}', style: AppTextStyles.price.copyWith(fontSize: 28, color: AppColors.primary)),
                            if (listing.negotiable)
                              Text(
                                'Negotiable',
                                style: AppTextStyles.caption.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
                              ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    const Text('Book Details', style: AppTextStyles.sectionTitle),
                    const SizedBox(height: AppSpacing.sm),
                    BookSpecsGrid(listing: listing),

                    const SizedBox(height: AppSpacing.lg), const Text('About this book', style: AppTextStyles.sectionTitle),
                    const SizedBox(height: AppSpacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(color: AppColors.primary.withOpacity(0.05)),
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              listing.description.trim().isEmpty ? 'No details provided' : listing.description,
                              style: AppTextStyles.subtitle.copyWith(color: AppColors.textPrimary, height: 1.5, fontStyle: listing.description.trim().isEmpty ? FontStyle.italic : FontStyle.normal),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xl),
                    const Text('Seller Information', style: AppTextStyles.sectionTitle),
                    const SizedBox(height: AppSpacing.sm),
                    const SellerInfoCard(sellerName: 'Local Student', rating: 4.8, reviewsCount: 24),

                    // Extra padding at bottom for the fixed CTA bar
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: isOwner ? null : BottomCtaBar(
        children: [
          Expanded(
            child: SecondaryButton(
              label: 'Chat',
              icon: Icons.chat_bubble_outline_rounded,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatDetailPage(threadId: 't1', listing: listing),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: PrimaryButton(label: 'Buy Now', icon: Icons.shopping_cart_checkout_rounded, onPressed: () {}),
          ),
        ],
      ),
    );
  }
}
