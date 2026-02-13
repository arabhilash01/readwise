import 'package:flutter/material.dart';
import 'package:readwise/presentation/explore/screens/explore_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  final List<Map<String, dynamic>> categories = const [
    {'name': 'Fiction', 'icon': Icons.auto_stories, 'color': Colors.purple},
    {'name': 'Mystery', 'icon': Icons.search, 'color': Colors.indigo},
    {'name': 'Thriller', 'icon': Icons.visibility, 'color': Colors.deepPurple},
    {'name': 'Romance', 'icon': Icons.favorite, 'color': Colors.pink},
    {'name': 'Horror', 'icon': Icons.psychology_alt, 'color': Colors.red},
    {
      'name': 'Science Fiction',
      'icon': Icons.rocket_launch,
      'color': Colors.blue,
    },
    {'name': 'Fantasy', 'icon': Icons.castle, 'color': Colors.teal},
    {'name': 'History', 'icon': Icons.history_edu, 'color': Colors.brown},
    {'name': 'Biography', 'icon': Icons.person, 'color': Colors.amber},
    {'name': 'Science', 'icon': Icons.science, 'color': Colors.cyan},
    {'name': 'Philosophy', 'icon': Icons.lightbulb, 'color': Colors.orange},
    {'name': 'Religion', 'icon': Icons.church, 'color': Colors.deepOrange},
    {'name': 'Art', 'icon': Icons.palette, 'color': Colors.purpleAccent},
    {'name': 'Music', 'icon': Icons.music_note, 'color': Colors.blueAccent},
    {'name': 'Travel', 'icon': Icons.flight, 'color': Colors.green},
    {'name': 'Cooking', 'icon': Icons.restaurant, 'color': Colors.redAccent},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 120.0,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: const Color(0xFF1B4332), // Forest Green
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: const Text(
                'Browse Categories',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize:
                      20, // Slightly smaller than Explore's 24 since it might be longer or just to differentiate
                ),
              ),
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
                      right: -30,
                      top: -20,
                      child: Icon(
                        Icons.category,
                        size: 150,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      bottom: 40,
                      child: Icon(
                        Icons.library_books,
                        size: 60,
                        color: Colors.white.withOpacity(0.05),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.5,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final category = categories[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExploreScreen(
                          initialCategory: category['name'] as String,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: (category['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: (category['color'] as Color).withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: (category['color'] as Color).withOpacity(
                                  0.2,
                                ),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            category['icon'] as IconData,
                            color: category['color'] as Color,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          category['name'] as String,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }, childCount: categories.length),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 120)),
        ],
      ),
    );
  }
}
