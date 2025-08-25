import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:readwise/app/router/router.dart';
import 'package:readwise/presentation/bookinfo/screens/book_info_screen.dart';
import 'package:readwise/presentation/downloads/screens/downloads_screen.dart';
import 'package:readwise/presentation/explore/screens/explore_screen.dart';
import 'package:readwise/presentation/home/screens/home_screen.dart';
import 'package:readwise/presentation/root/root_screen.dart';
import 'package:readwise/presentation/settings/screens/settings_screen.dart';

part 'routes.g.dart';

CustomTransitionPage<T> buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) => SlideTransition(
      position: state.extra != true
          ? Tween<Offset>(begin: const Offset(1, 0), end: const Offset(0, 0)).animate(animation)
          : Tween<Offset>(begin: const Offset(-1, 0), end: const Offset(0, 0)).animate(animation),
      child: child,
    ),
  );
}

@TypedShellRoute<ShellRoute>(
  routes: <TypedRoute<RouteData>>[
    TypedGoRoute<HomePageRoute>(path: '/home'),
    TypedGoRoute<SettingsPageRoute>(path: '/settings'),
    TypedGoRoute<ExplorePageRoute>(
      path: '/explore',
      routes: [TypedGoRoute<BookInfoPageRoute>(path: ':bookId')],
    ),
    TypedGoRoute<DownloadsPageRoute>(path: '/downloads'),
  ],
)
class ShellRoute extends ShellRouteData {
  const ShellRoute();

  static final GlobalKey<NavigatorState> $navigatorKey = shellNavigatorKey;

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return RootScreen(key: state.pageKey, child: navigator);
  }
}

class HomePageRoute extends GoRouteData with _$HomePageRoute {
  HomePageRoute({this.$extra});

  final bool? $extra;

  @override
  CustomTransitionPage<void> buildPage(BuildContext context, GoRouterState state) {
    return buildPageWithDefaultTransition(child: const HomeScreen(), context: context, state: state);
  }
}

class SettingsPageRoute extends GoRouteData with _$SettingsPageRoute {
  SettingsPageRoute({this.$extra});

  final bool? $extra;

  @override
  CustomTransitionPage<void> buildPage(BuildContext context, GoRouterState state) {
    return buildPageWithDefaultTransition(child: const SettingsScreen(), context: context, state: state);
  }
}

class ExplorePageRoute extends GoRouteData with _$ExplorePageRoute {
  ExplorePageRoute({this.$extra});

  final bool? $extra;

  @override
  CustomTransitionPage<void> buildPage(BuildContext context, GoRouterState state) {
    return buildPageWithDefaultTransition(child: const ExploreScreen(), context: context, state: state);
  }
}

class BookInfoPageRoute extends GoRouteData with _$BookInfoPageRoute {
  BookInfoPageRoute({required this.bookId});

  final String bookId;

  @override
  CustomTransitionPage<void> buildPage(BuildContext context, GoRouterState state) {
    return buildPageWithDefaultTransition(
      child: BookInfoScreen(bookId: bookId),
      context: context,
      state: state,
    );
  }
}

class DownloadsPageRoute extends GoRouteData with _$DownloadsPageRoute {
  DownloadsPageRoute({this.$extra});

  final bool? $extra;

  @override
  CustomTransitionPage<void> buildPage(BuildContext context, GoRouterState state) {
    return buildPageWithDefaultTransition(child: const DownloadsScreen(), context: context, state: state);
  }
}
