import 'package:dio/dio.dart';
import 'package:yogi_application/api/dioInstance.dart';
import 'package:yogi_application/src/models/pose.dart';
import 'package:yogi_application/utils/formatting.dart';

Future<List<dynamic>> getPoses() async {
  try {
    final url = formatApiUrl('/api/v1/poses/');
    final Response response = await DioInstance.get(url);
    if (response.statusCode == 200) {
      List<dynamic> data = response.data.map((e) => Pose.fromMap(e)).toList();
      return data;
    } else {
      print('Get poses failed with status code: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Get poses error: $e');
    return [];
  }
}

Future<Pose?> getPose(int id) async {
  try {
    final url = formatApiUrl('/api/v1/poses/$id/');
    final Response response = await DioInstance.get(url);
    if (response.statusCode == 200) {
      return Pose.fromMap(response.data);
    } else {
      print('Get pose detail failed with status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Get pose detail error: $e');
    return null;
  }
}

Future<List<dynamic>> getMuscles() async {
  try {
    final url = formatApiUrl('/api/v1/muscles/');
    final Response response = await DioInstance.get(url);
    if (response.statusCode == 200) {
      List<dynamic> data = response.data.map((e) => Muscle.fromMap(e)).toList();
      return data;
    } else {
      print('Get muscles failed with status code: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Get muscles error: $e');
    return [];
  }
}
