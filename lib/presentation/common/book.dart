import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final String? imageUrl;
  final String? title;
  final List<String?>? authors;
  const BookCard({super.key, this.title, this.imageUrl, this.authors});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      child: Column(
        children: [
          Image.network(imageUrl ?? '', height: 130, width: 200, fit: BoxFit.fill),
          Text(title ?? '', maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
