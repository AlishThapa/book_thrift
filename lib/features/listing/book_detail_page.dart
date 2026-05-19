import 'package:auto_route/auto_route.dart';
import 'package:book_thrift/constants/design_tokens.dart';
import 'package:book_thrift/core/di/injection.dart';
import 'package:book_thrift/core/router/app_router.gr.dart';
import 'package:book_thrift/core/storage/storage_service.dart';
import 'package:book_thrift/features/cart/bloc/cart_bloc.dart';
import 'package:book_thrift/features/listing/bloc/listing_detail_bloc.dart';
import 'package:book_thrift/features/listing/models/book_listing.dart';
import 'package:book_thrift/features/listing/repo/listing_repo.dart';
import 'package:book_thrift/features/listing/widgets/book_detail_image_carousel.dart';
import 'package:book_thrift/features/listing/widgets/book_specs_grid.dart';
import 'package:book_thrift/features/listing/widgets/seller_info_card.dart';
import 'package:book_thrift/shared/widgets/book_card.dart';
import 'package:book_thrift/shared/widgets/system/bottom_cta_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

@RoutePage()
class BookDetailPage extends StatefulWidget {
  const BookDetailPage({super.key, required this.listing, this.isOwner = false, this.heroTag});
  final BookListing listing;
  final bool isOwner;
  final String? heroTag;

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1.0), end: Offset.zero).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleBack() {
    _controller.reverse();
    context.router.maybePop();
  }

  void _onShare(BookListing listing) {
    Share.share(
      'Check out this book: ${listing.title} by ${listing.author} for NPR ${listing.sellingPrice.toStringAsFixed(0)} on KitabSathi!',
      subject: 'Book Listing: ${listing.title}',
    );
  }

  void _showDeleteConfirmation(BuildContext context, String listingId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Listing?'),
        content: const Text('Are you sure you want to delete this book listing? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              final bookId = int.tryParse(listingId);
              if (bookId != null) {
                context.read<ListingDetailBloc>().add(DeleteListing(bookId));
              }
            },
            style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return BlocProvider(
      create: (context) {
        final bloc = ListingDetailBloc(getIt<ListingRepo>());
        final bookId = int.tryParse(widget.listing.id);
        if (bookId != null) {
          bloc.add(FetchListingDetail(bookId));
        }
        return bloc;
      },
      child: MultiBlocListener(
        listeners: [
        BlocListener<CartBloc, CartState>(
          listenWhen: (p, c) => p.status != c.status,
          listener: (context, state) {
            if (state.status == CartStatus.success) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to cart successfully!'), behavior: SnackBarBehavior.floating));
            } else if (state.status == CartStatus.failure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage), backgroundColor: colorScheme.error, behavior: SnackBarBehavior.floating));
            }
          },
        ),
        BlocListener<ListingDetailBloc, ListingDetailState>(
          listenWhen: (p, c) => p.status != c.status,
          listener: (context, state) {
            if (state.status == ListingDetailStatus.deleted) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Listing deleted successfully'), behavior: SnackBarBehavior.floating));
              context.router.maybePop(true);
            } else if (state.status == ListingDetailStatus.failure && state.listing != null) {
              // Show error if action (like delete or wishlist) fails but we still have the listing
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage), backgroundColor: colorScheme.error, behavior: SnackBarBehavior.floating));
            }
          },
        ),
      ],
      child: BlocBuilder<ListingDetailBloc, ListingDetailState>(
        builder: (context, state) {
          final listing = (state.listing != null && state.listing!.id == widget.listing.id) ? state.listing! : widget.listing;
          final currentUid = getIt<StorageService>().getUid();
          final isOwner = widget.isOwner || (listing.owner?.uid != null && listing.owner?.uid == currentUid);
          return Scaffold(
            backgroundColor: colorScheme.surfaceContainerLowest,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              foregroundColor: colorScheme.onPrimary,
              leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: _handleBack),
              actions: [
                IconButton(
                  onPressed: () {
                    final bookId = int.tryParse(listing.id);
                    if (bookId != null) {
                      context.read<ListingDetailBloc>().add(ToggleBookWishlist(bookId));
                    }
                  },
                  icon: Icon(
                    listing.isWishlisted ? Icons.favorite : Icons.favorite_border,
                    color: listing.isWishlisted ? colorScheme.error : colorScheme.onPrimary,
                  ),
                ),
                IconButton(
                  onPressed: () => _onShare(listing),
                  icon: Icon(Icons.share_rounded, color: colorScheme.onPrimary),
                ),
                const SizedBox(width: 8),
              ],
            ),
            body: PopScope(
              canPop: true,
              onPopInvokedWithResult: (didPop, result) {
                if (didPop) {
                  _controller.reverse();
                }
              },
              child: state.status == ListingDetailStatus.loading && state.listing == null
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
                            Hero(
                              tag: widget.heroTag ?? 'book_image_${listing.id}',
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                                child: Container(
                                  color: colorScheme.primary,
                                  height: 350,
                                  child: BookDetailImageCarousel(imagePaths: listing.imagePaths, listingId: listing.id, heroTag: widget.heroTag),
                                ),
                              ),
                            ),
                            SlideTransition(
                              position: _slideAnimation,
                              child: FadeTransition(
                                opacity: _fadeAnimation,
                                child: Transform.translate(
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
                                                      listing.owner?.fullName != null
                                                          ? 'by ${listing.owner!.fullName}'
                                                          : (listing.author.isEmpty ? 'Unknown Author' : 'by ${listing.author}'),
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
                                                    style: textTheme.headlineSmall?.copyWith(
                                                      fontSize: 28,
                                                      color: colorScheme.primary,
                                                      fontWeight: FontWeight.bold,
                                                    ),
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

                                          if (listing.similarBooks != null && listing.similarBooks!.isNotEmpty) ...[
                                            const SizedBox(height: AppSpacing.xl),
                                            Text('Similar books by the seller', style: textTheme.titleLarge),
                                            const SizedBox(height: AppSpacing.sm),
                                            ListView.separated(
                                              padding: EdgeInsets.zero,
                                              shrinkWrap: true,
                                              physics: const NeverScrollableScrollPhysics(),
                                              itemCount: listing.similarBooks!.length,
                                              separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
                                              itemBuilder: (context, index) {
                                                final similarBook = listing.similarBooks![index];
                                                final heroTag = 'similar_book_${similarBook.id}';
                                                return BookCard(
                                                  listing: similarBook,
                                                  heroTag: heroTag,
                                                  onTap: () {
                                                    context.router.push(BookDetailRoute(listing: similarBook, heroTag: heroTag));
                                                  },
                                                );
                                              },
                                            ),
                                          ],

                                          const SizedBox(height: 120),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
            bottomNavigationBar: isOwner
                ? BottomCtaBar(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // Handle Edit - Pass existing listing data to CreateListingPage in edit mode
                              context.router.push(CreateListingRoute(listing: listing)).then((result) {
                                if (result == true && context.mounted) {
                                  final bookId = int.tryParse(listing.id);
                                  if (bookId != null) {
                                    context.read<ListingDetailBloc>().add(FetchListingDetail(bookId));
                                  }
                                }
                              });
                            },
                            icon: const Icon(Icons.edit_rounded, size: 20),
                            label: const Text('Edit Listing'),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: colorScheme.primary),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: FilledButton.icon(
                            onPressed: () {
                              // Handle Delete - show confirmation dialog then call delete API
                              _showDeleteConfirmation(context, listing.id);
                            },
                            icon: const Icon(Icons.delete_outline_rounded, size: 20),
                            label: const Text('Delete'),
                            style: FilledButton.styleFrom(
                              backgroundColor: colorScheme.error,
                              foregroundColor: colorScheme.onError,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
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
                          child: BlocBuilder<CartBloc, CartState>(
                            builder: (context, cartState) {
                              final isLoading = cartState.status == CartStatus.loading;
                              return OutlinedButton(
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        context.read<CartBloc>().add(AddToCart(listing));
                                      },
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: colorScheme.primary, width: 1.5),
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                                ),
                                child: isLoading
                                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                                    : Text(
                                        'Add to Cart',
                                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: colorScheme.primary),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    ),
    );
  }
}
