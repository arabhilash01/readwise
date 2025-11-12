import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readwise/core/repositories/books/books_repository.dart';
import 'package:readwise/core/utils/permission_handlers.dart';
import 'package:readwise/shared/models/book_model.dart';

final bookInfoViewModelProvider =
    AsyncNotifierProvider.family<BookInfoViewModel, Book, String>(
      BookInfoViewModel.new,
    );

class BookInfoViewModel extends FamilyAsyncNotifier<Book, String> {
  @override
  Future<Book> build(String bookId) async {
    return getBookById(bookId);
  }

  Future<Book> getBookById(String id) async {
    final repository = ref.read(booksRepositoryProvider);
    return await repository.getBookById(id);
  }

  Future<void> downloadBook(
    String url,
    String savePath, {
    Function(double)? onProgress,
  }) async {
    final repository = ref.read(booksRepositoryProvider);
    final response = await repository.downloadBook(
      url,
      savePath,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          final progress = received / total;
          onProgress?.call(progress);
        }
      },
    );
    if (response.statusCode == 200) {
      print('download success');
    } else {
      throw Exception("Failed to download EPUB");
    }
  }
}
