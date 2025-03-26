import 'package:dio/dio.dart';

class DioClient {
  static Dio create() {
    Dio dio = Dio();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          int timezoneOffset = DateTime.now().timeZoneOffset.inMinutes;
          options.headers['X-Client-Timezone'] = timezoneOffset.toString();
          return handler.next(options);
        },
      ),
    );
    return dio;
  }
}
