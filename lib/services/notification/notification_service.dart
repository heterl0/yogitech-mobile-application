import 'package:YogiTech/services/dioInstance.dart';
import 'package:dio/dio.dart';
import 'package:YogiTech/models/notification.dart';
import 'package:YogiTech/utils/formatting.dart';

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

class PostNotificationRequest {
  String? title;
  String? body;

  PostNotificationRequest({
    required this.title,
    required this.body,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    if (title != null) {
      data['title'] = title;
    }
    if (body != null) {
      data['body'] = body;
    }
    data['is_admin'] = false;
    data['time'] = DateTime.now().toIso8601String();
    return data;
  }
}

Future<Notification?> postNotification(PostNotificationRequest data) async {
  try {
    final url = formatApiUrl('/api/v1/notification/create/');
    final Response response = await DioInstance.post(url, data: data.toMap());
    if (response.statusCode == 201) {
      return Notification.fromMap(response.data);
    } else {
      print(
          'Post notification failed with status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Post notification error: $e');
    return null;
  }
}
