import 'package:dio/dio.dart';

class ApiService {
  final baseUrl = 'https://gutendex.com/';
  final Dio _dio = Dio();

  Future<Response> get(String endpoint, [Map<String, dynamic>? queryParams]) async {
    return await _dio.get('$baseUrl$endpoint', queryParameters: queryParams);
  }

  Future<Response> post(String endpoint, Map<String, dynamic> data) async {
    return await _dio.post('$baseUrl$endpoint', data: data);
  }

  Future<Response> download(String url, String savePath, {Function(int, int)? onReceiveProgress}) async {
    return await _dio.download(url, savePath, onReceiveProgress: onReceiveProgress);
  }
}
