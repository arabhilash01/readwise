import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:readwise/app/theme/text_styles.dart';
import 'package:readwise/presentation/bookinfo/vm/book_info_vm.dart';
import 'package:readwise/shared/models/book_model.dart';

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

  @override
  Widget build(BuildContext context) {
    final bookAsyncValue = ref.watch(bookInfoViewModelProvider(widget.bookId));

    return Scaffold(
      body: bookAsyncValue.when(
        data: (data) => SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                clipBehavior: Clip.none,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: NetworkImage(data.formats?.coverImage ?? ''),
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.5),
                          BlendMode.darken,
                        ),
                      ),
                    ),
                    child: const SizedBox(width: double.infinity, height: 200),
                  ),
                  Positioned(
                    top: 60,
                    left: 10,
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(
                        Icons.arrow_back_ios_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -80,
                    left: 20,
                    child: SizedBox(
                      width: 180,
                      height: 180,
                      child: Image.network(data.formats?.coverImage ?? ''),
                    ),
                  ),
                ],
              ),
              const Gap(90),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.title ?? '', style: TextStyles.ui18SemiBold),
                    Text(author(data), style: TextStyles.ui13Medium),
                    const Gap(16),
                    Text(summary(data), style: TextStyles.ui15Medium),
                    const Gap(20),
                    _buildDownloadButton(data),
                    const Gap(20),
                  ],
                ),
              ),
              const Gap(100),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => const Center(child: Text('Error')),
      ),
    );
  }

  Widget _buildDownloadButton(Book data) {
    final vm = ref.read(bookInfoViewModelProvider(widget.bookId).notifier);
    return GestureDetector(
      onTap: _isDownloading || _isDownloaded
          ? null
          : () async {
              setState(() {
                _isDownloading = true;
                _downloadProgress = 0.0;
              });
              await Permission.storage.request();
              final dir = await getApplicationDocumentsDirectory();
              final savePath = '${dir.path}/book_${data.id}.epub';
              try {
                await vm.downloadBook(
                  data.formats?.epub ?? '',
                  savePath,
                  onProgress: (progress) {
                    setState(() {
                      _downloadProgress = progress;
                    });
                  },
                );
                setState(() {
                  _isDownloading = false;
                  _isDownloaded = true;
                });
              } catch (e) {
                setState(() {
                  _isDownloading = false;
                  _isDownloaded = false;
                });
              }
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: _isDownloaded
              ? Colors.green
              : Theme.of(context).colorScheme.primary,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (_isDownloading)
              LayoutBuilder(
                builder: (context, constraints) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    width: constraints.maxWidth * _downloadProgress,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  );
                },
              ),
            Center(
              child: Text(
                _isDownloading
                    ? 'Downloading ${(_downloadProgress * 100).toStringAsFixed(0)}%'
                    : _isDownloaded
                    ? 'Downloaded ✅'
                    : 'Download EPUB',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String summary(Book book) => book.summaries?.join(',').toString() ?? '';

  String author(Book book) =>
      book.authors?.map((author) => author.name).join(',').toString() ?? '';

  void downloadEpub(Book data) async {
    final vm = ref.read(bookInfoViewModelProvider(widget.bookId).notifier);
    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.0;
    });
    await Permission.storage.request();
    final dir = await getApplicationDocumentsDirectory();
    final savePath = '${dir.path}/book_${data.id}.epub';
    try {
      await vm.downloadBook(
        data.formats?.epub ?? '',
        savePath,
        onProgress: (progress) {
          setState(() {
            _downloadProgress = progress;
          });
        },
      );
      setState(() {
        _isDownloading = false;
        _isDownloaded = true;
      });
    } catch (e) {
      setState(() {
        _isDownloading = false;
        _isDownloaded = false;
      });
    }
  }
}
