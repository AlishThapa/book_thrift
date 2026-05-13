import 'package:auto_route/auto_route.dart';
import 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, initial: true),
        AutoRoute(page: OnboardingRoute.page),
        AutoRoute(page: AuthEntryRoute.page),
        AutoRoute(page: ProfileSetupRoute.page),
        AutoRoute(page: MainShellRoute.page),
        AutoRoute(page: BookDetailRoute.page),
        AutoRoute(page: NotificationsRoute.page),
        AutoRoute(
          page: CreateListingRoute.page,
          fullscreenDialog: true,
        ),
        AutoRoute(page: AboutRoute.page),
        AutoRoute(page: SettingsRoute.page),
        AutoRoute(page: SearchRoute.page),
        AutoRoute(page: ChatListRoute.page),
        AutoRoute(page: ChatDetailRoute.page),
        AutoRoute(page: ProfileRoute.page),
        AutoRoute(page: WishlistRoute.page),
        AutoRoute(page: MyListingsRoute.page),
        AutoRoute(page: EditProfileRoute.page),
        AutoRoute(page: CartRoute.page),
        AutoRoute(page: CheckoutRoute.page),
      ];
}
