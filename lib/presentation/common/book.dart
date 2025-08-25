import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final String? imageUrl;
  final String? title;
  final List<String?>? authors;
  final VoidCallback onTap;
  const BookCard({super.key, this.title, this.imageUrl, this.authors, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 200,
        height: 200,
        child: Column(
          children: [
            Image.network(imageUrl ?? '', height: 130, width: 200, fit: BoxFit.fill),
            Text(title ?? '', maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}
