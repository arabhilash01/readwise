import 'package:flutter/material.dart';
import 'package:readwise/presentation/common/book.dart';
import 'package:readwise/shared/models/book_response_model.dart';

class Bookshelf extends StatelessWidget {
  const Bookshelf({super.key, required this.bookResponse});

  final BookResponse bookResponse;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: bookResponse.results?.length,
      itemBuilder: (context, index) {
        return BookCard(
          imageUrl: bookResponse.results?[index].formats?.coverImage,
          title: bookResponse.results?[index].title,
        );
      },
    );
  }
}
