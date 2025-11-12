import 'dart:io';
import 'package:epub_view/epub_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readwise/presentation/common/custom_appbar.dart';
import 'package:readwise/presentation/downloads/vm/downloads_vm.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DownloadsScreen extends ConsumerWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksState = ref.watch(downloadsViewModelProvider);
    final viewModel = ref.read(downloadsViewModelProvider.notifier);

    return Scaffold(
      appBar: CustomAppBar(titleText: 'Downloads'),
      body: booksState.when(
        data: (books) {
          if (books.isEmpty) {
            return const Center(child: Text('No downloaded books found.'));
          }

          return RefreshIndicator(
            onRefresh: () => viewModel.refresh(),
            child: ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final file = books[index];
                final name = file.path.split('/').last;

                return ListTile(
                  leading: const Icon(Icons.menu_book),
                  title: Text(name),
                  onTap: () => _openBook(context, file),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                    ),
                    onPressed: () async => viewModel.deleteBook(file),
                    tooltip: 'Delete Book',
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Future<void> _openBook(BuildContext context, File file) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'epub_last_location_${file.path}';
    final savedCfi = prefs.getString(key);

    final epubController = EpubController(
      document: EpubDocument.openFile(file),
      epubCfi: savedCfi,
    );
    if (!context.mounted) return;

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text(file.path.split('/').last)),
          body: EpubView(
            controller: epubController,
            onDocumentLoaded: (_) async {
              await prefs.setString(
                '${key}_lastOpened',
                DateTime.now().toIso8601String(),
              );
            },
            onChapterChanged: (_) async {
              final currentCfi = epubController.generateEpubCfi();
              if (currentCfi != null) {
                await prefs.setString(key, currentCfi);
              }
            },
            onDocumentError: (error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to open book: $error')),
              );
            },
          ),
        ),
      ),
    );
  }
}
