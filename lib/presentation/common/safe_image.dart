import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SafeCoverImage extends StatelessWidget {
  final String url;
  const SafeCoverImage({super.key, required this.url});

  Future<Uint8List?> _loadImageBytes(String url) async {
    try {
      final response = await Dio().get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes, followRedirects: true),
      );

      final contentType = response.headers.value('content-type') ?? '';
      if (!contentType.startsWith('image/')) {
        // Not an image
        return null;
      }
      return Uint8List.fromList(response.data!);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: _loadImageBytes(url),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const CircularProgressIndicator();
        }
        if (snapshot.data == null) {
          return const Icon(Icons.image_not_supported);
        }
        return Image.memory(snapshot.data!, fit: BoxFit.cover);
      },
    );
  }
}
