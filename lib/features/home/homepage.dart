import 'package:auto_route/auto_route.dart';
import 'package:book_thrift/constants/app_colors.dart';
import 'package:book_thrift/constants/design_tokens.dart';
import 'package:book_thrift/core/router/app_router.gr.dart';
import 'package:book_thrift/features/cart/cart_page.dart';
import 'package:book_thrift/features/home/bloc/homepage_bloc.dart';
import 'package:book_thrift/features/home/bloc/navigation_cubit.dart';
import 'package:book_thrift/features/home/widgets/home_book_list.dart';
import 'package:book_thrift/features/home/widgets/home_empty_state.dart';
import 'package:book_thrift/features/home/widgets/home_section_title.dart';
import 'package:book_thrift/features/home/widgets/modern_header.dart';
import 'package:book_thrift/features/home/widgets/sell_banner.dart';
import 'package:book_thrift/features/listing/models/book_listing.dart';
import 'package:book_thrift/features/listing/widgets/book_detail_sheet.dart';
import 'package:book_thrift/features/profile/profile_page.dart';
import 'package:book_thrift/features/search/bloc/search_bloc.dart';
import 'package:book_thrift/features/search/searchpage.dart';
import 'package:book_thrift/shared/widgets/system/app_search_bar.dart';
import 'package:book_thrift/core/di/injection.dart';
import 'package:book_thrift/core/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cart/bloc/cart_bloc.dart';
import '../profile/bloc/profile_bloc.dart';

