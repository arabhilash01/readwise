import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readwise/presentation/common/custom_appbar.dart';
import 'package:readwise/presentation/explore/vm/explore_vm.dart';
import 'package:readwise/presentation/explore/widgets/bookshelf.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksAsync = ref.watch(exploreViewModelProvider);
    return Scaffold(
      appBar: CustomAppBar(titleText: 'Explore New Titles'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: booksAsync.when(
          data: (data) {
            return Bookshelf(bookResponse: data);
          },
          error: (error, stackTrace) {
            return Center(child: Text('Something went wrong'));
          },
          loading: () {
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
