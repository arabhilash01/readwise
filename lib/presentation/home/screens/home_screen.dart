import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:readwise/app/theme/text_styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
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
                      bottom: 30,
                      left: 20,
                      child: Icon(Icons.menu_book, size: 80, color: Colors.white.withOpacity(0.1)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          Text(
                            'Hello, User',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'What bookish adventure\nare you looking for?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
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
            leading: Container(),
          ),
          SliverList(
            delegate: SliverChildListDelegate.fixed([
              Container(
                color: Colors.grey[100],
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 16,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Icon(Icons.grid_view, size: 20),
                                SizedBox(width: 8),
                                Text('Continue reading', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(
                                'https://cdn.penguin.co.in/wp-content/uploads/2022/01/9780143454212.jpg',
                                height: 100,
                                width: 100,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('The Great Gatsby', style: TextStyles.ui15SemiBold),
                                  Text('F. Scott Fitzgerald', style: TextStyles.ui13Medium),
                                  Gap(20),
                                  Stack(
                                    children: [
                                      DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: SizedBox(height: 6, width: 180),
                                      ),
                                      DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: Color(0xFF084516),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: SizedBox(height: 6, width: 120),
                                      ),
                                    ],
                                  ),
                                  Gap(6),
                                  Text('70%'),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.grid_view, size: 20),
                              SizedBox(width: 8),
                              Text('Categories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                            ],
                          ),
                          Icon(Icons.arrow_forward),
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildCategoryCard('Horror', Icons.games, Colors.brown),
                          SizedBox(width: 12),
                          _buildCategoryCard('Sports', Icons.sports_basketball, Colors.green),
                          SizedBox(width: 12),
                          _buildCategoryCard('Literature', Icons.edit, Colors.orange),
                          SizedBox(width: 12),
                          _buildCategoryCard('New', Icons.new_releases, Colors.blue),
                        ],
                      ),
                    ),
                    Gap(16),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 16,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Icon(Icons.history, size: 20),
                                SizedBox(width: 8),
                                Text('Recently Viewed', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              spacing: 6,
                              children: [
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Image.network(
                                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ2KuFBHfsxQZK3XSsXtiRqaXOWcRn2MId1Tw&s',
                                        height: 100,
                                        width: 80,
                                        fit: BoxFit.cover,
                                      ),
                                      Gap(6),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Harry Potter', style: TextStyles.ui15SemiBold),
                                            Text('J.K. Rowling', style: TextStyles.ui13Medium),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Image.network(
                                        'https://m.media-amazon.com/images/I/712cDO7d73L._UF1000,1000_QL80_.jpg',
                                        height: 100,
                                        width: 80,
                                        fit: BoxFit.cover,
                                      ),
                                      Gap(6),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('The Hobbit', style: TextStyles.ui15SemiBold),
                                            Text('J.R.R. Tolkien', style: TextStyles.ui13Medium),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 16,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Icon(Icons.favorite_border, size: 20),
                                SizedBox(width: 8),
                                Text('Favorites', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              spacing: 6,
                              children: [
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Image.network(
                                        'https://cdn.penguin.co.in/wp-content/uploads/2023/05/9780143454229.jpg',
                                        height: 100,
                                        width: 80,
                                        fit: BoxFit.cover,
                                      ),
                                      Gap(6),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Pride and Prejudice', style: TextStyles.ui15SemiBold),
                                            Text('Jane Austen', style: TextStyles.ui13Medium),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Image.network(
                                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTe2OB232subhhC0wsLSAljKYAzyAf6FyPqWA&s',
                                        height: 100,
                                        width: 80,
                                        fit: BoxFit.cover,
                                      ),
                                      Gap(6),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('To kill a mocking bird', style: TextStyles.ui15SemiBold),
                                            Text('Harper Lee', style: TextStyles.ui13Medium),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gap(100),
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
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: Offset(0, 2))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: color, size: 24),
            ),
            SizedBox(height: 4),
            Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
