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
      appBar: AppBar(
        title: const Text(
          'All Categories',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: GridView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.5,
        ),
        itemBuilder: (context, index) {
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
                          color: (category['color'] as Color).withOpacity(0.2),
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
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
