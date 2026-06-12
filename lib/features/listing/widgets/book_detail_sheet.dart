import 'package:auto_route/auto_route.dart';
import 'package:book_thrift/constants/design_tokens.dart';
import 'package:book_thrift/core/di/injection.dart';
import 'package:book_thrift/core/router/app_router.gr.dart';
import 'package:book_thrift/core/storage/storage_service.dart';
import 'package:book_thrift/features/cart/bloc/cart_bloc.dart';
import 'package:book_thrift/features/chat/bloc/chat_bloc.dart';
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

class BookDetailSheet extends StatelessWidget {
  const BookDetailSheet({
    super.key,
    required this.listing,
    this.isOwner = false,
    this.heroTag,
  });

  final BookListing listing;
  final bool isOwner;
  final String? heroTag;

  static Future<void> show(BuildContext context, {required BookListing listing, bool isOwner = false, String? heroTag}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BookDetailSheet(listing: listing, isOwner: isOwner, heroTag: heroTag),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.92, // Between 0.9 and 0.95
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      child: BlocProvider(
        create: (context) {
          final bloc = ListingDetailBloc(getIt<ListingRepo>());
          final bookId = int.tryParse(listing.id);
          if (bookId != null) {
            bloc.add(FetchListingDetail(bookId));
          }
          return bloc;
        },
        child: _BookDetailSheetContent(initialListing: listing, isOwner: isOwner, heroTag: heroTag),
      ),
    );
  }
}

class _BookDetailSheetContent extends StatelessWidget {
  const _BookDetailSheetContent({
    required this.initialListing,
    required this.isOwner,
    this.heroTag,
  });

  final BookListing initialListing;
  final bool isOwner;
  final String? heroTag;

  void _onShare(BookListing listing) {
    Share.share(
      'Check out this book: ${listing.title} by ${listing.author} for NPR ${listing.sellingPrice.toStringAsFixed(0)} on KitabSathi!',
      subject: 'Book Listing: ${listing.title}',
    );
  }

