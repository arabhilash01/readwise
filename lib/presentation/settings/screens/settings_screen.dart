import 'package:flutter/material.dart';
import 'package:readwise/presentation/common/custom_appbar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: 'Settings'),
      body: Column(children: [Text('Settings page')]),
    );
  }
}
