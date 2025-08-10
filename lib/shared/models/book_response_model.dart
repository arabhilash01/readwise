import 'package:readwise/shared/models/book_model.dart';

class BookResponse {
  final int? count;
  final String? nextUrl;
  final String? previous;
  final List<Book>? results;

  BookResponse({required this.count, required this.nextUrl, required this.previous, required this.results});

  factory BookResponse.fromJson(Map<String, dynamic> json) {
    return BookResponse(
      count: json['count'],
      nextUrl: json['next'],
      previous: json['previous'],
      results: (json['results'] as List<dynamic>).map((e) => Book.fromJson(e)).toList(),
    );
  }
}
