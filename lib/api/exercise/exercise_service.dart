import 'package:dio/dio.dart';
import 'package:yogi_application/api/dioInstance.dart';
import 'package:yogi_application/src/models/exercise.dart';
import 'package:yogi_application/utils/formatting.dart';

Future<List<Exercise>> getExercises() async {
  try {
    final url = formatApiUrl('/api/v1/exercises/');
    final Response response = await DioInstance.get(url);
    if (response.statusCode == 200) {
      List<Exercise> data = response.data.map((e) => Exercise.fromMap(e));
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
