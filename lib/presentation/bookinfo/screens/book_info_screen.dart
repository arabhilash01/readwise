import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:epub_view/epub_view.dart' hide Image;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:readwise/presentation/bookinfo/vm/book_info_vm.dart';
import 'package:readwise/shared/models/book_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookInfoScreen extends ConsumerStatefulWidget {
  final String bookId;

  const BookInfoScreen({super.key, required this.bookId});

  @override
  ConsumerState<BookInfoScreen> createState() => _BookInfoScreenState();
}

class _BookInfoScreenState extends ConsumerState<BookInfoScreen> {
  double _downloadProgress = 0.0;
  bool _isDownloading = false;
  bool _isDownloaded = false;
  File? _bookFile;

  @override
  void initState() {
    super.initState();
    _checkDownloadStatus();
  }

  Future<void> _checkDownloadStatus() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/book_${widget.bookId}.epub');
    if (await file.exists()) {
      if (mounted) {
        setState(() {
          _isDownloaded = true;
          _bookFile = file;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookAsyncValue = ref.watch(bookInfoViewModelProvider(widget.bookId));

    return Scaffold(
      backgroundColor: Colors.white,
      body: bookAsyncValue.when(
        data: (book) => Builder(
          builder: (context) {
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildSliverAppBar(context, book),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTitleSection(book),
                        const SizedBox(height: 16),
                        _buildInfoSection(book),
                        const SizedBox(height: 24),
                        // Static/Inline Download Button positioned high up
                        _buildDownloadButton(context, book),
                        const SizedBox(height: 32),
                        const Divider(height: 1),
                        const SizedBox(height: 24),
                        Text(
                          'About this book',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          book.summaries?.join('\n\n') ??
                              'No summary available.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Colors.grey[700],
                                height: 1.6,
                                fontSize: 16,
                              ),
                        ),
                        const SizedBox(
                          height: 100,
                        ), // Space for navbar scrolling
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, Book book) {
    return SliverAppBar(
      expandedHeight: 400,
      pinned: true,
      stretch: true,
      backgroundColor: const Color(0xFF1B4332), // Fallback
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Blurred Background
            if (book.formats?.coverImage != null)
              CachedNetworkImage(
                imageUrl: book.formats!.coverImage!,
                fit: BoxFit.cover,
                color: Colors.black.withOpacity(0.6),
                colorBlendMode: BlendMode.darken,
              )
            else
              Container(color: const Color(0xFF1B4332)),

            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(color: Colors.transparent),
            ),

            // Central Cover Image
            Center(
              child: Hero(
                tag: 'book_cover_${book.id}',
                child: Container(
                  height: 240,
                  width: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: book.formats?.coverImage != null
                        ? CachedNetworkImage(
                            imageUrl: book.formats!.coverImage!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                            errorWidget: (_, __, ___) => const Icon(
                              Icons.book,
                              size: 50,
                              color: Colors.grey,
                            ),
                          )
                        : const SizedBox(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black45, // Semi-transparent backing
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _buildTitleSection(Book book) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          book.title ?? 'Untitled',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            fontFamily: 'Serif', // Use a serif font if available or default
            letterSpacing: -0.5,
            color: Colors.black87,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          book.authors?.map((a) => a.name).join(', ') ?? 'Unknown Author',
          style: TextStyle(
            fontSize: 18,
            color: const Color(0xFF1B4332), // Forest Green accent
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection(Book book) {
    // Collect some metadata tags
    final tags = <Widget>[];
    if (book.languages != null && book.languages!.isNotEmpty) {
      tags.add(_buildTag(Icons.language, book.languages!.first.toUpperCase()));
    }
    if (book.downloadCount != null) {
      tags.add(_buildTag(Icons.download_rounded, '${book.downloadCount}'));
    }

    // Add copyright check or other metadata if available in model
    // For now showing available format types as tags
    if (book.formats?.epub != null) {
      tags.add(_buildTag(Icons.book_outlined, 'EPUB'));
    }

    return Wrap(spacing: 12, runSpacing: 12, children: tags);
  }

  Widget _buildTag(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadButton(BuildContext context, Book book) {
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_isDownloaded) {
            if (_bookFile != null) {
              _openBook(context, _bookFile!);
            }
          } else if (!_isDownloading) {
            _handleDownload(book);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _isDownloaded
              ? const Color(0xFF1B4332) // Forest Green
              : Colors.black87,
          foregroundColor: Colors.white,
          elevation: 2, // Slightly reduced elevation for inline
          shadowColor: Colors.black38,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _isDownloading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      value: _downloadProgress > 0 ? _downloadProgress : null,
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Downloading ${(_downloadProgress * 100).toInt()}%',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(_isDownloaded ? Icons.menu_book : Icons.download),
                  const SizedBox(width: 12),
                  Text(
                    _isDownloaded ? 'Read Now' : 'Download Book',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _handleDownload(Book book) async {
    final vm = ref.read(bookInfoViewModelProvider(widget.bookId).notifier);

    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.0;
    });

    try {
      await Permission.storage.request();
      final dir = await getApplicationDocumentsDirectory();
      final savePath = '${dir.path}/book_${book.id}.epub';

      await vm.downloadBook(
        book,
        savePath,
        onProgress: (progress) {
          if (mounted) {
            setState(() => _downloadProgress = progress);
          }
        },
      );

      if (mounted) {
        setState(() {
          _isDownloading = false;
          _isDownloaded = true;
          _bookFile = File(savePath);
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isDownloading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Download failed: $e')));
      }
    }
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
          appBar: AppBar(
            title: Text(file.path.split('/').last),
          ), // Can use book title if passed
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
          ),
        ),
      ),
    );
  }
}
