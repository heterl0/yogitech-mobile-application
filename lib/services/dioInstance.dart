import 'package:dio/dio.dart';

class DioInstance {
  static final Dio _dio = Dio();

  static void setAccessToken(String accessToken, String timezoneLocation) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['X-Client-Timezone'] = timezoneLocation.toLowerCase();
        options.headers['Authorization'] = 'Bearer $accessToken';
        return handler.next(options); //continue
      },
    ));
  }

  static Future<Response> get(String url,
      {Map<String, dynamic>? params}) async {
    return _dio.get(url, queryParameters: params);
  }

  static Future<Response> post(String url, {dynamic data}) async {
    // Check if data is of type Map and convert to FormData if necessary
    final sendData =
        data is Map<String, dynamic> ? FormData.fromMap(data) : data;
    return _dio.post(url, data: sendData);
  }

  static Future<Response> put(String url, {dynamic data}) async {
    // Check if data is of type Map and convert to FormData if necessary
    final sendData =
        data is Map<String, dynamic> ? FormData.fromMap(data) : data;
    return _dio.put(url, data: sendData);
  }

  static Future<Response> patch(String url, {dynamic data}) async {
    // Check if data is of type Map and convert to FormData if necessary
    final sendData =
        data is Map<String, dynamic> ? FormData.fromMap(data) : data;
    return _dio.patch(url, data: sendData);
  }

  static Future<Response> delete(String url,
      {Map<String, dynamic>? data}) async {
    return _dio.delete(url, data: data);
  }
}
