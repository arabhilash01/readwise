import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readwise/presentation/explore/screens/categories_screen.dart';
import 'package:readwise/presentation/explore/screens/explore_screen.dart';
import 'package:readwise/presentation/home/vm/home_vm.dart';
import 'package:readwise/presentation/home/widgets/book_horizontal_list.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeViewModelProvider);

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 240.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1B4332),
                      Color(0xFF2D5016),
                      Color(0xFF40641C),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 50,
                      right: 20,
                      child: Icon(
                        Icons.auto_stories,
                        size: 100,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    Positioned(
                      bottom: 30,
                      left: 20,
                      child: Icon(
                        Icons.menu_book,
                        size: 80,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          Text(
                            'Hello, Reader',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'What bookish adventure\nare you looking for?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate.fixed([
              if (homeState.isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 50),
                  child: Center(child: CircularProgressIndicator()),
                )
              else
                Container(
                  color: Colors.grey[100],
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      // Categories
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.category, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Explore Categories',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CategoriesScreen(),
                                  ),
                                );
                              },
                              child: const Text('See All'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildCategoryCard(
                              'Fiction',
                              Icons.auto_stories,
                              Colors.purple,
                            ),
                            const SizedBox(width: 12),
                            _buildCategoryCard(
                              'History',
                              Icons.history_edu,
                              Colors.brown,
                            ),
                            const SizedBox(width: 12),
                            _buildCategoryCard(
                              'Poetry',
                              Icons.edit_note,
                              Colors.pink,
                            ),
                            const SizedBox(width: 12),
                            _buildCategoryCard(
                              'Sci-Fi',
                              Icons.rocket_launch,
                              Colors.blue,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Trending
                      BookHorizontalList(
                        title: 'Trending Now',
                        books: homeState.trending,
                      ),
                      const SizedBox(height: 24),

                      // Philosophy
                      BookHorizontalList(
                        title: 'Dive into Philosophy',
                        books: homeState.philosophy,
                      ),
                      const SizedBox(height: 24),

                      // Adventure
                      BookHorizontalList(
                        title: 'Adventure Awaits',
                        books: homeState.adventure,
                      ),
                    ],
                  ),
                ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String title, IconData icon, Color color) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExploreScreen(initialCategory: title),
            ),
          );
        },
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
