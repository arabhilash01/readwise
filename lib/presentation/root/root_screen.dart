import 'package:flutter/material.dart';
import 'package:readwise/presentation/common/navbar.dart';

class RootScreen extends StatelessWidget {
  final Widget child;

  const RootScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: child, extendBody: true, bottomNavigationBar: BottomNavBar());
  }
}
