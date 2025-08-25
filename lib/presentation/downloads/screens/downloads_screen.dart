import 'dart:io';

import 'package:epub_view/epub_view.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:readwise/presentation/common/custom_appbar.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';

class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({super.key});

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: 'Downloads'),
      body: FutureBuilder(
        future: getDownloadedBooks(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final epubController = EpubController(document: EpubDocument.openFile(snapshot.data!.first));
            return EpubView(controller: epubController);
            // return Column(
            //   children: [
            //     Text(snapshot.data?.map((e) => e.path ?? '').toString() ?? 'nothing present'),
            //     TextButton(
            //       onPressed: () {
            //         VocsyEpub.setConfig(
            //           themeColor: Theme.of(context).primaryColor,
            //           identifier: "iosBook",
            //           scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
            //           allowSharing: true,
            //           enableTts: true,
            //           nightMode: true,
            //         );
            //
            //         // get current locator
            //         VocsyEpub.locatorStream.listen((locator) {
            //           print('LOCATOR: $locator');
            //         });
            //
            //         VocsyEpub.open(
            //           snapshot.data?.firstOrNull?.path ?? '',
            //           // lastLocation: EpubLocator.fromJson({
            //           //   "bookId": "2239",
            //           //   "href": "/OEBPS/ch06.xhtml",
            //           //   "created": 1539934158390,
            //           //   "locations": {"cfi": "epubcfi(/0!/4/4[simple_book]/2/2/6)"}
            //           // }),
            //         );
            //       },
            //       child: Text('Open epub'),
            //     ),
            //   ],
            // );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future<List<File>> getDownloadedBooks() async {
    final dir = await getApplicationDocumentsDirectory();
    final files = dir.listSync();
    return files.whereType<File>().where((f) => f.path.endsWith('.epub')).toList();
  }
}