  void _showDeleteConfirmation(BuildContext context, String listingId) {
    final bloc = context.read<ListingDetailBloc>();
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
                bloc.add(DeleteListing(bookId));
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

    return MultiBlocListener(
      listeners: [
        BlocListener<CartBloc, CartState>(
          listenWhen: (p, c) => p.status != c.status,
          listener: (context, state) {
            if (state.status == CartStatus.success) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to cart successfully!'), behavior: SnackBarBehavior.floating));
            } else if (state.status == CartStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage), backgroundColor: colorScheme.error, behavior: SnackBarBehavior.floating));
            }
          },
        ),
        BlocListener<ListingDetailBloc, ListingDetailState>(
          listenWhen: (p, c) => p.status != c.status,
          listener: (context, state) {
            if (state.status == ListingDetailStatus.deleted) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Listing deleted successfully'), behavior: SnackBarBehavior.floating));
              Navigator.pop(context);
            }
          },
        ),
        BlocListener<ChatBloc, ChatState>(
          listenWhen: (p, c) => p.lastCreatedConversationId != c.lastCreatedConversationId && c.lastCreatedConversationId != null,
          listener: (context, state) {
             Navigator.pop(context); // Close sheet before navigating
             context.router.push(ChatDetailRoute(threadId: state.lastCreatedConversationId!, listing: initialListing));
          },
        ),
      ],
      child: BlocBuilder<ListingDetailBloc, ListingDetailState>(
        builder: (context, state) {
          final listing = (state.listing != null && state.listing!.id == initialListing.id) ? state.listing! : initialListing;
          final currentUid = getIt<StorageService>().getUid();
          final resolvedIsOwner = isOwner || (listing.owner?.uid != null && listing.owner?.uid == currentUid);

          return Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 12),
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: colorScheme.outline.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Expanded(
                    child: state.status == ListingDetailStatus.loading && state.listing == null
                        ? const Center(child: CircularProgressIndicator())
                        : state.status == ListingDetailStatus.failure && state.listing == null
                            ? _ErrorView(errorMessage: state.errorMessage, onRetry: () {
                                final bookId = int.tryParse(initialListing.id);
                                if (bookId != null) {
                                  context.read<ListingDetailBloc>().add(FetchListingDetail(bookId));
                                }
                              })
                            : RefreshIndicator(
                                onRefresh: () async {
                                  final bookId = int.tryParse(initialListing.id);
                                  if (bookId != null) {
                                    final bloc = context.read<ListingDetailBloc>();
                                    bloc.add(FetchListingDetail(bookId));
                                    await bloc.stream.firstWhere((s) => s.status != ListingDetailStatus.loading);
                                  }
                                },
                                child: SingleChildScrollView(
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  padding: const EdgeInsets.only(bottom: 120),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _BookHeader(listing: listing, heroTag: heroTag),
                                      Padding(
                                        padding: const EdgeInsets.all(AppSpacing.lg),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            _TitlePriceSection(listing: listing),
                                            const SizedBox(height: AppSpacing.lg),
                                            Text('Book Details', style: textTheme.titleLarge),
                                            const SizedBox(height: AppSpacing.sm),
                                            BookSpecsGrid(listing: listing),
                                            const SizedBox(height: AppSpacing.lg),
                                            Text('About this book', style: textTheme.titleLarge),
                                            const SizedBox(height: AppSpacing.sm),
                                            _DescriptionBox(description: listing.description),
                                            const SizedBox(height: AppSpacing.xl),
                                            Text('Seller Information', style: textTheme.titleLarge),
                                            const SizedBox(height: AppSpacing.sm),
                                            SellerInfoCard(
                                              owner: listing.owner,
                                              onTap: () {
                                                final ownerId = listing.owner?.id;
                                                if (ownerId != null) {
                                                  context.read<ChatBloc>().add(CreateConversation(ownerId));
                                                }
                                              },
                                            ),
                                            if (listing.similarBooks != null && listing.similarBooks!.isNotEmpty) ...[
                                              const SizedBox(height: AppSpacing.xl),
                                              Text('Similar books by the seller', style: textTheme.titleLarge),
                                              const SizedBox(height: AppSpacing.sm),
                                              _SimilarBooksList(similarBooks: listing.similarBooks!),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _BottomActions(
                  listing: listing,
                  isOwner: resolvedIsOwner,
                  onDelete: () => _showDeleteConfirmation(context, listing.id),
                  onShare: () => _onShare(listing),
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: Row(
                   children: [
                     IconButton.filledTonal(
                       onPressed: () {
                         final bookId = int.tryParse(listing.id);
                         if (bookId != null) {
                           context.read<ListingDetailBloc>().add(ToggleBookWishlist(bookId));
                         }
                       },
                       icon: Icon(
                         listing.isWishlisted ? Icons.favorite : Icons.favorite_border,
                         color: listing.isWishlisted ? colorScheme.error : null,
                       ),
                     ),
                     const SizedBox(width: 8),
                     IconButton.filledTonal(
                       onPressed: () => Navigator.pop(context),
                       icon: const Icon(Icons.close),
                     ),
                   ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BookHeader extends StatelessWidget {
  const _BookHeader({required this.listing, this.heroTag});
  final BookListing listing;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag ?? 'book_image_${listing.id}',
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
        child: Container(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          height: 300,
          width: double.infinity,
          child: BookDetailImageCarousel(imagePaths: listing.imagePaths, listingId: listing.id, heroTag: heroTag),
        ),
      ),
    );
  }
}

class _TitlePriceSection extends StatelessWidget {
  const _TitlePriceSection({required this.listing});
  final BookListing listing;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(listing.title.isEmpty ? 'Untitled Book' : listing.title, style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                listing.owner?.fullName != null ? 'by ${listing.owner!.fullName}' : (listing.author.isEmpty ? 'Unknown Author' : 'by ${listing.author}'),
                style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
        Text(
          'NPR ${listing.sellingPrice.toStringAsFixed(0)}',
          style: textTheme.headlineSmall?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _DescriptionBox extends StatelessWidget {
  const _DescriptionBox({required this.description});
  final String description;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.1)),
      ),
      child: Text(
        description.trim().isEmpty ? 'No details provided' : description,
        style: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
          height: 1.5,
          fontStyle: description.trim().isEmpty ? FontStyle.italic : FontStyle.normal,
        ),
      ),
    );
  }
}

class _SimilarBooksList extends StatelessWidget {
  const _SimilarBooksList({required this.similarBooks});
  final List<BookListing> similarBooks;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: similarBooks.length,
      separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final similarBook = similarBooks[index];
        final heroTag = 'similar_book_sheet_${similarBook.id}';
        return BookCard(
          listing: similarBook,
          heroTag: heroTag,
          onTap: () {
            // Can nested show sheet? Or just update current?
            // For simplicity, let's just show a new sheet
            BookDetailSheet.show(context, listing: similarBook, heroTag: heroTag);
          },
        );
      },
    );
  }
}

class _BottomActions extends StatelessWidget {
  const _BottomActions({
    required this.listing,
    required this.isOwner,
    required this.onDelete,
    required this.onShare,
  });

  final BookListing listing;
  final bool isOwner;
  final VoidCallback onDelete;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (isOwner) {
      return BottomCtaBar(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                context.router.push(CreateListingRoute(listing: listing));
              },
              icon: const Icon(Icons.edit_rounded, size: 20),
              label: const Text('Edit'),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: FilledButton.icon(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline_rounded, size: 20),
              label: const Text('Delete'),
              style: FilledButton.styleFrom(backgroundColor: colorScheme.error, foregroundColor: colorScheme.onError),
            ),
          ),
        ],
      );
    }

    return BottomCtaBar(
      children: [
        Expanded(
          child: FilledButton(
            onPressed: () {},
            child: const Text('Buy Now'),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: BlocBuilder<CartBloc, CartState>(
            builder: (context, cartState) {
              final isLoading = cartState.status == CartStatus.loading;
              return OutlinedButton(
                onPressed: isLoading ? null : () => context.read<CartBloc>().add(AddToCart(listing)),
                child: isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Add to Cart'),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.errorMessage, required this.onRetry});
  final String errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 48, color: colorScheme.error),
            const SizedBox(height: AppSpacing.md),
            Text('Oops! Something went wrong', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSpacing.xs),
            Text(errorMessage, textAlign: TextAlign.center, style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh_rounded), label: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
