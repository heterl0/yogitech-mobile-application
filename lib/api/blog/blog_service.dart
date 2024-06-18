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

Future<BlogVote?> voteBlog(int id, int value) async {
  try {
    final url = formatApiUrl('/api/v1/votes/');
    final data = {
      'blog_id': id,
      'vote_value': value,
    };
    final Response response = await DioInstance.post(url, data: data);
    if (response.statusCode == 201) {
      return BlogVote.fromMap(response.data);
    } else {
      print('Vote blog failed with status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Vote blog detail error: $e');
    return null;
  }
}

Future<bool?> removeVoteBlog(int idVote) async {
  try {
    final url = formatApiUrl('/api/v1/votes/$idVote');
    final Response response = await DioInstance.delete(url);
    return response.statusCode == 200;
  } catch (e) {
    print('Vote blog detail error: $e');
    return false;
  }
}

Future<BlogVote?> updateVoteBlog(int idVote, int value) async {
  try {
    final url = formatApiUrl('/api/v1/votes/');
    final data = {
      'vote_value': value,
    };
    final Response response = await DioInstance.patch(url, data: data);
    if (response.statusCode == 200) {
      return BlogVote.fromMap(response.data);
    } else {
      print('Update vote blog failed with status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Update vote blog detail error: $e');
    return null;
  }
}
