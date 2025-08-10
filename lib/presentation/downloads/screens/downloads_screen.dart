import 'package:flutter/material.dart';
import 'package:readwise/presentation/common/custom_appbar.dart';

class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: 'Downloads'),
      body: Column(children: [Text('Your downloaded items')]),
    );
  }
}
