import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readwise/core/repositories/books/books_repository.dart';
import 'package:readwise/shared/models/book_response_model.dart';

final exploreViewModelProvider =
    AsyncNotifierProvider<ExploreViewModel, BookResponse>(ExploreViewModel.new);

class ExploreViewModel extends AsyncNotifier<BookResponse> {
  @override
  Future<BookResponse> build() async {
    final repository = ref.read(booksRepositoryProvider);
    return await repository.getBooks();
  }

  Future<void> searchBooks(String query) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(booksRepositoryProvider);
      return await repository.getBooks(search: query);
    });
  }

  Future<void> getBooksByLanguage(String langCode) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(booksRepositoryProvider);
      return await repository.getBooks(languages: langCode);
    });
  }

  Future<void> getBooksByCategory(String category) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(booksRepositoryProvider);
      return await repository.getBooks(topic: category);
    });
  }

  Future<void> loadMore() async {
    final currentState = state.value;
    if (currentState == null || currentState.nextUrl == null) return;

    final nextUrl = currentState.nextUrl!;
    final uri = Uri.parse(nextUrl);
    final pageStr = uri.queryParameters['page'];
    final cursor = uri.queryParameters['cursor'];
    if (pageStr == null && cursor == null) return;

    final repository = ref.read(booksRepositoryProvider);
    final newData = await repository.getBooks(
      page: pageStr != null ? int.tryParse(pageStr) : null,
      cursor: cursor,
    );

    state = AsyncValue.data(
      BookResponse(
        count: newData.count,
        nextUrl: newData.nextUrl,
        previous: newData.previous,
        results: [...?currentState.results, ...?newData.results],
      ),
    );
  }
}
