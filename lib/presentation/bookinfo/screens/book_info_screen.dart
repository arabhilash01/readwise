import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:readwise/presentation/bookinfo/vm/book_info_vm.dart';
import 'package:readwise/presentation/reader/screens/reader_screen.dart';
import 'package:readwise/shared/models/book_model.dart';
import 'package:gap/gap.dart';

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
        data: (book) => CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildSliverAppBar(context, book),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(24),
                    _buildTitleSection(book),
                    const Gap(16),
                    _buildTagsSection(book),
                    const Gap(32),
                    _buildActionButtons(context, book),
                    const Gap(32),
                    const Divider(height: 1, color: Color(0xFFEEEEEE)),
                    const Gap(32),
                    Text(
                      'About the Book',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Serif',
                            color: const Color(0xFF2D3436),
                          ),
                    ),
                    const Gap(16),
                    Text(
                      book.summaries?.join('\n\n') ??
                          'No summary available for this title.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[700],
                        height: 1.8,
                        fontSize: 16,
                        fontFamily: 'Serif',
                      ),
                    ),
                    const Gap(100), // Bottom padding
                  ],
                ),
              ),
            ),
          ],
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFF1B4332)),
        ),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context, Book book) {
    return SliverAppBar(
      expandedHeight: 450,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Blurred Background
            if (book.formats?.coverImage != null)
              CachedNetworkImage(
                imageUrl: book.formats!.coverImage!,
                fit: BoxFit.cover,
                color: Colors.white.withOpacity(0.9),
                colorBlendMode: BlendMode.lighten,
              ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.2),
                      Colors.white.withOpacity(0.95),
                      Colors.white,
                    ],
                    stops: const [0.0, 0.8, 1.0],
                  ),
                ),
              ),
            ),

            // Cover Image
            Center(
              child: Hero(
                tag: 'book_cover_${book.id}',
                child: Container(
                  height: 280,
                  width: 190,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: book.formats?.coverImage != null
                        ? CachedNetworkImage(
                            imageUrl: book.formats!.coverImage!,
                            fit: BoxFit.cover,
                            placeholder: (_, __) =>
                                Container(color: Colors.grey[200]),
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
    );
  }

  Widget _buildTitleSection(Book book) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          book.title ?? 'Untitled',
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            fontFamily: 'Serif',
            height: 1.2,
            color: Color(0xFF2D3436),
            letterSpacing: -0.5,
          ),
        ),
        const Gap(8),
        Text(
          book.authors?.map((a) => a.name).join(', ') ?? 'Unknown Author',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildTagsSection(Book book) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        if (book.languages?.isNotEmpty ?? false)
          _buildTag(Icons.language, book.languages!.first.toUpperCase()),
        if (book.downloadCount != null)
          _buildTag(Icons.download_rounded, '${book.downloadCount} downloads'),
        // Add more metadata chips here
      ],
    );
  }

  Widget _buildTag(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE1E1E1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.black54),
          const Gap(6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, Book book) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 58,
            child: ElevatedButton(
              onPressed: () {
                if (_isDownloaded) {
                  if (_bookFile != null) _openBook(context, _bookFile!);
                } else if (!_isDownloading) {
                  _handleDownload(book);
                }
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: const Color(0xFF1B4332), // Forest Green
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: _isDownloading
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            value: _downloadProgress > 0
                                ? _downloadProgress
                                : null,
                            color: Colors.white,
                          ),
                        ),
                        const Gap(12),
                        Text(
                          'Downloading ${(_downloadProgress * 100).toInt()}%',
                        ),
                      ],
                    )
                  : Text(
                      _isDownloaded ? 'Read Now' : 'Download Book',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ),
        const Gap(16),
        Container(
          height: 58,
          width: 58,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F6F7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE1E1E1)),
          ),
          child: IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black87),
            onPressed: () {
              // TODO: Implement favorites
            },
          ),
        ),
      ],
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
          if (mounted) setState(() => _downloadProgress = progress);
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
    if (!context.mounted) return;
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => ReaderScreen(bookFile: file, bookId: widget.bookId),
      ),
    );
  }
}
