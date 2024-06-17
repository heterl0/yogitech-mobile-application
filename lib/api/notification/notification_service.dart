import 'package:dio/dio.dart';
import 'package:yogi_application/api/dioInstance.dart';
import 'package:yogi_application/src/models/notification.dart';
import 'package:yogi_application/utils/formatting.dart';

Future<List<dynamic>> getNotifications() async {
  try {
    final url = formatApiUrl('/api/v1/notification/');
    final Response response = await DioInstance.get(url);
    if (response.statusCode == 200) {
      List<dynamic> data =
          response.data.map((e) => Notification.fromMap(e)).toList();
      return data;
    } else {
      print(
          'Get notifications failed with status code: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Get notifications error: $e');
    return [];
  }
}

Future<Notification?> getNotification(int id) async {
  try {
    final url = formatApiUrl('/api/v1/notification/$id/');
    final Response response = await DioInstance.get(url);
    if (response.statusCode == 200) {
      return Notification.fromMap(response.data);
    } else {
      print(
          'Get notification detail failed with status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Get notification detail error: $e');
    return null;
  }
}
