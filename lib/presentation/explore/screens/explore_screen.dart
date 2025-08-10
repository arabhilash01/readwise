import 'package:flutter/material.dart';
import 'package:readwise/presentation/common/custom_appbar.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: 'Explore'),
      body: Column(children: [Text('Explore New titles')]),
    );
  }
}
