import 'dart:io';
import 'package:epub_view/epub_view.dart' hide Image;
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
      appBar: const CustomAppBar(titleText: 'My Library'),
      backgroundColor: Colors.grey[50],
      body: booksState.when(
        data: (books) {
          if (books.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.library_books, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Your library is empty',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Downloaded books will appear here',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Navigate to Explore
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      // In a real app with bottom nav, we'd switch tabs.
                      // For now, assume this resets to Home/Explore context if plausible,
                      // or just acts as a hint.
                    },
                    icon: const Icon(Icons.explore),
                    label: const Text('Browse Books'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B4332), // Forest Green
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => viewModel.refresh(),
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                // Use the title from metadata, or fallback to filename if needed (though model has title)
                // We actually access book.title directly in the Text widget below.

                return GestureDetector(
                  onTap: () => _openBook(context, book.file),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: book.coverUrl != null
                                ? Image.network(
                                    book.coverUrl!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder: (ctx, _, __) =>
                                        _buildPlaceholder(index),
                                  )
                                : _buildPlaceholder(index),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                book.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                book.author,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      size: 20,
                                      color: Colors.redAccent,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () =>
                                        viewModel.deleteBook(book.file),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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

  Widget _buildPlaceholder(int index) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.primaries[index % Colors.primaries.length].withOpacity(
          0.2,
        ),
      ),
      child: Icon(
        Icons.book,
        size: 50,
        color: Colors.primaries[index % Colors.primaries.length],
      ),
    );
  }

  Future<void> _openBook(BuildContext context, File file) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'epub_last_location_${file.path}';
    final savedCfi = prefs.getString(key);

    if (!context.mounted) return;

    final epubController = EpubController(
      document: EpubDocument.openFile(file),
      epubCfi: savedCfi,
    );

    // ignore: use_build_context_synchronously
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
              // ignore: use_build_context_synchronously
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
