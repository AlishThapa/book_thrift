import 'package:auto_route/auto_route.dart';
import 'package:book_thrift/constants/design_tokens.dart';
import 'package:book_thrift/core/di/injection.dart';
import 'package:book_thrift/core/router/app_router.gr.dart';
import 'package:book_thrift/features/listing/models/book_listing.dart';
import 'package:book_thrift/features/my_listings/bloc/my_listings_bloc.dart';
import 'package:book_thrift/features/my_listings/repo/my_listings_repo.dart';
import 'package:book_thrift/shared/widgets/book_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class MyListingsPage extends StatelessWidget {
  const MyListingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyListingsBloc(getIt<MyListingsRepo>())..add(const LoadMyListings()),
      child: const _MyListingsView(),
    );
  }
}

class _MyListingsView extends StatefulWidget {
  const _MyListingsView();

  @override
  State<_MyListingsView> createState() => _MyListingsViewState();
}

class _MyListingsViewState extends State<_MyListingsView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      final status = _tabController.index == 0 ? 'active' : 'sold';
      context.read<MyListingsBloc>().add(LoadMyListings(status: status));
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
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
              controller: _tabController,
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
      body: BlocBuilder<MyListingsBloc, MyListingsState>(
        builder: (context, state) {
          if (state.status == MyListingsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == MyListingsStatus.failure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.errorMessage}'),
                  const SizedBox(height: AppSpacing.md),
                  ElevatedButton(
                    onPressed: () {
                      final status = _tabController.index == 0 ? 'active' : 'sold';
                      context.read<MyListingsBloc>().add(LoadMyListings(status: status));
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _ListingsList(listings: state.activeListings, type: 'active'),
              _ListingsList(listings: state.soldListings, type: 'sold'),
            ],
          );
        },
      ),
    );
  }
}

class _ListingsList extends StatelessWidget {
  const _ListingsList({required this.listings, required this.type});
  final List<BookListing> listings;
  final String type;

  @override
  Widget build(BuildContext context) {
    if (listings.isEmpty) {
      return _EmptyState(
        icon: type == 'active' ? Icons.inventory_2_outlined : Icons.monetization_on_outlined,
        title: 'No $type listings',
        subtitle: type == 'active' ? 'You haven\'t listed any books for sale yet.' : 'Your sold books will appear here.',
        actionLabel: type == 'active' ? 'Start Selling' : null,
        onAction: () => context.router.push(CreateListingRoute()).then((_) {
          if (context.mounted) {
            context.read<MyListingsBloc>().add(RefreshMyListings(status: type));
          }
        }),
      );
    }
    return RefreshIndicator(
      onRefresh: () async {
        context.read<MyListingsBloc>().add(RefreshMyListings(status: type));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: listings.length,
        itemBuilder: (_, i) {
          final item = listings[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: BookCard(
              listing: item,
              heroTag: 'my_listings_book_image_${item.id}',
              onTap: () => context.router.push(BookDetailRoute(
                listing: item,
                isOwner: true,
                heroTag: 'my_listings_book_image_${item.id}',
              )).then((_) {
                if (context.mounted) {
                  context.read<MyListingsBloc>().add(RefreshMyListings(status: type));
                }
              }),
            ),
          );
        },
      ),
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
