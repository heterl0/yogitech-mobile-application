import 'package:dio/dio.dart';
import 'package:yogi_application/api/dioInstance.dart';
import 'package:yogi_application/src/models/event.dart';
import 'package:yogi_application/utils/formatting.dart';

Future<List<dynamic>> getEvents() async {
  try {
    final url = formatApiUrl('/api/v1/events/');
    final Response response = await DioInstance.get(url);
    if (response.statusCode == 200) {
      List<dynamic> data = response.data.map((e) => Event.fromMap(e)).toList();
      return data;
    } else {
      print('Get events failed with status code: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Get events error: $e');
    return [];
  }
}

Future<Event?> getEvent(int id) async {
  try {
    final url = formatApiUrl('/api/v1/events/$id/');
    final Response response = await DioInstance.get(url);
    if (response.statusCode == 200) {
      return Event.fromMap(response.data);
    } else {
      print('Get event detail failed with status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Get event detail error: $e');
    return null;
  }
}
