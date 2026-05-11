import 'package:flutter/material.dart';
import 'package:book_thrift/constants/design_tokens.dart';
import 'package:book_thrift/constants/app_colors.dart';
import 'package:book_thrift/core/data/app_repository.dart';
import 'package:book_thrift/core/di/injection.dart';
import 'package:book_thrift/features/home/homepage.dart';
import 'package:book_thrift/features/listing/book_detail_page.dart';
import 'package:book_thrift/features/listing/create_listing_page.dart';
import 'package:book_thrift/features/listing/models/book_listing.dart';
import 'package:book_thrift/features/listing/models/listing_draft.dart';
import 'package:book_thrift/shared/widgets/book_card.dart';

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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('My Listings', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
              decoration: BoxDecoration(
                color: AppColors.neutralLight,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: TabBar(
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  color: AppColors.primary,
                ),
                labelColor: Colors.white,
                unselectedLabelColor: AppColors.textSecondary,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                tabs: const [
                  Tab(text: 'Active'),
                  Tab(text: 'Sold'),
                  Tab(text: 'Drafts'),
                ],
              ),
            ),
          ),
        ),
        body: FutureBuilder(
          key: _refreshKey,
          future: getIt<AppRepository>().listings(),
          builder: (_, snapshot) {
            final all = snapshot.data ?? [];
            return TabBarView(
              children: [
                _ListingsList(
                  listings: all.where((e) => e.status == 'active').toList(),
                  type: 'active',
                  onRefresh: _refresh,
                ),
                _ListingsList(
                  listings: all.where((e) => e.status == 'sold').toList(),
                  type: 'sold',
                  onRefresh: _refresh,
                ),
                _DraftsList(onRefresh: _refresh),
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
        subtitle: type == 'active' 
          ? 'You haven\'t listed any books for sale yet.' 
          : 'Your sold books will appear here.',
        actionLabel: type == 'active' ? 'Start Selling' : null,
        onAction: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CreateListingPage()),
        ).then((_) => onRefresh()),
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
              color: AppColors.error,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 28),
          ),
          onDismissed: (_) async {
            await getIt<AppRepository>().deleteListing(item.id);
            onRefresh();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${item.title} deleted')),
              );
            }
          },
          child: BookCard(
            listing: item,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => BookDetailPage(listing: item, isOwner: true)),
            ).then((_) => onRefresh()),
            trailing: type == 'active'
                ? IconButton(
                    onPressed: () async {
                      // Navigate to edit page with existing listing
                      final draft = ListingDraft(
                        id: item.id,
                        data: {
                          'id': item.id,
                          'title': item.title,
                          'author': item.author,
                          'condition': item.condition,
                          'sellingPrice': item.sellingPrice.toString(),
                          'publisher': item.publisher,
                          'quantity': item.quantity.toString(),
                          'description': item.description,
                          'location': item.location,
                          'imagePaths': item.imagePaths,
                        },
                        updatedAt: item.updatedAt,
                      );
                      await Navigator.push(context, MaterialPageRoute(builder: (_) => CreateListingPage(initialDraft: draft)));
                      onRefresh();
                    },
                    icon: const Icon(Icons.edit_note_rounded, color: AppColors.primary),
                  )
                : null,
          ),
        );
      },
    );
  }
}

class _DraftsList extends StatelessWidget {
  const _DraftsList({required this.onRefresh});
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getIt<AppRepository>().drafts(),
      builder: (_, s) {
        final drafts = s.data ?? [];
        if (drafts.isEmpty) {
          return _EmptyState(
            icon: Icons.note_alt_outlined,
            title: 'No drafts',
            subtitle: 'Saved drafts will appear here so you can finish them later.',
            actionLabel: 'Create Draft',
            onAction: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CreateListingPage()),
            ).then((_) => onRefresh()),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.md),
          itemCount: drafts.length,
          itemBuilder: (_, i) {
            final draft = drafts[i];
            // Create a dummy BookListing from draft data for the card
            final dummy = BookListing(
              id: draft.id,
              sellerId: '',
              title: draft.data['title']?.toString() ?? 'Untitled Draft',
              author: draft.data['author']?.toString() ?? 'Unknown Author',
              category: '',
              subject: '',
              institution: '',
              classOrCourse: '',
              semester: '',
              edition: '',
              publisher: '',
              condition: draft.data['condition']?.toString() ?? 'Good',
              description: draft.data['description']?.toString() ?? '',
              originalPrice: 0,
              sellingPrice: double.tryParse(draft.data['sellingPrice']?.toString() ?? '0') ?? 0,
              negotiable: false,
              quantity: 1,
              imagePaths: const [],
              location: draft.data['location']?.toString() ?? '',
              deliveryMethod: const [],
              isAvailable: false,
              isReserved: false,
              status: 'draft',
              createdAt: draft.updatedAt,
              updatedAt: draft.updatedAt,
            );

            return Dismissible(
              key: Key('draft_${draft.id}'),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 28),
              ),
              onDismissed: (_) async {
                await getIt<AppRepository>().deleteDraft(draft.id);
                onRefresh();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Draft deleted')),
                  );
                }
              },
              child: BookCard(
                listing: dummy,
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CreateListingPage(initialDraft: draft)),
                  );
                  onRefresh();
                },
                trailing: IconButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => CreateListingPage(initialDraft: draft)),
                    );
                    onRefresh();
                  },
                  icon: const Icon(Icons.edit_note_rounded, color: AppColors.primary),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64,
                color: AppColors.primary.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              style: AppTextStyles.sectionTitle.copyWith(fontSize: 20),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.subtitle,
            ),
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
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
