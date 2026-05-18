import 'package:auto_route/auto_route.dart';
import 'package:book_thrift/constants/design_tokens.dart';
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
  void initState() {
    super.initState();
    context.read<WishlistBloc>().add(LoadWishlist());
  }

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
      appBar: AppBar(
        title: const Text('My Wishlist'),
        centerTitle: false,
      ),
      body: BlocBuilder<WishlistBloc, WishlistState>(
        builder: (context, state) {
          if (state.status == WishlistStatus.loading && state.items.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == WishlistStatus.failure && state.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Failed to load wishlist', style: theme.textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.sm),
                  ElevatedButton(
                    onPressed: () => context.read<WishlistBloc>().add(LoadWishlist()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final wishlistedItems = state.items
              .where((listing) => listing.title.toLowerCase().contains(_searchQuery.toLowerCase()))
              .toList();

          if (wishlistedItems.isEmpty && _searchQuery.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<WishlistBloc>().add(LoadWishlist());
                await context.read<WishlistBloc>().stream.firstWhere((s) => s.status != WishlistStatus.loading);
              },
              child: const SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: 500, // Sufficient height for pull to refresh
                  child: _EmptyWishlistState(),
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<WishlistBloc>().add(LoadWishlist());
              await context.read<WishlistBloc>().stream.firstWhere((s) => s.status != WishlistStatus.loading);
            },
            child: Column(
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
            ),
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
    final bloc = context.read<WishlistBloc>();
    bloc.add(ToggleWishlist(listing.id));
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${listing.title} removed from wishlist'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => bloc.add(ToggleWishlist(listing.id)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final heroTag = 'wishlist_book_image_${listing.id}';
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
          heroTag: heroTag,
          onTap: () => context.router.push(BookDetailRoute(listing: listing, heroTag: heroTag)),
          trailing: IconButton(
            onPressed: () => _remove(context),
            icon: const Icon(Icons.favorite, color: Colors.redAccent, size: 22),
          ),
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
