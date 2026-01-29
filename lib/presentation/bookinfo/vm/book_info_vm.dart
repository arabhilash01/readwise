import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readwise/core/repositories/books/books_repository.dart';
import 'package:readwise/presentation/downloads/vm/downloads_vm.dart';
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
    Book book,
    String savePath, {
    Function(double)? onProgress,
  }) async {
    final repository = ref.read(booksRepositoryProvider);
    final url = book.formats?.epub;

    if (url == null || url.isEmpty) {
      throw Exception("No EPUB link available");
    }

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
      // Save metadata
      await DownloadsRepository().saveBookMetadata(book);

      // Auto-refresh downloads list
      ref.invalidate(downloadsViewModelProvider);

      print('download success');
    } else {
      throw Exception("Failed to download EPUB");
    }
  }
}
