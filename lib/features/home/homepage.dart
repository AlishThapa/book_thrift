import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_thrift/constants/app_colors.dart';
import 'package:book_thrift/constants/design_tokens.dart';
import 'package:book_thrift/features/chat/chat_list_page.dart';
import 'package:book_thrift/features/home/bloc/homepage_bloc.dart';
import 'package:book_thrift/features/home/widgets/book_card.dart';
import 'package:book_thrift/features/home/widgets/book_card_skeleton.dart';
import 'package:book_thrift/features/home/widgets/category_chips.dart';
import 'package:book_thrift/features/home/widgets/modern_header.dart';
import 'package:book_thrift/features/home/widgets/sell_banner.dart';
import 'package:book_thrift/features/listing/book_detail_page.dart';
import 'package:book_thrift/features/listing/create_listing_page.dart';
import 'package:book_thrift/features/listing/models/listing_draft.dart';
import 'package:book_thrift/features/notifications/notifications_page.dart';
import 'package:book_thrift/features/profile/profile_page.dart';
import 'package:book_thrift/features/search/searchpage.dart';
import 'package:book_thrift/shared/widgets/system/app_search_bar.dart';

class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key, this.initialIndex = 0, this.initialDraft});

  final int initialIndex;
  final ListingDraft? initialDraft;

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
  }

  void _onNavigate(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    final pages = [Homepage(onNavigate: _onNavigate), const SearchPage(), CreateListingPage(initialDraft: widget.initialDraft), const ChatListPage(), const ProfilePage()];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: _BottomNav(currentIndex: _index, onTap: _onNavigate),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Container(
        margin: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, 0),
        padding: const EdgeInsets.fromLTRB(AppSpacing.xs, AppSpacing.xs, AppSpacing.xs, AppSpacing.xs),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 8))],
        ),
        child: NavigationBar(
          height: 68,
          backgroundColor: Colors.transparent,
          selectedIndex: currentIndex,
          onDestinationSelected: onTap,
          indicatorColor: AppColors.primary.withOpacity(0.1),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            _navItem(Icons.home_outlined, Icons.home_rounded, 'Home'),
            _navItem(Icons.search_outlined, Icons.search_rounded, 'Search'),
            _navItem(Icons.add_box_outlined, Icons.add_box_rounded, 'Sell'),
            _navItem(Icons.chat_bubble_outline_rounded, Icons.chat_bubble_rounded, 'Chats'),
            _navItem(Icons.person_outline_rounded, Icons.person_rounded, 'Profile'),
          ],
        ),
      ),
    );
  }

  NavigationDestination _navItem(IconData icon, IconData selectedIcon, String label) {
    return NavigationDestination(
      icon: Icon(icon, color: AppColors.neutral),
      selectedIcon: Icon(selectedIcon, color: AppColors.primary),
      label: label,
    );
  }
}

const List<String> _kCategories = ['All', 'School', 'Engineering', 'Medical', 'Competitive', 'Others'];

class Homepage extends StatelessWidget {
  const Homepage({super.key, required this.onNavigate});

  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomepageBloc, HomepageState>(
      builder: (context, state) {
        return Container(
          color: AppColors.background,
          child: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async => context.read<HomepageBloc>().add(LoadHomepage()),
              color: AppColors.primary,
              backgroundColor: AppColors.surface,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: _SectionPadding(
                      child: _SurfaceCard(
                        child: ModernHeader(
                          name: 'Reader',
                          onNotifications: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsPage())),
                        ),
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      child: AppSearchBar(readOnly: true, hintText: 'Search books, courses, institutions 🔍', onTap: () => onNavigate(1)),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionTitle(icon: Icons.tune_rounded, title: 'Filters'),
                          const SizedBox(height: AppSpacing.sm),
                          CategoryChips(categories: _kCategories, selected: state.selectedCategory, onSelected: (cat) => context.read<HomepageBloc>().add(SelectCategory(cat))),
                        ],
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      child: _SectionTitle(
                        icon: Icons.auto_stories_rounded,
                        title: 'Recommended Books',
                        trailing: GestureDetector(
                          onTap: () => onNavigate(1),
                          child: Text(
                            'See all',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),

                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 260,
                      child: state.loading
                          ? _SkeletonList()
                          : state.listings.isEmpty
                          ? _EmptyState()
                          : _BookList(
                              state: state,
                              onBookTap: (listing) => Navigator.push(context, MaterialPageRoute(builder: (_) => BookDetailPage(listing: listing))),
                            ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      child: SellBanner(onTap: () => onNavigate(2)),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 32)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BookList extends StatelessWidget {
  const _BookList({required this.state, required this.onBookTap});

  final HomepageState state;
  final ValueChanged<dynamic> onBookTap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      scrollDirection: Axis.horizontal,
      itemCount: state.listings.length,
      separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
      itemBuilder: (context, index) {
        final listing = state.listings[index];
        return BookCard(listing: listing, onTap: () => onBookTap(listing));
      },
    );
  }
}

class _SkeletonList extends StatelessWidget {
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

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 40, color: AppColors.neutral.withOpacity(0.5)),
          const SizedBox(height: 8),
          Text('No books found', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _SurfaceCard extends StatelessWidget {
  const _SurfaceCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: child,
    );
  }
}

class _SectionPadding extends StatelessWidget {
  const _SectionPadding({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      child: child,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.title, this.trailing});

  final IconData icon;
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: AppColors.surface, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}
