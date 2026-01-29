import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readwise/core/repositories/books/books_repository.dart';
import 'package:readwise/shared/models/book_model.dart';

class HomeState {
  final List<Book> trending;
  final List<Book> philosophy;
  final List<Book> adventure;
  final bool isLoading;

  HomeState({
    required this.trending,
    required this.philosophy,
    required this.adventure,
    required this.isLoading,
  });

  factory HomeState.initial() =>
      HomeState(trending: [], philosophy: [], adventure: [], isLoading: true);

  HomeState copyWith({
    List<Book>? trending,
    List<Book>? philosophy,
    List<Book>? adventure,
    bool? isLoading,
  }) {
    return HomeState(
      trending: trending ?? this.trending,
      philosophy: philosophy ?? this.philosophy,
      adventure: adventure ?? this.adventure,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final homeViewModelProvider = StateNotifierProvider<HomeViewModel, HomeState>((
  ref,
) {
  return HomeViewModel(ref.read(booksRepositoryProvider));
});

class HomeViewModel extends StateNotifier<HomeState> {
  final BooksRepository _repository;

  HomeViewModel(this._repository) : super(HomeState.initial()) {
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      state = state.copyWith(isLoading: true);

      // Fetch concurrently for speed
      final results = await Future.wait([
        _repository.getBooks(), // Trending (default)
        _repository.getBooks(topic: 'philosophy'),
        _repository.getBooks(topic: 'adventure'),
      ]);

      state = state.copyWith(
        trending: results[0].results ?? [],
        philosophy: results[1].results ?? [],
        adventure: results[2].results ?? [],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
      // Handle error gracefully - in a real app we might set an error state
      print("Error fetching home data: $e");
    }
  }
}
