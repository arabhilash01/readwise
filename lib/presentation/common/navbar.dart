import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:readwise/app/constants/assets.dart';
import 'package:readwise/app/router/route_constants.dart';
import 'package:readwise/app/router/routes.dart';
import 'package:readwise/app/theme/text_styles.dart';

class BottomNavBar extends ConsumerStatefulWidget {
  const BottomNavBar({super.key});

  @override
  ConsumerState<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends ConsumerState<BottomNavBar> {
  final navBarItems = [
    NavBarItem(iconPath: Assets.exploreIcon, name: 'Explore', routeName: RouteConstants.explore),
    NavBarItem(iconPath: Assets.homeIcon, name: 'Home', routeName: RouteConstants.home),
    NavBarItem(iconPath: Assets.downloadsIcon, name: 'Downloads', routeName: RouteConstants.downloads),
    NavBarItem(iconPath: Assets.settingsIcon, name: 'Settings', routeName: RouteConstants.settings),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomSafeArea = MediaQuery.of(context).padding.bottom;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50, tileMode: TileMode.mirror),
        child: Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(width: 1, color: Colors.black)),
            color: Colors.white60,
          ),
          width: double.infinity,
          height: kBottomNavigationBarHeight + 8 + bottomSafeArea,
          padding: EdgeInsets.only(bottom: bottomSafeArea),
          child: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: navBarItems
                    .mapIndexed(
                      (index, element) => Expanded(
                        child: InkWell(
                          onTap: () => _onTap(index, element.routeName),
                          child: Center(
                            child: _BottomNavBarItem(
                              iconPath: element.iconPath,
                              label: element.name,
                              isSelected: index == _calculateSelectedIndex,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTap(int index, String routeName) {
    if (index != _calculateSelectedIndex) {
      switch (routeName) {
        case RouteConstants.explore:
          ExplorePageRoute($extra: index <= _calculateSelectedIndex).go(context);
          break;
        case RouteConstants.home:
          HomePageRoute($extra: index <= _calculateSelectedIndex).go(context);
          break;
        case RouteConstants.downloads:
          DownloadsPageRoute($extra: index <= _calculateSelectedIndex).go(context);
          break;
        case RouteConstants.settings:
          SettingsPageRoute($extra: index <= _calculateSelectedIndex).go(context);
          break;
      }
    }
  }

  int get _calculateSelectedIndex {
    final GoRouterState route = GoRouterState.of(context);
    final String location = route.uri.path.split('/')[1];
    return navBarItems.indexWhere((element) => location.toLowerCase() == element.routeName.toLowerCase());
  }
}

class _BottomNavBarItem extends StatelessWidget {
  const _BottomNavBarItem({required this.iconPath, required this.label, required this.isSelected});

  final String iconPath;
  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(iconPath, color: _color, width: 20, height: 20),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(label, style: TextStyles.ui12Regular.copyWith(color: _textColor)),
        ),
      ],
    );
  }

  Color get _color => isSelected ? Colors.blue : Colors.black;

  Color get _textColor => isSelected ? Colors.blue : Colors.black;
}

class NavBarItem {
  NavBarItem({required this.iconPath, required this.name, required this.routeName});

  final String iconPath;
  final String name;
  final String routeName;
}
