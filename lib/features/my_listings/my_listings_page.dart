import 'package:auto_route/auto_route.dart';
import 'package:book_thrift/constants/design_tokens.dart';
import 'package:book_thrift/core/data/app_repository.dart';
import 'package:book_thrift/core/di/injection.dart';
import 'package:book_thrift/core/router/app_router.gr.dart';
import 'package:book_thrift/features/listing/models/book_listing.dart';
import 'package:book_thrift/shared/widgets/book_card.dart';
import 'package:flutter/material.dart';

@RoutePage()
class MyListingsPage extends StatefulWidget {
  const MyListingsPage({super.key});

  @override
  State<MyListingsPage> createState() => _MyListingsPageState();
}

class _MyListingsPageState extends State<MyListingsPage> {
  Key _refreshKey = UniqueKey();

  void _refresh() {
    setState(() {
      _refreshKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: colorScheme.surfaceContainerLowest,
        appBar: AppBar(
          title: const Text('My Listings', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
              decoration: BoxDecoration(color: colorScheme.surfaceContainerLow, borderRadius: BorderRadius.circular(AppRadius.md)),
              child: TabBar(
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(borderRadius: BorderRadius.circular(AppRadius.md), color: colorScheme.primary),
                labelColor: colorScheme.onPrimary,
                unselectedLabelColor: colorScheme.onSurfaceVariant,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                tabs: const [
                  Tab(text: 'Active'),
                  Tab(text: 'Sold'),
                ],
              ),
            ),
          ),
        ),
        body: FutureBuilder(
          key: _refreshKey,
          future: getIt<AppRepository>().listings(),
          builder: (_, snapshot) {
            final listings = (snapshot.data as List<BookListing>?) ?? [];

            final active = listings.where((e) => e.status == 'active').toList();
            final sold = listings.where((e) => e.status == 'sold').toList();

            return TabBarView(
              children: [
                _ListingsList(listings: active, type: 'active', onRefresh: _refresh),
                _ListingsList(listings: sold, type: 'sold', onRefresh: _refresh),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ListingsList extends StatelessWidget {
  const _ListingsList({required this.listings, required this.type, required this.onRefresh});
  final List<BookListing> listings;
  final String type;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    if (listings.isEmpty) {
      return _EmptyState(
        icon: type == 'active' ? Icons.inventory_2_outlined : Icons.monetization_on_outlined,
        title: 'No $type listings',
        subtitle: type == 'active' ? 'You haven\'t listed any books for sale yet.' : 'Your sold books will appear here.',
        actionLabel: type == 'active' ? 'Start Selling' : null,
        onAction: () => context.router.push(const CreateListingRoute()).then((_) => onRefresh()),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: listings.length,
      itemBuilder: (_, i) {
        final item = listings[i];
        return Dismissible(
          key: Key('listing_${item.id}'),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Icon(Icons.delete_outline_rounded, color: Theme.of(context).colorScheme.error, size: 28),
          ),
          onDismissed: (_) async {
            await getIt<AppRepository>().deleteListing(item.id);
            onRefresh();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${item.title} deleted')));
            }
          },
          child: BookCard(
            listing: item,
            onTap: () => context.router.push(BookDetailRoute(listing: item, isOwner: true)).then((_) => onRefresh()),
          ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.icon, required this.title, required this.subtitle, this.actionLabel, this.onAction});

  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

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
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(color: colorScheme.primary.withValues(alpha: 0.05), shape: BoxShape.circle),
              child: Icon(icon, size: 64, color: colorScheme.primary.withValues(alpha: 0.5)),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(title, style: textTheme.titleLarge?.copyWith(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSpacing.xs),
            Text(subtitle, textAlign: TextAlign.center, style: textTheme.bodyMedium),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: 200,
                child: FilledButton.icon(
                  onPressed: onAction,
                  icon: const Icon(Icons.add, size: 20),
                  label: Text(actionLabel!),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
