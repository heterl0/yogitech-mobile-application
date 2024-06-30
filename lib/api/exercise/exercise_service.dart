import 'package:dio/dio.dart';
import 'package:YogiTech/api/dioInstance.dart';
import 'package:YogiTech/src/models/exercise.dart';
import 'package:YogiTech/utils/formatting.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

Future<void> storeExercise(Exercise exercise) async {
  // Store exercise in local storage
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('exercise', exercise.toJson());
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

Future<Vote?> postVote(int commentId) async {
  try {
    final url = formatApiUrl('/api/v1/exercise-votes/');
    final Response response = await DioInstance.post(url, data: {
      'comment': commentId,
      'vote_value': 1,
    });
    if (response.statusCode == 201) {
      return Vote.fromMap(response.data);
    } else {
      print('Post vote failed with status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Post vote error: $e');
    return null;
  }
}

Future<bool> deleteVote(int voteId) async {
  try {
    final url = formatApiUrl('/api/v1/exercise-votes/$voteId/');
    final Response response = await DioInstance.delete(url);
    if (response.statusCode == 204) {
      return true;
    } else {
      print('Delete vote failed with status code: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('Delete vote error: $e');
    return false;
  }
}

Future<dynamic> postExerciseLog(dynamic data) async {
  try {
    final url = formatApiUrl('/api/v1/exercise-logs/');
    final Response response = await DioInstance.post(url, data: data);
    if (response.statusCode == 201) {
      return response.data;
    } else {
      print(
          'Post exercise log failed with status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Post exercise log error: $e');
    return null;
  }
}
