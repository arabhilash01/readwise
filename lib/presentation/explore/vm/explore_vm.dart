import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readwise/core/repositories/books/books_repository.dart';
import 'package:readwise/shared/models/book_response_model.dart';

final exploreViewModelProvider = AsyncNotifierProvider<ExploreViewModel, BookResponse>(ExploreViewModel.new);

class ExploreViewModel extends AsyncNotifier<BookResponse> {
  @override
  Future<BookResponse> build() async {
    return getBooks();
  }

  Future<BookResponse> getBooks() async {
    final repository = ref.read(booksRepositoryProvider);
    return await repository.getBooks();
  }

  Future<BookResponse> getBooksByLanguage(String langCode) async {
    final repository = ref.read(booksRepositoryProvider);
    return await repository.getBooksByLanguage(langCode);
  }

  Future<BookResponse> getBooksByCategory(String category) async {
    final repository = ref.read(booksRepositoryProvider);
    return await repository.getBooksByLanguage(category);
  }
}
