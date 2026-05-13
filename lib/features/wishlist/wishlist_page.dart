import 'package:auto_route/auto_route.dart';
import 'package:book_thrift/constants/app_colors.dart';
import 'package:book_thrift/constants/design_tokens.dart';
import 'package:book_thrift/core/data/app_repository.dart';
import 'package:book_thrift/core/di/injection.dart';
import 'package:book_thrift/features/wishlist/bloc/wishlist_bloc.dart';
import 'package:book_thrift/features/listing/models/book_listing.dart';
import 'package:book_thrift/shared/widgets/book_card.dart';
import 'package:book_thrift/core/router/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

@RoutePage()
class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My Wishlist', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: BlocBuilder<WishlistBloc, WishlistState>(
        builder: (context, state) {
          return FutureBuilder<List<BookListing>>(
            future: getIt<AppRepository>().listings(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final allListings = snapshot.data ?? [];
              final wishlistedItems = allListings
                  .where((listing) => state.ids.contains(listing.id))
                  .where((listing) => listing.title.toLowerCase().contains(_searchQuery.toLowerCase()))
                  .toList();

              if (wishlistedItems.isEmpty && _searchQuery.isEmpty) {
                return const _EmptyWishlistState();
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) => setState(() => _searchQuery = val),
                      decoration: InputDecoration(
                        hintText: 'Search in wishlist...',
                        prefixIcon: const Icon(Icons.search, size: 20),
                        filled: true,
                        fillColor: colorScheme.surfaceContainerLow,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      itemCount: wishlistedItems.length,
                      itemBuilder: (context, index) {
                        final listing = wishlistedItems[index];
                        return _SlidableWishlistItem(listing: listing);
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _SlidableWishlistItem extends StatelessWidget {
  const _SlidableWishlistItem({required this.listing});
  final BookListing listing;

  void _remove(BuildContext context) {
    HapticFeedback.mediumImpact();
    context.read<WishlistBloc>().add(ToggleWishlist(listing.id));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Slidable(
        key: ValueKey(listing.id),
        endActionPane: ActionPane(
          motion: const BehindMotion(),
          extentRatio: 0.25,
          dismissible: DismissiblePane(onDismissed: () => _remove(context), dismissalDuration: const Duration(milliseconds: 250)),
          children: [
            SlidableAction(
              onPressed: _remove,
              backgroundColor: Colors.red.shade400,
              foregroundColor: Colors.white,
              icon: Icons.favorite_border_rounded,
              label: 'Remove',
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
          ],
        ),

        child: BookCard(
          listing: listing,
          onTap: () => context.router.push(BookDetailRoute(listing: listing)),
        ),
      ),
    );
  }
}

class _EmptyWishlistState extends StatelessWidget {
  const _EmptyWishlistState();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(color: colorScheme.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(Icons.favorite_outline_rounded, size: 64, color: colorScheme.primary),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Wishlist is empty', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Save books you like to see them here\nand keep track of your favorites.',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.xl),
          ElevatedButton(
            onPressed: () => context.router.popUntilRoot(),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
            ),
            child: const Text('Go Shopping'),
          ),
        ],
      ),
    );
  }
}
