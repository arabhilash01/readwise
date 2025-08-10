// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$shellRoute];

RouteBase get $shellRoute => ShellRouteData.$route(
  navigatorKey: ShellRoute.$navigatorKey,
  factory: $ShellRouteExtension._fromState,
  routes: [
    GoRouteData.$route(path: '/home', factory: _$HomePageRoute._fromState),
    GoRouteData.$route(
      path: '/settings',

      factory: _$SettingsPageRoute._fromState,
    ),
    GoRouteData.$route(
      path: '/explore',

      factory: _$ExplorePageRoute._fromState,
    ),
    GoRouteData.$route(
      path: '/downloads',

      factory: _$DownloadsPageRoute._fromState,
    ),
  ],
);

extension $ShellRouteExtension on ShellRoute {
  static ShellRoute _fromState(GoRouterState state) => const ShellRoute();
}

mixin _$HomePageRoute on GoRouteData {
  static HomePageRoute _fromState(GoRouterState state) =>
      HomePageRoute($extra: state.extra as bool?);

  HomePageRoute get _self => this as HomePageRoute;

  @override
  String get location => GoRouteData.$location('/home');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

mixin _$SettingsPageRoute on GoRouteData {
  static SettingsPageRoute _fromState(GoRouterState state) =>
      SettingsPageRoute($extra: state.extra as bool?);

  SettingsPageRoute get _self => this as SettingsPageRoute;

  @override
  String get location => GoRouteData.$location('/settings');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

mixin _$ExplorePageRoute on GoRouteData {
  static ExplorePageRoute _fromState(GoRouterState state) =>
      ExplorePageRoute($extra: state.extra as bool?);

  ExplorePageRoute get _self => this as ExplorePageRoute;

  @override
  String get location => GoRouteData.$location('/explore');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

mixin _$DownloadsPageRoute on GoRouteData {
  static DownloadsPageRoute _fromState(GoRouterState state) =>
      DownloadsPageRoute($extra: state.extra as bool?);

  DownloadsPageRoute get _self => this as DownloadsPageRoute;

  @override
  String get location => GoRouteData.$location('/downloads');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}
