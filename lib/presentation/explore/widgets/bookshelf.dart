import 'package:flutter/material.dart';
import 'package:readwise/app/router/routes.dart';
import 'package:readwise/presentation/common/book.dart';
import 'package:readwise/shared/models/book_response_model.dart';

class Bookshelf extends StatelessWidget {
  const Bookshelf({super.key, required this.bookResponse});

  final BookResponse bookResponse;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: bookResponse.results?.length,
      itemBuilder: (context, index) {
        final bookData = bookResponse.results?[index];
        return BookCard(
          imageUrl: bookData?.formats?.coverImage,
          title: bookData?.title,
          onTap: () => BookInfoPageRoute(bookId: bookData?.id.toString() ?? '').push(context),
        );
      },
    );
  }
}
