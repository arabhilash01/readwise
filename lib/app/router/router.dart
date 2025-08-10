import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:readwise/app/router/routes.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

final routerProvider = AutoDisposeProvider<GoRouter>(router);

final _securedRoutes = [
  //TODO add secured routes
];

GoRouter router(Ref<GoRouter> ref) {
  //TODO auth check

  final router = GoRouter(
    initialLocation: HomePageRoute().location,
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: true,
    routes: $appRoutes,
  );

  ref.onDispose(router.dispose);
  return router;
}
