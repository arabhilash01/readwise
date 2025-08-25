import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:readwise/core/repositories/books/books_repository.dart';
import 'package:readwise/core/utils/permission_handlers.dart';
import 'package:readwise/shared/models/book_model.dart';

final bookInfoViewModelProvider = AsyncNotifierProvider.family<BookInfoViewModel, Book, String>(BookInfoViewModel.new);

class BookInfoViewModel extends FamilyAsyncNotifier<Book, String> {
  @override
  Future<Book> build(String bookId) async {
    return getBookById(bookId);
  }

  Future<Book> getBookById(String id) async {
    final repository = ref.read(booksRepositoryProvider);
    return await repository.getBookById(id);
  }

  Future<void> downloadBook(String url, String bookId, {Function(double)? onProgress}) async {
    final dir = await getApplicationDocumentsDirectory();
    if (await PermissionHandlers.requestStoragePermission()) {
      final file = File('${dir.path}/$bookId.epub');
      if (await file.exists()) {
        print('already exists');
        return;
      }

      final repository = ref.read(booksRepositoryProvider);
      final response = await repository.downloadBook(
        url,
        file.path,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = received / total;
            print('Download progress: ${(progress * 100).toStringAsFixed(1)}%');
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

  // Future<void> downloadBook(String url, String bookId, String savePath) async {
  //   final dir = await getApplicationDocumentsDirectory();
  //   print('downloading');
  //   if (await PermissionHandlers.requestStoragePermission()) {
  //     final file = File('${dir.path}/$bookId.epub');
  //     if (await file.exists()) {
  //       print('already exists');
  //       // return file;
  //     }
  //     final repository = ref.read(booksRepositoryProvider);
  //     final response = await repository.downloadBook(url, savePath);
  //     if (response.statusCode == 200) {
  //       print('download success');
  //     } else {
  //       throw Exception("Failed to download EPUB");
  //     }
  //   }
  // }
}
