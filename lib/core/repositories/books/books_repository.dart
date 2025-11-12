import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readwise/core/services/api_service.dart';
import 'package:readwise/shared/models/book_model.dart';
import 'package:readwise/shared/models/book_response_model.dart';

final booksRepositoryProvider = Provider<BooksRepository>((ref) {
  final apiService = ApiService();
  return BooksRepository(apiService);
});

class BooksRepository {
  final ApiService _apiService;

  BooksRepository(this._apiService);

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

  Future<Response<dynamic>> downloadBook(String url, String savePath, {Function(int, int)? onReceiveProgress}) async {
    try {
      return _apiService.download(url, savePath, onReceiveProgress: onReceiveProgress);
    } catch (e) {
      print(e.toString());
      throw Exception('failed to download book');
    }
  }
}
