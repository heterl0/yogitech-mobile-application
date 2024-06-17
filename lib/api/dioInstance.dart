import 'package:dio/dio.dart';

class DioInstance {
  static final Dio _dio = Dio();

  static void setAccessToken(String accessToken) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['Authorization'] = 'Bearer $accessToken';
          return handler.next(options); //continue
        },
      ),
    );
  }

  static Future<Response> get(String url,
      {Map<String, dynamic>? params}) async {
    return _dio.get(url, queryParameters: params);
  }

  static Future<Response> post(String url, {Map<String, dynamic>? data}) async {
    return _dio.post(url, data: data);
  }

  static Future<Response> put(String url, {Map<String, dynamic>? data}) async {
    return _dio.put(url, data: data);
  }

  static Future<Response> patch(String url,
      {Map<String, dynamic>? data}) async {
    return _dio.patch(url, data: data);
  }

  static Future<Response> delete(String url,
      {Map<String, dynamic>? data}) async {
    return _dio.delete(url, data: data);
  }
}
