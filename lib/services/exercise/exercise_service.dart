import 'package:YogiTech/models/pose.dart';
import 'package:YogiTech/services/dioInstance.dart';
import 'package:YogiTech/services/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:YogiTech/models/exercise.dart';
import 'package:YogiTech/utils/formatting.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<dynamic>> getExercises() async {
  try {
    final url = formatApiUrl('/api/v1/exercises/');
    final Response response = await DioInstance.get(url);
    if (response.statusCode == 200) {
      List<dynamic> data =
          response.data.map((e) => Exercise.fromMap(e)).toList();
      data = data.where((e) => e.active_status == 1).toList();
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

Future<void> storeExercise(Exercise exercise, int? event_id) async {
  // Store exercise in local storage
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('exercise', exercise.toJson());
  if (event_id != null) {
    await prefs.setString('event_id', event_id.toString());
  }
}

Future<bool> checkEvent() async {
  final prefs = await SharedPreferences.getInstance();
  final event_id = prefs.getString('event_id');
  if (event_id != null) {
    prefs.remove('event_id');
    return true;
  }
  return false;
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

Future<bool> isExerciseToday() async {
  int timezoneOffset = DateTime.now().timeZoneOffset.inMinutes;

  try {
    final url = formatApiUrl('/api/v1/exercise-logs/today/');

    // final Response response = await DioInstance.get(url);
    final Dio dio = DioClient.create(); // Sử dụng custom Dio client
    final Response response = await dio.get(url);
    if (response.statusCode == 200) {
      List<dynamic> logs = response.data;
      print('Thời gian kiểm tra: ${DateTime.now()}');
      return logs.isNotEmpty;
    } else {
      print(
          'Check exercise log failed with status code: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('Check exercise log error: $e');
    return false;
  }
}

class PostPersonalExerciseRequest {
  String title;
  int level;
  List<Pose> poses;
  List<int> duration;

  PostPersonalExerciseRequest({
    required this.title,
    required this.level,
    required this.poses,
    required this.duration,
  });
}

Future<dynamic> postPersonalExercise(
    PostPersonalExerciseRequest request) async {
  try {
    final url = formatApiUrl('/api/v1/exercises/');
    final pose = request.poses.map((e) => e.id).toList();
    final time = pose.map((e) => 0).toList();
    int durations = 0;
    for (int i = 0; i < request.poses.length; i++) {
      durations += request.duration[i];
    }
    double calories = 0;
    for (int i = 0; i < request.poses.length; i++) {
      Pose pose = request.poses[i];
      calories +=
          double.parse(pose.calories) * request.duration[i] / pose.duration;
    }
    final Response response = await DioInstance.post(url, data: {
      "title": request.title,
      "level": request.level,
      "pose": pose,
      "time": time,
      "durations": durations,
      "calories": calories.toStringAsFixed(2),
      "duration": request.duration,
      "point": 1,
      "number_poses": request.poses.length,
      "is_premium": true,
    });
    if (response.statusCode == 201) {
      return Exercise.fromMap(response.data);
    } else {
      print('Create exercise failed with status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    if (e is DioException) {
      print(e.response!.data);
    }
    print('Create exercise  error: $e');
    return null;
  }
}

Future<List<Exercise>> getPersonalExercise() async {
  // Thay dynamic thành List<Exercise>
  try {
    final url = formatApiUrl('/api/v1/exercise-personal/');
    final Response response = await DioInstance.get(url);

    if (response.statusCode == 200) {
      // Chuyển đổi từng phần tử thành Exercise
      List<Exercise> data = (response.data as List)
          .map((e) => Exercise.fromMap(e as Map<String, dynamic>))
          .toList();

      data = data.where((e) => e.active_status == 1).toList();
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

Future<dynamic> patchDisablePersonalExercise(int id) async {
  try {
    final url = formatApiUrl('/api/v1/exercises/$id/');
    final Response response = await DioInstance.patch(url, data: {
      "active_status": 0,
    });
    if (response.statusCode == 200) {
      return response.data;
    } else {
      print(
          'Disable personal exercise failed with status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Disable personal exercise error: $e');
    return null;
  }
}

Future<dynamic> patchUpdatePersonalExercise(
    int id, PostPersonalExerciseRequest request) async {
  try {
    final url = formatApiUrl('/api/v1/exercises/$id/');
    final pose = request.poses.map((e) => e.id).toList();
    final time = pose.map((e) => 0).toList();
    int durations = 0;
    for (int i = 0; i < request.poses.length; i++) {
      durations += request.duration[i];
    }
    double calories = 0;
    for (int i = 0; i < request.poses.length; i++) {
      Pose pose = request.poses[i];
      calories +=
          double.parse(pose.calories) * request.duration[i] / pose.duration;
    }
    final Response response = await DioInstance.patch(url, data: {
      "title": request.title,
      "level": request.level,
      "pose": pose,
      "time": time,
      "durations": durations,
      "calories": calories,
      "duration": request.duration,
      "point": 1,
      "number_poses": request.poses.length,
      "is_premium": true,
    });
    if (response.statusCode == 200) {
      return Exercise.fromMap(response.data);
    } else {
      print('Update exercise failed with status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Update exercise  error: $e');
    return null;
  }
}
