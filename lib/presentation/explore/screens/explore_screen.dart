import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readwise/presentation/explore/vm/explore_vm.dart';
import 'package:readwise/presentation/explore/widgets/bookshelf.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksAsync = ref.watch(exploreViewModelProvider);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1B4332), Color(0xFF2D5016), Color(0xFF40641C)],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 50,
                      right: 20,
                      child: Icon(Icons.auto_stories, size: 100, color: Colors.white.withOpacity(0.1)),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 20,
                      child: Icon(Icons.menu_book, size: 80, color: Colors.white.withOpacity(0.1)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 40),
                          Text(
                            'What bookish adventure\nare you looking for?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          SizedBox(height: 30),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search for books...',
                                hintStyle: TextStyle(color: Colors.grey[600]),
                                border: InputBorder.none,
                                icon: Icon(Icons.search, color: Colors.grey[600]),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            leading: Container(),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.grey[100],
              child: Padding(
                padding: const EdgeInsets.all(16).copyWith(bottom: 0, top: 0),
                child: booksAsync.when(
                  data: (data) {
                    return Bookshelf(bookResponse: data);
                  },
                  error: (error, stackTrace) {
                    return Text('Something Went Wrong');
                  },
                  loading: () {
                    return CircularProgressIndicator();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
