import 'package:readwise/core/services/api_service.dart';
import 'package:readwise/shared/models/book_model.dart';
import 'package:readwise/shared/models/book_response_model.dart';

class BooksRepository {
  final ApiService _apiService = ApiService();

  Future<BookResponse> getBooks() async {
    try {
      final response = await _apiService.get('books');
      return BookResponse.fromJson(response.data);
    } catch (e) {
      print(e.toString());
      throw Exception('failed to get books');
    }
  }

  Future<BookResponse> getBooksByLanguage(String language) async {
    try {
      final response = await _apiService.get('books', {'languages': language});
      return BookResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('failed to get books');
    }
  }

  Future<BookResponse> getBooksByCategory(String category) async {
    try {
      final response = await _apiService.get('books', {'topic': category});
      return BookResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('failed to get books');
    }
  }

  Future<BookResponse> getBooksByIds(String ids) async {
    try {
      final response = await _apiService.get('books', {'ids': ids});
      return BookResponse.fromJson(response.data);
    } catch (e) {
      print(e.toString());
      throw Exception('failed to get books');
    }
  }

  Future<Book> getBookById(String id) async {
    try {
      final response = await _apiService.get('books/$id');
      return Book.fromJson(response.data);
    } catch (e) {
      print(e.toString());
      throw Exception('failed to get book');
    }
  }
}
