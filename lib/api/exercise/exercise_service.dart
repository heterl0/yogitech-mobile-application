import 'package:dio/dio.dart';
import 'package:yogi_application/api/dioInstance.dart';
import 'package:yogi_application/src/models/exercise.dart';
import 'package:yogi_application/utils/formatting.dart';

Future<List<dynamic>> getExercises() async {
  try {
    final url = formatApiUrl('/api/v1/exercises/');
    final Response response = await DioInstance.get(url);
    if (response.statusCode == 200) {
      List<dynamic> data =
          response.data.map((e) => Exercise.fromMap(e)).toList();
      return data;
    } else {
      print('Get exercises failed with status code: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Get exercises error: $e');
    return [];
  }
}

Future<Exercise?> getExercise(int id) async {
  try {
    final url = formatApiUrl('/api/v1/exercises/$id/');
    final Response response = await DioInstance.get(url);
    if (response.statusCode == 200) {
      return Exercise.fromMap(response.data);
    } else {
      print(
          'Get exercise detail failed with status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Get exercise detail error: $e');
    return null;
  }
}

class PostCommentRequest {
  String? text;
  int? exercise;
  int? parentComment;

  PostCommentRequest({
    required this.text,
    required this.exercise,
    this.parentComment,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    if (text != null) {
      data['text'] = text;
    }
    if (exercise != null) {
      data['exercise'] = exercise;
    }
    if (parentComment != null) {
      data['parent_comment'] = parentComment;
    }
    return data;
  }
}

Future<Comment?> postComment(PostCommentRequest data) async {
  try {
    final url = formatApiUrl('/api/v1/exercise-comments/');
    final Response response = await DioInstance.post(url, data: data.toMap());
    if (response.statusCode == 201) {
      return Comment.fromMap(response.data);
    } else {
      print('Post comment failed with status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Post comment error: $e');
    return null;
  }
}
