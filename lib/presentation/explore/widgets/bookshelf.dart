import 'package:flutter/material.dart';
import 'package:readwise/app/router/routes.dart';
import 'package:readwise/presentation/bookinfo/screens/book_info_screen.dart';
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
        crossAxisSpacing: 16,
        mainAxisSpacing: 24,
        childAspectRatio: 0.65, // Adjusted for book cover + text
      ),
      itemCount: bookResponse.results?.length ?? 0,
      itemBuilder: (context, index) {
        final bookData = bookResponse.results![index];
        return BookCard(
          imageUrl: bookData.formats?.coverImage,
          title: bookData.title,
          authors: bookData.authors?.map((a) => a.name).toList(),
          onTap: () =>
              BookInfoPageRoute(bookId: bookData.id.toString()).push(context),
        );
      },
    );
  }
}
