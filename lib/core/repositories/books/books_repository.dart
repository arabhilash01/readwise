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

  Future<BookResponse> getBooks({
    String? search,
    String? topic,
    String? languages,
    String? ids,
    String? mimeType,
    bool? copyright,
    int? page,
    String? cursor,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {};
      if (search != null) queryParams['search'] = search;
      if (topic != null) queryParams['topic'] = topic;
      if (languages != null) queryParams['languages'] = languages;
      if (ids != null) queryParams['ids'] = ids;
      if (mimeType != null) queryParams['mime_type'] = mimeType;
      if (copyright != null) queryParams['copyright'] = copyright.toString();
      if (page != null) queryParams['page'] = page;
      if (cursor != null) queryParams['cursor'] = cursor;

      final response = await _apiService.get('books', queryParams);
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

  Future<Response<dynamic>> downloadBook(
    String url,
    String savePath, {
    Function(int, int)? onReceiveProgress,
  }) async {
    try {
      return _apiService.download(
        url,
        savePath,
        onReceiveProgress: onReceiveProgress,
      );
    } catch (e) {
      print(e.toString());
      throw Exception('failed to download book');
    }
  }
}
