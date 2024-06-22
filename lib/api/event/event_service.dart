import 'package:dio/dio.dart';
import 'package:YogiTech/api/dioInstance.dart';
import 'package:YogiTech/src/models/event.dart';
import 'package:YogiTech/utils/formatting.dart';

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

Future<CandidateEvent?> joinEvent(int id) async {
  try {
    final data = {"event": id};
    final url = formatApiUrl('/api/v1/event-candidates/');
    final response = await DioInstance.post(url, data: data);
    if (response.statusCode == 201) {
      print(response.data);
      return CandidateEvent.fromMap(response.data);
    } else {
      print(
          'Join event detail failed with status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Join event detail error: $e');
    return null;
  }
}

Future<bool?> giveUpEvent(int id) async {
  try {
    final url = formatApiUrl('/api/v1/event-candidates/$id/');
    final response = await DioInstance.delete(url);
    return response.statusCode == 204;
  } catch (e) {
    print('Give up event detail error: $e');
    return null;
  }
}
