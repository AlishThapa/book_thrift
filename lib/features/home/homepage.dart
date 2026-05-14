import 'package:auto_route/auto_route.dart';
import 'package:book_thrift/constants/app_colors.dart';
import 'package:book_thrift/constants/design_tokens.dart';
import 'package:book_thrift/core/router/app_router.gr.dart';
import 'package:book_thrift/features/cart/cart_page.dart';
import 'package:book_thrift/features/home/bloc/homepage_bloc.dart';
import 'package:book_thrift/features/home/widgets/category_chips.dart';
import 'package:book_thrift/features/home/widgets/home_book_list.dart';
import 'package:book_thrift/features/home/widgets/home_empty_state.dart';
import 'package:book_thrift/features/home/widgets/home_section_title.dart';
import 'package:book_thrift/features/profile/profile_page.dart';
import 'package:book_thrift/features/search/searchpage.dart';
import 'package:book_thrift/shared/widgets/system/app_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key, this.initialIndex = 0});

  final int initialIndex;

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

  void _onNavigate(int i) {
    if (i == 2) {
      context.router.push(CreateListingRoute());
      return;
    }
    setState(() => _index = i);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      Homepage(onNavigate: _onNavigate),
      const SearchPage(),
      const SizedBox.shrink(),
      CartPage(onNavigate: _onNavigate),
      const ProfilePage()
    ];

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: _BottomNav(currentIndex: _index, onTap: _onNavigate),
      resizeToAvoidBottomInset: true,
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.xxs),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: colorScheme.outline.withValues(alpha: 0.1)),
          boxShadow: [BoxShadow(color: colorScheme.shadow.withValues(alpha: 0.25), blurRadius: 10, offset: const Offset(5, 5))],
          // boxShadow: [BoxShadow(color: colorScheme.shadow.withValues(alpha: 0.25), blurRadius: 12, offset: const Offset(0, 8))],
        ),
        child: NavigationBar(
          height: 60,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedIndex: currentIndex,
          onDestinationSelected: onTap,
          indicatorColor: colorScheme.primary.withValues(alpha: 0.12),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          destinations: [
            _navItem(Icons.home_outlined, Icons.home_rounded, 'Home'),
            _navItem(Icons.search_outlined, Icons.search_rounded, 'Search'),
            _navItem(Icons.add_box_outlined, Icons.add_box_rounded, 'Sell'),
            _navItem(Icons.shopping_cart_outlined, Icons.shopping_cart_rounded, 'Cart'),
            _navItem(Icons.person_outline_rounded, Icons.person_rounded, 'Profile'),
          ],
        ),
      ),
    );
  }

  NavigationDestination _navItem(IconData icon, IconData selectedIcon, String label) {
    return NavigationDestination(
      icon: Icon(icon),
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
    final colorScheme = Theme.of(context).colorScheme;
    return BlocBuilder<HomepageBloc, HomepageState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            bottom: false,
            child: RefreshIndicator(
              onRefresh: () async => context.read<HomepageBloc>().add(LoadHomepage()),
              color: colorScheme.primary,
              backgroundColor: colorScheme.surface,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                slivers: [
                  SliverAppBar(
                    floating: true,
                    pinned: false,
                    snap: true,
                    elevation: 0,
                    backgroundColor: Colors.white,
                    surfaceTintColor: Colors.transparent,
                    titleSpacing: AppSpacing.sm,
                    leadingWidth: 52,
                    leading: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: AppSpacing.md),
                        child: GestureDetector(
                          onTap: () => onNavigate(4),
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: colorScheme.primaryContainer,
                            child: Icon(Icons.person_rounded, size: 20, color: colorScheme.onPrimaryContainer),
                          ),
                        ),
                      ),
                    ),
                    title: SizedBox(
                      height: 36,
                      child: AppSearchBar(readOnly: true, hintText: 'Search books...', onTap: () => onNavigate(1)),
                    ),
                    actions: [
                      IconButton(
                        onPressed: () => context.router.push(const NotificationsRoute()),
                        icon: Icon(Icons.notifications_outlined, color: colorScheme.onSurface, size: 24),
                      ),
                      IconButton(
                        onPressed: () => context.router.push(const ChatListRoute()),
                        icon: Icon(Icons.forum_rounded, color: colorScheme.onSurface, size: 24),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                    ],
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const HomeSectionTitle(icon: Icons.tune_rounded, title: 'Categories'),
                          const SizedBox(height: AppSpacing.sm),
                          CategoryChips(
                            categories: _kCategories,
                            selected: state.selectedCategory,
                            onSelected: (cat) => context.read<HomepageBloc>().add(SelectCategory(cat)),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      child: HomeSectionTitle(
                        icon: Icons.auto_stories_rounded,
                        title: 'Recommended for You',
                        trailing: GestureDetector(
                          onTap: () => onNavigate(1),
                          child: Text(
                            'See all',
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),

                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 285,
                      child: state.loading
                          ? const SkeletonList()
                          : state.listings.isEmpty
                          ? const HomeEmptyState()
                          : HomeBookList(
                              state: state,
                              onBookTap: (listing) => context.router.push(BookDetailRoute(listing: listing)),
                            ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 120)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
