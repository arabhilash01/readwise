import 'dart:ui';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:readwise/app/router/route_constants.dart';
import 'package:readwise/app/router/routes.dart';

class BottomNavBar extends ConsumerStatefulWidget {
  const BottomNavBar({super.key});

  @override
  ConsumerState<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends ConsumerState<BottomNavBar> {
  final navBarItems = [
    NavBarItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      name: 'Home',
      routeName: RouteConstants.home,
    ),
    NavBarItem(
      icon: Icons.explore_outlined,
      activeIcon: Icons.explore,
      name: 'Explore',
      routeName: RouteConstants.explore,
    ),
    NavBarItem(
      icon: Icons.book_outlined,
      activeIcon: Icons.menu_book, // "book" often looks better than library
      name: 'Library',
      routeName: RouteConstants.downloads,
    ),
    NavBarItem(
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings,
      name: 'Settings',
      routeName: RouteConstants.settings,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // We want the bar to float above the content, so we rely on the Scaffold to place this
    // but we add our own margins/padding to make it look floating.

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 30),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              // Gradient for glass gloss
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.9),
                  Colors.white.withOpacity(0.6),
                ],
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
              // Border gradient to simulate light reflection
              border: Border.all(
                color: Colors.white.withOpacity(0.5),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: navBarItems.mapIndexed((index, item) {
                final isSelected = index == _calculateSelectedIndex;
                return GestureDetector(
                  onTap: () => _onTap(index, item.routeName),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF1B4332).withOpacity(0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isSelected ? item.activeIcon : item.icon,
                          color: isSelected
                              ? const Color(0xFF1B4332)
                              : Colors.grey[600],
                          size: 24,
                        ),
                        if (isSelected) ...[
                          const SizedBox(width: 8),
                          Text(
                            item.name,
                            style: const TextStyle(
                              color: Color(0xFF1B4332),
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  void _onTap(int index, String routeName) {
    if (index != _calculateSelectedIndex) {
      switch (routeName) {
        case RouteConstants.explore:
          ExplorePageRoute(
            $extra: index <= _calculateSelectedIndex,
          ).go(context);
          break;
        case RouteConstants.home:
          HomePageRoute($extra: index <= _calculateSelectedIndex).go(context);
          break;
        case RouteConstants.downloads:
          DownloadsPageRoute(
            $extra: index <= _calculateSelectedIndex,
          ).go(context);
          break;
        case RouteConstants.settings:
          SettingsPageRoute(
            $extra: index <= _calculateSelectedIndex,
          ).go(context);
          break;
      }
    }
  }

  int get _calculateSelectedIndex {
    final GoRouterState route = GoRouterState.of(context);
    // Simple logic: check first path segment matches route name
    // Adjust if paths become more complex.
    final String location = route.uri.path.split('/')[1];
    return navBarItems.indexWhere(
      (element) => location.toLowerCase().contains(
        element.routeName.toLowerCase().replaceAll('/', ''),
      ),
    );
  }
}

class NavBarItem {
  NavBarItem({
    required this.icon,
    required this.activeIcon,
    required this.name,
    required this.routeName,
  });

  final IconData icon;
  final IconData activeIcon;
  final String name;
  final String routeName;
}
