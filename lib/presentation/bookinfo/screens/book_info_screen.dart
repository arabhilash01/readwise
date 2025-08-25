import 'package:dio/dio.dart';
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
  final _dio = Dio();

  @override
  Widget build(BuildContext context) {
    final bookAsyncValue = ref.watch(bookInfoViewModelProvider(widget.bookId));
    final vm = ref.watch(bookInfoViewModelProvider(widget.bookId).notifier);

    return Scaffold(
      body: bookAsyncValue.when(
        data: (data) => SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                fit: StackFit.passthrough,
                clipBehavior: Clip.none,
                children: [
                  const DecoratedBox(
                    decoration: BoxDecoration(color: Colors.grey),
                    child: SizedBox(width: double.infinity, height: 200),
                  ),
                  Positioned(
                    top: 60,
                    left: 10,
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.arrow_back_ios_outlined),
                    ),
                  ),
                  Positioned(
                    bottom: -80,
                    child: SizedBox(width: 180, height: 180, child: Image.network(data.formats?.coverImage ?? '')),
                  ),
                ],
              ),
              const Gap(80),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.title ?? '', style: TextStyles.ui18SemiBold),
                    Text(author(data), style: TextStyles.ui13Medium),
                    const Gap(16),
                    Text(summary(data), style: TextStyles.ui15Medium),
                    ElevatedButton(
                      onPressed: () async {
                        print(data.formats?.epub);
                        final dir = await getApplicationDocumentsDirectory(); // or getExternalStorageDirectory()
                        final savePath = '${dir.path}/book_${data.id}.epub';
                        await Permission.storage.request();
                        await _dio.download(
                          data.formats?.epub ?? '',
                          savePath,
                          onReceiveProgress: (count, total) {
                            print((count / total).toString());
                          },
                        );
                        // await vm.downloadBook(
                        //   data.formats?.epub ?? '',
                        //   data.id.toString(),
                        //   onProgress: (p0) {
                        //     print(p0.toString());
                        //   },
                        // );
                      },
                      child: const Text('Epub download'),
                    ),
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

  String summary(Book book) => book.summaries?.join(',').toString() ?? '';

  String author(Book book) => book.authors?.map((author) => author.name).join(',').toString() ?? '';
}