@RoutePage()
class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  @override
  void initState() {
    super.initState();
    if (widget.initialIndex != 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<NavigationCubit>().setTab(widget.initialIndex);
      });
    }
    _loadTab(widget.initialIndex);
  }

  void _loadTab(int i) {
    switch (i) {
      case 0:
        context.read<HomepageBloc>().add(LoadHomepage());
        if (context.read<ProfileBloc>().state.profile == null) {
          context.read<ProfileBloc>().add(LoadProfile());
        }
        break;
      case 1:
        context.read<SearchBloc>().add(LoadSearch());
        break;
      case 3:
        context.read<CartBloc>().add(LoadCart());
        break;
      case 4:
        context.read<ProfileBloc>().add(LoadProfile());
        break;
    }
  }

  void _onNavigate(int i) {
    if (i == 2) {
      context.router.push(CreateListingRoute());
      return;
    }
    _loadTab(i);
    context.read<NavigationCubit>().setTab(i);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final pages = [Homepage(onNavigate: _onNavigate), const SearchPage(), const SizedBox.shrink(), CartPage(onNavigate: _onNavigate), const ProfilePage()];

    return BlocBuilder<NavigationCubit, int>(
      builder: (context, index) {
        return Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          backgroundColor: colorScheme.surfaceContainerLowest,
          body: IndexedStack(index: index, children: pages),
          bottomNavigationBar: _BottomNav(currentIndex: index, onTap: _onNavigate),
          resizeToAvoidBottomInset: true,
        );
      },
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

class Homepage extends StatelessWidget {
  const Homepage({super.key, required this.onNavigate});

  final ValueChanged<int> onNavigate;

  void _showLocationRationale(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('New Listings Near You'),
        content: const Text('To show you the freshest book listings in your immediate area, we need access to your location.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<HomepageBloc>().add(const UpdateLocationPermissionStatus(LocationPermissionStatus.denied));
            },
            child: const Text('Not Now'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              final isGranted = await getIt<LocationService>().requestPermission();
              if (context.mounted) {
                context.read<HomepageBloc>().add(
                  UpdateLocationPermissionStatus(isGranted ? LocationPermissionStatus.granted : LocationPermissionStatus.denied),
                );
              }
            },
            child: const Text('Allow Access'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final profileState = context.watch<ProfileBloc>().state;
    final userName = profileState.profile?.fullName.split(' ').first ?? 'Friend';

    return BlocListener<HomepageBloc, HomepageState>(
      listenWhen: (prev, curr) => prev.locationPermission != curr.locationPermission,
      listener: (context, state) {
        if (state.locationPermission == LocationPermissionStatus.notAsked) {
          _showLocationRationale(context);
        }
      },
      child: BlocBuilder<HomepageBloc, HomepageState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              bottom: false,
              child: RefreshIndicator(
                onRefresh: () async => context.read<HomepageBloc>().add(LoadHomepage()),
                color: colorScheme.primary,
                backgroundColor: colorScheme.surface,
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  slivers: [
                    _HomeAppBar(onNavigate: onNavigate),
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: AppSpacing.md),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                            child: ModernHeader(name: userName, onNotifications: () => context.router.push(const NotificationsRoute())),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                            child: SellBanner(onTap: () => onNavigate(2)),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          if (state.loading)
                            const Padding(
                              padding: EdgeInsets.only(top: AppSpacing.xl),
                              child: SizedBox(height: 285, child: SkeletonList()),
                            )
                          else if (state.nearYouListings.isEmpty &&
                              state.picksForYouListings.isEmpty &&
                              state.justDroppedListings.isEmpty &&
                              state.trendingListings.isEmpty)
                            const SizedBox(height: 285, child: HomeEmptyState())
                          else ...[
                            if (state.nearYouListings.isNotEmpty)
                              _buildSection(context, 'New Listings Near You', Icons.location_on_rounded, state.nearYouListings, 'near_you'),
                            if (state.picksForYouListings.isNotEmpty)
                              _buildSection(context, 'Picks for You', Icons.auto_awesome_rounded, state.picksForYouListings, 'picks'),
                            if (state.justDroppedListings.isNotEmpty)
                              _buildSection(context, 'Just Dropped Today', Icons.bolt_rounded, state.justDroppedListings, 'dropped'),
                            if (state.trendingListings.isNotEmpty)
                              _buildSection(context, 'Trending This Week', Icons.trending_up_rounded, state.trendingListings, 'trending'),
                          ],
                          const SizedBox(height: 120),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, IconData icon, List<BookListing> listings, String heroPrefix) {
    if (listings.isEmpty) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.xl),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: HomeSectionTitle(
            icon: icon,
            title: title,
            trailing: title == 'Picks for You'
                ? GestureDetector(
                    onTap: () => onNavigate(1),
                    child: Text(
                      'See all',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.w700),
                    ),
                  )
                : null,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 285,
          child: HomeBookList(
            listings: listings,
            heroPrefix: heroPrefix,
            onBookTap: (listing) {
              final heroTag = '${heroPrefix}_book_image_${listing.id}';
              BookDetailSheet.show(context, listing: listing, heroTag: heroTag);
            },
          ),
        ),
      ],
    );
  }
}

class _HomeAppBar extends StatelessWidget {
  const _HomeAppBar({required this.onNavigate});
  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SliverAppBar(
      floating: true,
      pinned: false,
      snap: true,
      elevation: 0,
      backgroundColor: colorScheme.surfaceContainerLowest,
      surfaceTintColor: Colors.transparent,
      titleSpacing: AppSpacing.sm,
      leadingWidth: 52,
      leading: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: AppSpacing.md),
          child: GestureDetector(
            onTap: () => onNavigate(4),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: colorScheme.primaryContainer,
              child: Icon(Icons.person_rounded, size: 22, color: colorScheme.onPrimaryContainer),
            ),
          ),
        ),
      ),
      title: SizedBox(
        height: 40,
        child: AppSearchBar(readOnly: true, hintText: 'Search books...', onTap: () => onNavigate(1)),
      ),
      actions: [
        IconButton(
          onPressed: () => context.router.push(const ChatListRoute()),
          icon: Icon(Icons.forum_rounded, color: colorScheme.onSurface, size: 24),
        ),
        const SizedBox(width: AppSpacing.xs),
      ],
    );
  }
}
