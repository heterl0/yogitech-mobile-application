import 'package:dio/dio.dart';
import 'package:yogi_application/api/dioInstance.dart';
import 'package:yogi_application/src/models/blog.dart';
import 'package:yogi_application/utils/formatting.dart';

Future<List<dynamic>> getBlogs() async {
  try {
    final url = formatApiUrl('/api/v1/blogs/');
    final Response response = await DioInstance.get(url);
    if (response.statusCode == 200) {
      List<dynamic> data = response.data.map((e) => Blog.fromMap(e)).toList();
      return data;
    } else {
      print('Get blogs failed with status code: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Get blogs error: $e');
    return [];
  }
}

Future<Blog?> getBlog(int id) async {
  try {
    final url = formatApiUrl('/api/v1/blogs/$id/');
    final Response response = await DioInstance.get(url);
    if (response.statusCode == 200) {
      return Blog.fromMap(response.data);
    } else {
      print('Get blog detail failed with status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Get blog detail error: $e');
    return null;
  }
}


