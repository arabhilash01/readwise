import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final downloadsViewModelProvider =
AsyncNotifierProvider<DownloadsViewModel, List<File>>(DownloadsViewModel.new);

class DownloadsViewModel extends AsyncNotifier<List<File>> {
  final _repository = DownloadsRepository();

  @override
  Future<List<File>> build() async {
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
  Future<List<File>> getDownloadedBooks() async {
    final dir = await getApplicationDocumentsDirectory();
    final files = dir.listSync();
    return files
        .whereType<File>()
        .where((f) => f.path.endsWith('.epub'))
        .toList();
  }

  Future<void> deleteBook(File file) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'epub_last_location_${file.path}';

    if (await file.exists()) {
      await file.delete();
    }

    await prefs.remove(key);
    await prefs.remove('${key}_lastOpened');
  }
}

