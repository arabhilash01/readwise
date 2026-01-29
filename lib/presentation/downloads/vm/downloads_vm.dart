import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:readwise/shared/models/book_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DownloadedBook {
  final File file;
  final String title;
  final String author;
  final String? coverUrl;

  DownloadedBook({
    required this.file,
    required this.title,
    required this.author,
    this.coverUrl,
  });
}

final downloadsViewModelProvider =
    AsyncNotifierProvider<DownloadsViewModel, List<DownloadedBook>>(
      DownloadsViewModel.new,
    );

class DownloadsViewModel extends AsyncNotifier<List<DownloadedBook>> {
  final _repository = DownloadsRepository();

  @override
  Future<List<DownloadedBook>> build() async {
    return _repository.getDownloadedBooks();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repository.getDownloadedBooks());
  }

  Future<void> deleteBook(File file) async {
    await _repository.deleteBook(file);
    await refresh();
  }
}

class DownloadsRepository {
  Future<void> saveBookMetadata(Book book) async {
    final prefs = await SharedPreferences.getInstance();
    final metaKey = 'book_meta_${book.id}';
    final metadata = {
      'title': book.title ?? 'Unknown',
      'author': book.authors?.map((a) => a.name).join(', ') ?? 'Unknown Author',
      'coverUrl': book.formats?.coverImage,
    };
    await prefs.setString(metaKey, jsonEncode(metadata));
  }

  Future<List<DownloadedBook>> getDownloadedBooks() async {
    final dir = await getApplicationDocumentsDirectory();
    if (!dir.existsSync()) return [];

    final files = dir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.epub'))
        .toList();

    final prefs = await SharedPreferences.getInstance();
    List<DownloadedBook> downloadedBooks = [];

    for (var file in files) {
      // Extract ID from filename: book_{id}.epub
      final filename = file.path.split('/').last;
      final idPart = filename.replaceAll('book_', '').replaceAll('.epub', '');

      final metaKey = 'book_meta_$idPart';
      final metaJson = prefs.getString(metaKey);

      String title = filename;
      String author = 'Unknown';
      String? coverUrl;

      if (metaJson != null) {
        try {
          final map = jsonDecode(metaJson) as Map<String, dynamic>;
          title = map['title'] ?? title;
          author = map['author'] ?? author;
          coverUrl = map['coverUrl'];
        } catch (e) {
          // Fallback to filename if JSON parse fails
        }
      }

      downloadedBooks.add(
        DownloadedBook(
          file: file,
          title: title,
          author: author,
          coverUrl: coverUrl,
        ),
      );
    }
    return downloadedBooks;
  }

  Future<void> deleteBook(File file) async {
    final prefs = await SharedPreferences.getInstance();

    // Extract ID for meta deletion
    final filename = file.path.split('/').last;
    final idPart = filename.replaceAll('book_', '').replaceAll('.epub', '');
    final metaKey = 'book_meta_$idPart';
    final locationKey = 'epub_last_location_${file.path}';

    if (await file.exists()) {
      await file.delete();
    }

    await prefs.remove(metaKey);
    await prefs.remove(locationKey);
    await prefs.remove('${locationKey}_lastOpened');
  }
}
