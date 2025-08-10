import 'package:readwise/shared/models/author_model.dart';
import 'package:readwise/shared/models/book_format_model.dart';
import 'package:readwise/shared/models/translator_model.dart';

class Book {
  final int? id;
  final String? title;
  final List<Author>? authors;
  final List<String>? summaries;
  final List<Translator>? translators;
  final List<String>? subjects;
  final List<String>? bookshelves;
  final List<String>? languages;
  final bool? copyright;
  final String? mediaType;
  final Formats? formats;
  final int? downloadCount;

  Book({
    required this.id,
    required this.title,
    required this.authors,
    required this.summaries,
    required this.translators,
    required this.subjects,
    required this.bookshelves,
    required this.languages,
    required this.copyright,
    required this.mediaType,
    required this.formats,
    required this.downloadCount,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      authors: (json['authors'] as List).map((e) => Author.fromJson(e)).toList(),
      summaries: List<String>.from(json['summaries']),
      translators: (json['translators'] as List).map((e) => Translator.fromJson(e)).toList(),
      subjects: List<String>.from(json['subjects']),
      bookshelves: List<String>.from(json['bookshelves']),
      languages: List<String>.from(json['languages']),
      copyright: json['copyright'],
      mediaType: json['media_type'],
      formats: Formats.fromJson(json['formats']),
      downloadCount: json['download_count'],
    );
  }
}
